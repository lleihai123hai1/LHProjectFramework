//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//
#import "LhTestModelViewController.h"
#import "LhCoreDataViewController.h"
#import "CityTest.h"
@interface LhTestModelViewController ()
@property(nonatomic,strong)UITableView*table;
@property(nonatomic,copy)CityTest*cityTest;
@end
@implementation LhTestModelViewController{
    NSArray *_modelArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _modelArray = @[self.city];
    [self.view addSubview:self.table];
    [self.table reloadData];
    CityTest*cityTest = [CityTest return:^NSObject *(CityTest* value) {
        value.cityName = @"d";
        value.spell = @"ddd";
        value.adress = [LHAddress return:^NSObject *(LHAddress* value) {
            value.code = @"12";
            return value;
        }];
        return value;
    }];
    
    self.cityTest = cityTest;
}



#pragma mark - tableview datasourece and delegate
/**
 table
 
 @return table
 */
-(UITableView*)table{
    if(!_table){
        @weakify(self);
        _table = [UITableView return:^NSObject *(UITableView* value) {
            @strongify(self);
            return value
            .lh_delegateDataSource(self)
            .lh_separatorStyle(UITableViewCellSeparatorStyleSingleLine)
            .lh_style(UITableViewStyleGrouped)
            .lh_style(UITableViewStylePlain)
            .lh_separatorInset(UIEdgeInsetsZero)
            .lh_numberOfRowsInSection(^(NSInteger section){
                @strongify(self);
                return self->_modelArray.count;
            })
            .lh_numberOfSectionsInTableView(^(id value){
                return (NSUInteger)1;
            })
            .lh_heightForRowAtIndexPath(^(NSIndexPath *indexPath){
               return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.frame.size.width tableView:self.table];
            })
            .lh_didSelectRowAtIndexPath(^(NSIndexPath *indexPath){
                @strongify(self);
                self.city.cityName = @"nihao";
                self.city.spell = @"dddddddd";
                [self.city saveSelf];
                [self.city updateBindView];
            })
            .lh_cellForRowAtIndexPath(^(NSIndexPath *indexPath){
                @strongify(self);
                City* city = self->_modelArray[indexPath.row];
                return [LhDataBaseDemoCell getLhDataBaseDemoCell:self.table city:city];
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
