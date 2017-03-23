//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//
#import "LhCoreDataViewController.h"
#import "LhTestModelViewController.h"
@implementation LhDataBaseDemoCell
+(UITableViewCell*)getLhDataBaseDemoCell:(UITableView*)table  dict:(NSDictionary*)dict{
    NSString *ID = ([NSString stringWithFormat:@"%ld",(long)((NSInteger)table)]);
    LhDataBaseDemoCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LhDataBaseDemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.titleLabel.text = [dict strValue:@"title"];
    cell.contentLabel.text = [dict strValue:@"content"];
    return cell;
}

+(UITableViewCell*)getLhDataBaseDemoCell:(UITableView*)table  city:(City*)city{
    NSString *ID = ([NSString stringWithFormat:@"%ld",(long)((NSInteger)table)]);
    LhDataBaseDemoCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LhDataBaseDemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.city = city;
    city.updateBindBlock = ^(City* value){
        if(cell.city && [cell.city.hostID isEqualToString:value.hostID]){
            NSIndexPath *indexPath = [table indexPathForCell:cell];
            [table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    return cell;
}
-(void)setCity:(City *)city{
    _city = city;
    self.titleLabel.text = city.cityName;
    self.contentLabel.text = city.spell;
}
@end

@interface LhCoreDataViewController ()
@property(nonatomic,strong)UITableView*table;
@end

@implementation LhCoreDataViewController{
    NSArray *_contenArray;
    NSArray *_modelArray;
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
    
    City *city = [City getLHBaseCoreModel:@{@"hostID":@"lh_000881",@"cityName":@"xian",@"spell":@"xixianxianxianxianan"}];
    _modelArray = @[city];

}



#pragma mark - tableview datasourece and delegate
/**
 table
 
 @return table
 */
-(LHUITableView*)table{
    if(!_table){
        @weakify(self);
        _table = [LHUITableView return:^NSObject *(LHUITableView* value) {
            @strongify(self);
            return value
            .lh_delegateDataSource(self)
            .lh_separatorStyle(UITableViewCellSeparatorStyleSingleLine)
            .lh_style(UITableViewStyleGrouped)
            .lh_style(UITableViewStylePlain)
            .lh_separatorInset(UIEdgeInsetsZero)
            .lh_numberOfRowsInSection(^(NSInteger section){
                @strongify(self);
                if(section == 0){
                    return self->_contenArray.count;
                }else{
                    return self->_modelArray.count;
                }
            })
            .lh_numberOfSectionsInTableView(^(id value){
                return (NSUInteger)2;
            })
            .lh_heightForRowAtIndexPath(^(NSIndexPath *indexPath){
               return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.frame.size.width tableView:self.table];
            })
            .lh_didSelectRowAtIndexPath(^(NSIndexPath *indexPath){
                @strongify(self);
                if(indexPath.section == 0){
                    NSDictionary*dict = self->_contenArray[indexPath.row];
                    SEL selecter = NSSelectorFromString([dict strValue:@"title"]);
                    if([self respondsToSelector:selecter]){
                        [self performSelector:selecter];
                    }
                }else{
                    City* city = self->_modelArray[indexPath.row];
                    LhTestModelViewController *vc = [LhTestModelViewController new];
                    vc.city = city;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            })
            .lh_cellForRowAtIndexPath(^(NSIndexPath *indexPath){
                @strongify(self);
                if(indexPath.section == 0){
                    NSDictionary*dict = self->_contenArray[indexPath.row];
                    return [LhDataBaseDemoCell getLhDataBaseDemoCell:self.table dict:dict];
                }else{
                    City* city = self->_modelArray[indexPath.row];
                    return [LhDataBaseDemoCell getLhDataBaseDemoCell:self.table city:city];
                }
               
            })
            .lh_frame(self.view.bounds);
        }];
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
        person.updateBindBlock = ^(id value){
            NSLog(@"dddddd");
        };
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
