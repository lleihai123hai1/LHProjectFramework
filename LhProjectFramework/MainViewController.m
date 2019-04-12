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
#import "BaseViewCreateUICollectionView.h"
#import "LhViewControllerSort.h"
#import "YGAOPManagerViewController.h"
#import "YGUICollectionViewCrash.h"
#import "YGAspectsAnalysisViewController.h"
#import "YGHttpImageViewController.h"
#import "YGHttpLocalImageViewController.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*table;
@end

@implementation MainViewController{
    NSArray *_contenArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _contenArray = @[@{@"title":@"YGHttpLocalImageViewController",@"content":@"网络图片本地缓存，内存测试"},
                     @{@"title":@"YGHttpImageViewController",@"content":@"网络图片内存测试"},
                     @{@"title":@"YGAspectsAnalysisViewController",@"content":@"Aspects 分析源码"},
                     @{@"title":@"YGUICollectionViewCrash",@"content":@"UICollectionView闪退自测"},
                     @{@"title":@"EnterSDAutoLayoutViewController",@"content":@"自动布局"}
                     ,@{@"title":@"JsPathViewController",@"content":@"热修复"}
                     ,@{@"title":@"LhCoreDataViewController",@"content":@"测试数据库存储"}
                     ,@{@"title":@"BaseViewCreateUitableView",@"content":@"测试uitable"}
                     ,@{@"title":@"BaseViewCreateUICollectionView",@"content":@"测试UICollectionView"}
                     ,@{@"title":@"BaseViewCreateViewController",@"content":@"测试BaseViewCreate"}
                     ,@{@"title":@"LhViewControllerSort",@"content":@"自定义cell拖动排序"}
                     ,@{@"title":@"SysTemViewControllerSort",@"content":@"系统cell拖动排序"},
                     @{@"title":@"ValueForKeyPathViewController",@"content":@"ValueForKeyPath"},
                     @{@"title":@"YGAOPManagerViewController",@"content":@"模块拆分"},
                     @{@"title":@"YGMultiAgentDesignViewController",@"content":@"多代理设计"},
                     @{@"title":@"YGLuaViewController",@"content":@"Lua测试"},
                     @{@"title":@"YGCuttingImageViewController",@"content":@"cut Image 测试"},
                     ];
    [self.view addSubview:self.table];
    [self.table reloadData];
}

#pragma mark - tableview datasourece and delegate
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
    NSDictionary*dict = _contenArray[indexPath.row];
    NSString *demoClassString = [dict strValue:@"title"];
    UIViewController *vc = [NSClassFromString(demoClassString) new];
    vc.title = demoClassString;
    [self.navigationController pushViewController:vc animated:YES];
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
