//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import "ValueForKeyPathViewController.h"

@interface ValueForKeyPathViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*table;
@end

@implementation ValueForKeyPathViewController

{
    NSArray *_contenArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _contenArray = @[@{@"title":@"test1",@"content":@"员工平均工资"},
                     @{@"title":@"test2",@"content":@"对象运算符"},
                     @{@"title":@"test3",@"content":@"自定义解析"}];
    [self.view addSubview:self.table];
    [self.table reloadData];
}

-(void)test1{
    NSMutableArray*employees = [NSMutableArray arrayWithCapacity:5];
    for (NSUInteger i = 1; i <= 5; i++) {
        [employees addObject: [KVCEmployee return:^NSObject *(KVCEmployee* value) {
            value.salary = i*10;
            value.order = i;
            return value;
        }]];
    }
    id avg =   [employees valueForKeyPath:@"@avg.salary"];
    NSLog(@"%@",avg);
    id sum =   [employees valueForKeyPath:@"@sum.salary"];
    NSLog(@"%@",sum);
    
    id max =   [employees valueForKeyPath:@"@max.salary"];
    NSLog(@"%@",max);
    
    id min =   [employees valueForKeyPath:@"@min.salary"];
    NSLog(@"%@",min);

}
-(void)test2{
    Product*iPhone5 = [Product return:^NSObject *(Product* value) {
        value.name = @"iPhone 5";
        return value;
    }];
    Product*iPadMini = [Product return:^NSObject *(Product* value) {
        value.name = @"iPad Mini";
        return value;
    }];
    Product*macBookPro = [Product return:^NSObject *(Product* value) {
        value.name = @"MacBook Pro";
        return value;
    }];
    NSArray *inventory = @[iPhone5, iPhone5, iPhone5, iPadMini, macBookPro, macBookPro];
//    @distinctUnionOfArrays/ @unionOfArrays：返回一个数组，其中包含集合中每个数组的组合值，由操作员右侧的键路径指定。如您所料，distinct版本会删除重复的值
    id unionOfObjects =  [inventory valueForKeyPath:@"@unionOfObjects.name"];
    NSLog(@"%@",unionOfObjects);
//    (
//     "iPhone 5",
//     "iPhone 5",
//     "iPhone 5",
//     "iPad Mini",
//     "MacBook Pro",
//     "MacBook Pro"
//     )
    id distinctUnionOfObjects = [inventory valueForKeyPath:@"@distinctUnionOfObjects.name"]; // "iPhone 5", "iPad Mini", "MacBook Pro"
    NSLog(@"%@",distinctUnionOfObjects);
//    (
//     "iPad Mini",
//     "MacBook Pro",
//     "iPhone 5"
//     )
    
//    @distinctUnionOfArrays/ @unionOfArrays：返回一个数组，其中包含集合中每个数组的组合值，由操作员右侧的键路径指定。如您所料，distinct版本会删除重复的值
    NSLog(@"%@",[@[@[iPhone5, macBookPro],@[iPadMini, macBookPro]] valueForKeyPath:@"@distinctUnionOfArrays.name"]);
//    (
//     "MacBook Pro",
//     "iPad Mini",
//     "iPhone 5"
//     )
    NSLog(@"%@",[@[@[iPhone5, macBookPro],@[iPadMini, macBookPro]] valueForKeyPath:@"@unionOfArrays.name"]);
//    (
//     "iPhone 5",
//     "MacBook Pro",
//     "iPad Mini",
//     "MacBook Pro"
//     )
}
-(void)test3{
    NSArray *array = @[@"nAMe", @"w", @"aa", @"jimSA"];
    NSLog(@"%@", [array valueForKeyPath:@"uppercaseString"]);
    NSLog(@"%@", [array valueForKeyPath:@"lowercaseString"]);
//    3.valueForKeyPath 可以使用. 来一层一层向下索引，当多个字典层级时，取子层级中的属性就非常简单了
    NSDictionary *dict1 = @{@"dic1":@{@"dic2":@{@"name":@"lisi",@"info":@{@"age":@"12"}}}};
    NSLog(@"%@",[dict1 valueForKeyPath:@"dict1.dict2.name"]);
    return;
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
