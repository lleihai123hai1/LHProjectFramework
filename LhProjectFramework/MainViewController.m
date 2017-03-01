//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import "MainViewController.h"
#import "EnterSDAutoLayoutViewController.h"
#import "JsPathViewController.h"
#import "BaseViewCreateViewController.h"
#import "LhCoreDataViewController.h"
#import "BaseViewCreateUitableView.h"
@interface MainViewController ()
@property(nonatomic,strong)UITableView*table;
@end

@implementation MainViewController{
    NSArray *_contenArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _contenArray = @[@{@"title":@"EnterSDAutoLayoutViewController",@"content":@"自动布局"}
                     ,@{@"title":@"JsPathViewController",@"content":@"热修复"}
                     ,@{@"title":@"LhCoreDataViewController",@"content":@"测试数据库存储"}
                     ,@{@"title":@"BaseViewCreateUitableView",@"content":@"测试uitable"}
                     ,@{@"title":@"BaseViewCreateViewController",@"content":@"测试BaseViewCreate"},];
    [self.view addSubview:self.table];
    [self.table reloadData];
}

#pragma mark - tableview datasourece and delegate
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.frame.size.width tableView:tableView];;
}
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
            .lh_numberOfRowsInSection(^(NSInteger index){
                return self->_contenArray.count;
            })
            .lh_didSelectRowAtIndexPath(^(NSIndexPath *indexPath){
                NSDictionary*dict = _contenArray[indexPath.row];
                NSString *demoClassString = [dict strValue:@"title"];
                UIViewController *vc = [NSClassFromString(demoClassString) new];
                vc.title = demoClassString;
                [self.navigationController pushViewController:vc animated:YES];
            })
            .lh_frame(self.view.bounds);
        }];
    }
    return _table;
}


@end
