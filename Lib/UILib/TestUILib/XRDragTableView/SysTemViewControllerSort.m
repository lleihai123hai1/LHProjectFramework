#import "SysTemViewControllerSort.h"
#import "LhViewControllerSortCell.h"
#import "XRDragTableView.h"
@interface SysTemViewControllerSort () {
}
@property (nonatomic, strong) LHUITableView *table;
@property (nonatomic, retain) NSMutableArray *dataArray;
@end


@implementation SysTemViewControllerSort
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.table];
    [self.table reloadData];
    self.table.editing = YES;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ShoppingGoodsList" ofType:@"plist"]]];
    }
    return _dataArray;
}
-(LHUITableView*)table{
    if(!_table){
        @weakify(self);
        _table = [LHUITableView return:^NSObject *(LHUITableView* value) {
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
                return (CGFloat)130;
            })
            .lh_frame(self.view.bounds);
            ;
        }];
        _table.tableFooterView = [UIView new];
    }
    return _table;
}

#pragma mark 选择编辑模式，添加模式很少用,默认是删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 1){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
    
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row % 2 == 1){
        return YES ;
    }
    return NO;
    
    
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}
@end
