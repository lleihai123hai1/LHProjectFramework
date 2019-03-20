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
    //    objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes)
    //    添加类 superclass 类是父类   name 类的名字  size_t 类占的空间
    SEL selector = @selector(test3);
    Class klass = aspect_hookClass(self, nil);//生成self的一个子类
    Method targetMethod = class_getInstanceMethod(klass, selector);
    const char *typeEncoding = method_getTypeEncoding(targetMethod);
    // We use forwardInvocation to hook in.
    class_replaceMethod(klass, selector, _objc_msgForward, typeEncoding);

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
    Class baseClass = object_getClass(self);
    NSString *className = NSStringFromClass(baseClass);
    const char *subclassName = [className stringByAppendingString:AspectsSubclassSuffix].UTF8String;
    Class subclass = objc_getClass(subclassName);//获取添加后缀的类名
    if (subclass == nil) {
        subclass = objc_allocateClassPair(baseClass, subclassName, 0);//注册添加后缀的类名
        aspect_swizzleForwardInvocation(subclass);//类方法交换
        objc_registerClassPair(subclass);
    }
    object_setClass(self, subclass);
    return subclass;
}

static void aspect_swizzleForwardInvocation(Class klass) {
    class_replaceMethod(klass, @selector(forwardInvocation:), (IMP)__ASPECTS_ARE_BEING_CALLED__, "v@:@");
}
// This is the swizzled forwardInvocation: method.
static void __ASPECTS_ARE_BEING_CALLED__(__unsafe_unretained NSObject *self, SEL selector, NSInvocation *invocation) {
    NSLog(@"__ASPECTS_ARE_BEING_CALLED__  __ASPECTS_ARE_BEING_CALLED__");
}
@end
