//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import "YGAOPManagerViewController.h"
#import "YGAOPManager.h"

@implementation YGAOPNSObject1
-(void)setObj1Str:(NSString*)obj1Str{
    _obj1Str = obj1Str;
    NSLog(@"YGAOPNSObject1_setObj1Str_%@",_obj1Str);
}
-(NSString*)getObj1Str{
    NSLog(@"YGAOPNSObject1_getObj1Str_%@",_obj1Str);
    return _obj1Str;
}
-(void)Object1{
    NSLog(@"YGAOPNSObject1_Object1");
}
-(void)Object0{
    NSLog(@"YGAOPNSObject1_Object0");
}
@end

@implementation YGAOPNSObject2
-(void)Object2{
    NSLog(@"YGAOPNSObject2_Object2");
}
-(void)Object3:(NSInteger)value{
    NSLog(@"YGAOPNSObject3_Object3 (value:%@)",@(value));
}
@end

@implementation YGAOPNSObject3
-(void)Object3{
    NSLog(@"YGAOPNSObject3_Object3");
}
-(void)Object3:(NSInteger)value str:(NSString*)str{
    NSLog(@"YGAOPNSObject3_Object3 (value:%@,str:%@)",@(value),str);
}
@end
@interface YGAOPManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*table;
@property (nonatomic, strong) NSObject <YGAOPManagerViewControllerDelegate>* ygObject;
@property (nonatomic, strong) YGAOPNSObject1*obj1;
@property (nonatomic, strong) YGAOPNSObject2*obj2;
@property (nonatomic, strong) YGAOPNSObject3*obj3;
@end

@implementation YGAOPManagerViewController

{
    NSArray *_contenArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _contenArray = @[@{@"title":@"test1",@"content":@"模块拆分案例1"},
                     @{@"title":@"test2",@"content":@"模块拆分案例2"},
                     @{@"title":@"test3",@"content":@"模块拆分案例3"}];
    [self.view addSubview:self.table];
    [self.table reloadData];

    YGAOPManager*aopManager = [YGAOPManager new];
    self.obj1 = [YGAOPNSObject1 new];
    self.obj2 = [YGAOPNSObject2 new];
    self.obj3 = [YGAOPNSObject3 new];
    
    [aopManager addTarget:self.obj1];
    [aopManager addTarget:self.obj2];
    [aopManager addTarget:self.obj3];
    
    
    self.ygObject = (NSObject <YGAOPManagerViewControllerDelegate> *)aopManager;
}

-(void)test1{
    [self.ygObject performSelector:@selector(Object0)];
    [self.ygObject Object1];
    [self.ygObject Object2];
    [self.ygObject Object3];
}
-(void)test2{
    self.ygObject.obj1Str = @"test2";
    [self.ygObject Object3:1];
    [self.ygObject Object3:2 str:@"hello"];
}
-(void)test3{
    NSLog(@"%@",self.ygObject.obj1Str);
    [self.ygObject Object1];
    [self.ygObject Object3:3];
    [self.ygObject Object3:2 str:@"test3"];
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


@end
