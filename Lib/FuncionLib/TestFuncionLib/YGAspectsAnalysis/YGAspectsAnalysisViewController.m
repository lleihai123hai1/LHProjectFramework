//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//
#import "YGAspectsAnalysisViewController.h"
#import <libkern/OSAtomic.h>
#import <objc/runtime.h>
#import <objc/message.h>
static NSString *const AspectsSubclassSuffix = @"_Aspects_";
static NSString *const AspectsMessagePrefix = @"aspects_";
@implementation Person1
-(void)testPrint{
    NSLog(@"Person1_%@",self.name1);
}
@end
@implementation Person2
-(void)testPrint{
    //这样执行会闪退
//    Person1*obj = (Person1*)self;
//    NSLog(@"Person2_%@", obj.name1);
    
    NSLog(@"Person2_%@",self.name2);
}
@end
@implementation Person3
@end
@interface YGAspectsAnalysisViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*table;
@end

@implementation YGAspectsAnalysisViewController

{
    NSArray *_contenArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _contenArray = @[@{@"title":@"test1",@"content":@"object_setClass"},
                     @{@"title":@"test2",@"content":@"forwardInvocation可以将消息同时转发给任意多个对象"},
                     @{@"title":@"test3",@"content":@"模块拆分案例3"}];
    [self.view addSubview:self.table];
    [self.table reloadData];
}

-(void)test1{
    Person1 * p1 = [[Person1 alloc] init];
    NSLog(@"未改变前 - %@", [p1 class]);
    p1.name1 = @"name1";
    [p1 testPrint];
    Class oldClass = object_setClass(p1, [Person2 class]);//返回p1当前的类名，p1会指向Person2，p1的存储属性都变成Person2对应的
    NSLog(@"改变前  - %@", [oldClass class]);
    NSLog(@"改变后 - %@", [p1 class]);
    ((Person2*) p1).name2 = @"name2";
    [p1 testPrint];
    
}
-(void)test2{
    SEL selector = @selector(test3);
   Class klass = aspect_hookClass(self, nil);//生成self的一个子类
    Method targetMethod = class_getInstanceMethod(klass, selector);
    const char *typeEncoding = method_getTypeEncoding(targetMethod);
    // We use forwardInvocation to hook in.
    class_replaceMethod(klass, selector, aspect_getMsgForwardIMP(self, selector), typeEncoding);
//    objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes)
//    添加类 superclass 类是父类   name 类的名字  size_t 类占的空间
}


static IMP aspect_getMsgForwardIMP(NSObject *self, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    // As an ugly internal runtime implementation detail in the 32bit runtime, we need to determine of the method we hook returns a struct or anything larger than id.
    // https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/783
    // http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf (Section 5.4)
    Method method = class_getInstanceMethod(self.class, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}


-(void)test3{
    
}

#pragma mark - tableview datasourece and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contenArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"test";
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary*dict = _contenArray[indexPath.row];
    cell.titleLabel.text = [dict strValue:@"title"];
    cell.contentLabel.text = [dict strValue:@"content"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*dict = self->_contenArray[indexPath.row];
    SEL selecter = NSSelectorFromString([dict strValue:@"title"]);
    if([self respondsToSelector:selecter]){
        [self performSelector:selecter];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.frame.size.width tableView:tableView];;
}
-(UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.separatorInset = UIEdgeInsetsZero;
    }
    return _table;
}

static Class aspect_hookClass(NSObject *self, NSError **error) {
    Class statedClass = self.class;
    Class baseClass = object_getClass(self);
    NSString *className = NSStringFromClass(baseClass);
    // Default case. Create dynamic subclass.
    const char *subclassName = [className stringByAppendingString:AspectsSubclassSuffix].UTF8String;
    Class subclass = objc_getClass(subclassName);//获取添加后缀的类名
    if (subclass == nil) {
        subclass = objc_allocateClassPair(baseClass, subclassName, 0);//注册添加后缀的类名
        if (subclass == nil) {
            return nil;
        }
        aspect_swizzleForwardInvocation(subclass);//类方法交换
        objc_registerClassPair(subclass);
    }
    object_setClass(self, subclass);
    return subclass;
}
static NSString *const AspectsForwardInvocationSelectorName = @"__aspects_forwardInvocation:";
static void aspect_swizzleForwardInvocation(Class klass) {
    NSCParameterAssert(klass);
    // If there is no method, replace will act like class_addMethod.
    IMP originalImplementation = class_replaceMethod(klass, @selector(forwardInvocation:), (IMP)__ASPECTS_ARE_BEING_CALLED__, "v@:@");
//    class_replaceMethod返回的是原方法对应的IMP,如果原来方法没有实现就返回nil,调用了class_replaceMethod会把原来方法的IMP指向另一个方法的实现
    if (originalImplementation) {
        class_addMethod(klass, NSSelectorFromString(AspectsForwardInvocationSelectorName), originalImplementation, "v@:@");
    }
}

// This is the swizzled forwardInvocation: method.
static void __ASPECTS_ARE_BEING_CALLED__(__unsafe_unretained NSObject *self, SEL selector, NSInvocation *invocation) {
    NSLog(@"__ASPECTS_ARE_BEING_CALLED__  __ASPECTS_ARE_BEING_CALLED__");
}
@end
