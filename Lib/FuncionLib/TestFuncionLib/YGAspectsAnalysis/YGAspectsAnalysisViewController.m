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




@implementation NSArray (ForwardingIteration)


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if(aSelector == @selector(setHidden:)){
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return nil;
}

// Invoke the invocation on whichever real object had a signature for it.
- (void)forwardInvocation:(NSInvocation *)invocation {
    NSLog(@"dddddddddddddddd  setHidden");
//    id target = [realObject1 methodSignatureForSelector:[invocation selector]] ? realObject1 : realObject2;
//    [invocation invokeWithTarget:target];
}
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
//{
//    NSMethodSignature *sig = [super methodSignatureForSelector:sel];
//    if(!sig)
//    {
//        for(id obj in self)
//            if((sig = [obj methodSignatureForSelector:sel]))
//                break;
//    }
//    return sig;
//}
//
//- (void)forwardInvocation:(NSInvocation *)inv
//{
//    for(id obj in self)
//        [inv invokeWithTarget:obj];
//}

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

/*
一.消息转发流程
当向Objective-C对象发送一个消息，但runtime在当前类及父类中找不到此selector对应的方法时，消息转发(message forwarding)流程开始启动。

1:动态方法解析(Dynamic Method Resolution或Lazy method resolution)
向当前类(Class)发送resolveInstanceMethod:(对于类方法则为resolveClassMethod:)消息，如果返回YES,则系统认为请求的方法已经加入到了，则会重新发送消息。
2:快速转发路径(Fast forwarding path)
若果当前target实现了forwardingTargetForSelector:方法,则调用此方法。如果此方法返回除nil和self的其他对象，则向返回对象重新发送消息。
3:慢速转发路径(Normal forwarding path)
首先runtime发送methodSignatureForSelector:消息查看Selector对应的方法签名，即参数与返回值的类型信息。如果有方法签名返回，runtime则根据方法签名创建描述该消息的NSInvocation，向当前对象发送forwardInvocation:消息，以创建的NSInvocation对象作为参数；若methodSignatureForSelector:无法签名返回，则向当前对象发送doesNotRecognizeSelector:消息,程序抛出异常退出。

二.动态解析(Lazy Resolution)
runtime发送消息的流程即查找该消息对应的方法或IMP,然后跳转至对应的IMP。有时候我们不想事先在类中设置好方法，而想在运行时动态的在类中插入IMP。这种方法是真正的快速”转发”,因为一旦对应的方法被添加到类中，后续的方法调用就是正常的消息发送流程。此方法的缺点是不够灵活，你必须有此方法的实现(IMP),这意味这你必须事先预测此方法的参数和返回值类型。

@dynamic属性是使用动态解析的一个例子，@dynamic告诉编译器该属性对应的getter或setter方法会在运行时提供，所以编译器不会出现warning； 然后实现resolveInstanceMethod:方法在运行时将属性相关的方法加入到Class中。

当respondsToSelector:或instancesRespondToSelector:方法被调用时，若该方法在类中未实现，动态方法解析器也会被调用，这时可向类中增加IMP,并返回YES,则对应的respondsToSelector:的方法也返回YES。

三.快速转发(Fast Forwarding)
runtime然后会检查你是否想将此消息不做改动的转发给另外一个对象，这是比较常见的消息转发情形，可以用较小的消耗完成。
快速转发技术可以用来实现伪多继承，你只需编写如下代码

- (id)forwardingTargetForSelector:(SEL)sel { return _otherObject; }
这样做会将任何位置的消息都转发给_otherObject对象，尽管当前对象与_otherObject对象是包含关系，但从外界看来当前对象和_otherObject像是同一个对象。
伪多继承与真正的多继承的区别在于，真正的多继承是将多个类的功能组合到一个对象中，而消息转发实现的伪多继承，对应的功能仍然分布在多个对象中，但是将多个对象的区别对消息发送者透明。

四.慢速转发(Normal Forwarding)
以上两者方式是对消息转发的优化，如果你不使用上述两种方式，则会进入完整的消息转发流程。这会创建一个NSInvocation对象来完全包含发送的消息，其中包括target,selector,所有的参数，返回值。

在runtime构建NSInvocation之前首先需要一个NSMethodSignature，所以它通过-methodSignatureForSelector:方法请求。一旦NSInvocation创建完成，runtime就会调用forwardInvocation:方法，在此方法内你可以使用参数中的invocation做任何事情。无限可能…
举个例子，如果你想对一个NSArray中的所有对象调用同一个方法，而又不想一直写循环代码时，想直接操作NSArray时，可这样处理
 */
-(void)test2{
    SEL selector = @selector(function:);
    Class klass = aspect_hookClass(self, nil);//生成self的一个子类
    Method targetMethod = class_getInstanceMethod(klass, selector);
    const char *typeEncoding = method_getTypeEncoding(targetMethod);
    // We use forwardInvocation to hook in.
    class_replaceMethod(klass, selector, _objc_msgForward, typeEncoding);
//    class_replaceMethod返回的是原方法对应的IMP,如果原来方法没有实现就返回nil,调用了class_replaceMethod会把原来方法的IMP指向另一个方法的实现

}

-(void)test3{
    NSArray*array = [NSArray new];
    [(UIView *)array setHidden:YES];
    [self function:@"ddddddd"];
}

-(void)function:(NSString*)function{
    NSLog(@"%@",function);
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
        //    objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes)
        //    添加类 superclass 类是父类   name 类的名字  size_t 类占的空间
        subclass = objc_allocateClassPair(baseClass, subclassName, 0);//注册添加后缀的类名
        aspect_swizzleForwardInvocation(subclass);//类方法交换
        objc_registerClassPair(subclass);
    }
    object_setClass(self, subclass);
    return subclass;
}

static void aspect_swizzleForwardInvocation(Class klass) {
//    class_replaceMethod返回的是原方法对应的IMP,如果原来方法没有实现就返回nil,调用了class_replaceMethod会把原来方法的IMP指向另一个方法的实现
    class_replaceMethod(klass, @selector(forwardInvocation:), (IMP)__ASPECTS_ARE_BEING_CALLED__, "v@:@");
}
// This is the swizzled forwardInvocation: method.
static void __ASPECTS_ARE_BEING_CALLED__(__unsafe_unretained NSObject *self, SEL selector, NSInvocation *invocation) {
    NSLog(@"__ASPECTS_ARE_BEING_CALLED__  __ASPECTS_ARE_BEING_CALLED__");
}
@end
