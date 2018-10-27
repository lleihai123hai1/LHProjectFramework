//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import "YGMultiAgentDesignViewController.h"
#import "YGMultiOriginBaseModel.h"
#import "YGMultiInitializeModel.h"
#import "YGMultiBusinessLogicBaseModel.h"
#import "YGMultiAdhesiveBaseModel.h"
@interface YGMultiAgentDesignViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *table;
@end

@implementation YGMultiAgentDesignViewController {
    NSArray *_contenArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    _contenArray = @[@{ @"title": @"test1", @"content": @"ui利用多代理" },
                     @{ @"title": @"test2", @"content": @"框架利用多代理" },
                     @{ @"title": @"test3", @"content": @"基本方法利用多代理" }];
    [self.view addSubview:self.table];
    [self.table reloadData];
}

- (void)test1 {
    UILabel *sessionDetail = [[UILabel alloc]init];
    sessionDetail.frame = CGRectMake(16, 124, 100, 60);
    sessionDetail.textColor = [UIColor redColor];
    sessionDetail.font = [UIFont fontWithName:@"AvenirNext-Regular" size:(10)];
    sessionDetail.textAlignment = NSTextAlignmentLeft;
    sessionDetail.numberOfLines = 3;
    sessionDetail.text = @"dddddd";
    @weakify(self);
    sessionDetail.lh_gesture(1, 1, ^(id value) {
        @strongify(self);
    });
    [self.table addSubview:sessionDetail];
}

- (void)test2 {
    
    YGMultiOriginBaseModel *baseModel = [YGMultiAdhesiveBaseModel createYGObject:
                                         YGMultiOriginBaseModelBindClass(UILabel)                                                                        initializeModel:
                                         YGMultiInitializeModelBindBlock(^(YGMultiOriginBaseModel *baseModel, YGMultiBusinessLogicBaseModel *logicModel) {
                                                                         UILabel *value = baseModel.ygOriginObject;
                                                                         value.frame = CGRectMake(16, 124, 100, 60);
                                                                         value.textColor = [UIColor redColor];
                                                                         value.font = [UIFont fontWithName:@"AvenirNext-Regular" size:(10)];
                                                                         value.textAlignment = NSTextAlignmentLeft;
                                                                         value.numberOfLines = 3;
                                                                         value.text = @"dddddd";
                                                                         value.lh_gesture(1, 1, ^(id value) {
                                                                                          if (logicModel.logicBlock) {
                                                                                              logicModel.logicBlock(value);
                                                                                          }
                                                                                      });
                                                                         return baseModel;
                                            }) logicBaseModel:YGMultiBusinessLogicBaseModelBindBlock(^(id value) {
                                                NSLog(@"ddddddd");
                                            })];
    [self.table addSubview:baseModel.ygOriginObject];
}

- (void)test3 {
}

#pragma mark - tableview datasourece and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contenArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"test";
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary *dict = _contenArray[indexPath.row];
    cell.titleLabel.text = [dict strValue:@"title"];
    cell.contentLabel.text = [dict strValue:@"content"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self->_contenArray[indexPath.row];
    SEL selecter = NSSelectorFromString([dict strValue:@"title"]);
    if ([self respondsToSelector:selecter]) {
        [self performSelector:selecter];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.frame.size.width tableView:tableView];
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.separatorInset = UIEdgeInsetsZero;
    }
    return _table;
}

@end
