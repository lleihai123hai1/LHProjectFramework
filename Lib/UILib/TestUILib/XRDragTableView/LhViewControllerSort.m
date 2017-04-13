#import "LhViewControllerSort.h"
#import "LhViewControllerSortCell.h"
#import "XRDragTableView.h"
@interface LhViewControllerSort () {
}
@property (nonatomic, strong) XRDragTableView *table;
@property (nonatomic, retain) NSMutableArray *dataArray;
@end


@implementation LhViewControllerSort
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.table];
    self.table.dataArray = self.dataArray;
    [self.table reloadData];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:@[@{@"title":@"1",@"content":@"自动布局"}
                                                      ,@{@"title":@"2",@"content":@"热修复"}
                                                      ,@{@"title":@"3",@"content":@"测试"}
                                                      ,@{@"title":@"4",@"content":@"存储"}
                                                      ,@{@"title":@"5",@"content":@"数据库存储"}
                                                      ,@{@"title":@"6",@"content":@"年度"}
                                                      ,@{@"title":@"7",@"content":@"存储中级"}
                                                      ,@{@"title":@"8",@"content":@"dailyyoga"}
                                                      ,@{@"title":@"9",@"content":@"test"}
                                                      ,@{@"title":@"10",@"content":@"年代是"}
                                                      ,@{@"title":@"11",@"content":@"ios"},]];
    }
    return _dataArray;
}
-(XRDragTableView*)table{
    if(!_table){
        @weakify(self);
        _table = [XRDragTableView return:^NSObject *(LHUITableView* value) {
            return value
            .lh_registerClass([LhViewControllerSortCell class])
            .lh_delegateDataSource(self)
            .lh_cellForRowAtIndexPath(^(NSIndexPath *indexPath){
                @strongify(self);
                NSDictionary*dict = self.dataArray[indexPath.row];
                return [LhViewControllerSortCell getLhDemoCell:self.table dict:dict];
            })
            .lh_separatorStyle(UITableViewCellSeparatorStyleNone)
            .lh_didSelectRowAtIndexPath(^(NSIndexPath*indexPath){
            })
            .lh_numberOfRowsInSection(^(NSInteger section){
                @strongify(self);
                return self.dataArray.count;
            })
            .lh_heightForRowAtIndexPath(^(NSIndexPath *indexPath){
                return (CGFloat)90;
            })
            .lh_frame(self.view.bounds);
            ;
        }];
        _table.tableFooterView = [UIView new];
    }
    return _table;
}

@end
