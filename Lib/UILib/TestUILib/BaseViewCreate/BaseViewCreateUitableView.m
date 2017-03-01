//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import "BaseViewCreateUitableView.h"
@interface BaseViewCreateUitableView ()
@property(nonatomic,strong)UITableView*table;
@end

@implementation BaseViewCreateUitableView{
    NSArray *_contenArray;
}
-(void)dealloc{
    NSLog(@"dealloc %@",[self class]);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _contenArray = @[@{@"title":@"EnterSDAutoLayoutViewController",@"content":@"自动布局"}
                     ,@{@"title":@"JsPathViewController",@"content":@"热修复"}
                     ,@{@"title":@"LhCoreDataViewController",@"content":@"测试数据库存储"}
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
                @strongify(self);
                return self->_contenArray.count;
            })
            .lh_heightForRowAtIndexPath(^(NSIndexPath *indexPath){
                @strongify(self);
                return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.frame.size.width tableView:self.table];;
            })
            .lh_didSelectRowAtIndexPath(^(NSIndexPath *indexPath){
                @strongify(self);
                NSDictionary*dict = self->_contenArray[indexPath.row];
                NSLog(@"%@",[dict strValue:@"title"])
            })
            .lh_frame(self.view.bounds);
        }];
    }
    return _table;
}


@end
