//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//
#import "LuaManager.h"
#import "YGLuaViewController.h"
#import "LuaScriptCore.h"

@interface YGLuaViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *table;
@property (nonatomic, strong) LSCContext *context;
@end

@implementation YGLuaViewController {
    NSArray *_contenArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[LSCContext alloc] init];
    [self.context onException:^(NSString *message) {
        
        NSLog(@"lsc exception = %@", message);
        
    }];
    [self.context evalScriptFromFile:@"configuration.lua"];
    [self.context evalScriptFromFile:@"utilities.lua"];
    self.view.backgroundColor = [UIColor whiteColor];
    _contenArray = @[@{ @"title": @"test1", @"content": @"测试功能函数" },
                     @{ @"title": @"test2", @"content": @"测试oc和lua相互调用"},
                     @{ @"title": @"test3", @"content": @"测试字符串调用回调"}];
    [self.view addSubview:self.table];
    [self.table reloadData];
}

- (void)test1 {

    NSArray<LSCValue *> *args = @[[LSCValue integerValue:5]];
    LSCValue *retVal = [self.context callMethodWithName:@"calculate" arguments:args];
   
   NSLog(@"%ld",(long) [retVal toInteger]);
    
    NSInteger result = [[LuaManager defaultManager] calculate:5];
    NSLog(@"%ld",(long) result);
}

- (void)test2 {
    @try {
        @weakify(self);
        [self.context registerMethodWithName:@"testOcFunctionCallback" block:^LSCValue *(NSArray<LSCValue *> *arguments) {
            @strongify(self);
            [self testLuaCallBack];
            return [LSCValue objectValue:self];
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    LSCValue *retVal = [self.context callMethodWithName:@"testOcFunctionCallback" arguments:nil];
    NSLog(@"%@",[retVal toObject]);
//    [[LuaManager defaultManager] testRegisterOcFunction:self];
}

- (void)test3 {
//    NSString*test = @"local i = 1 ; i = 1 + i;print(string.format(\"%s%d\",\"result:\",i))";
//    if([[LuaManager defaultManager] isAllowedToExecute:test]){
//        [[LuaManager defaultManager] runCodeFromString:test];
//        NSLog(@"允许执行");
//    }else{
//        NSLog(@"不允许执行");
//    }
    [self.context evalScriptFromFile:@"test.lua"];
}

-(void)testLuaCallBack{
    NSLog(@"回调成功_testLuaCallBack");
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
