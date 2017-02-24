//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import "LhCoreDataViewController.h"
@interface LhCoreDataViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*table;
@end

@implementation LhCoreDataViewController

{
    NSArray *_contenArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _contenArray = @[@{@"title":@"test1",@"content":@"写入数据库"},
                     @{@"title":@"test2",@"content":@"读取数据库"},
                     @{@"title":@"test3",@"content":@"异步查询异步写入"}];
    [self.view addSubview:self.table];
    [self.table reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*dict = _contenArray[indexPath.row];
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

-(void)test1{
    for (NSInteger i = 0; i <= 100; i++) {
        Person *person = [[Person alloc] init];
        person.name = [@"lh_" stringByAppendingString:[NSString stringWithFormat:@"-%ld",(long)i]];
        person.hostID = person.name;
        person.dict = @{@"1":@2,@"dd":@44};
        person.array = @[@1,@2];
        City *city = [[City alloc]init];
        city.cityName = [@"xian" stringByAppendingString:[NSString stringWithFormat:@"-%ld",(long)i]];
        city.hostID = [NSString stringWithFormat:@"city_%@",person.hostID];
        Pen *pen = [Pen new];
        pen.color =  @"红色";
        pen.hostID = [NSString stringWithFormat:@"pen%@",person.hostID];
        person.city = city;
        person.pen = pen;
        [Person save:person resBlock:^(BOOL res) {
            if (!res) {
                NSLog(@"person %@",person.hostID);
            }
        }];

    }
}

-(void)test2{
     for (NSInteger i = 0; i <= 100; i++) {
         NSString *hostId =  [@"lh_" stringByAppendingString:[NSString stringWithFormat:@"-%ld",(long)i]];
         [Person find:hostId selectResultBlock:^(Person* person) {
             if(person.city && person.pen){
                 NSLog(@"person %@",person.hostID);
             }
         }];
     }
    
}

-(void)test3{
    for (NSInteger i = 1; i <= 50; i++) {
        [self performSelector:@selector(test1)];
        [self performSelector:@selector(test2)];
    }
}




@end
