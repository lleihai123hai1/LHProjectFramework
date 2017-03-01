//
//  DataViewController.m
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import "BaseViewCreateUICollectionView.h"
#import "UIImageView+WebCache.h"
@implementation LhCollectionCell
+(LhCollectionCell*)getLhCollectionCell:(UICollectionView*)collectionCell dict:(NSDictionary*)dict indexPath:(NSIndexPath *)indexPath{
    LhCollectionCell *cell = [collectionCell dequeueReusableCellWithReuseIdentifier:collectionCell.lh_NSObjectId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lh_randomColor];
    return cell;
}
@end

@interface BaseViewCreateUICollectionView ()
@property (strong, nonatomic) UICollectionView *collection;
@end

@implementation BaseViewCreateUICollectionView{
    NSMutableArray *_contenArray;
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
    _contenArray = [NSMutableArray array];
    for (NSInteger i = 0; i <= 50; i++) {
        [_contenArray addObject:@{@"title":[NSString stringWithFormat:@"title_%ld",(long)i]}];
    }
    [self.view addSubview:self.collection];
    [self.collection reloadData];
}

#pragma mark - tableview datasourece and delegate
-(UICollectionView*)collection{
    if(!_collection){
        @weakify(self);
        _collection = [UICollectionView return:^NSObject *(UICollectionView* value) {
            @strongify(self);
            return value
            .lh_delegateDataSource(self)
            .lh_collectionViewLayout(^(){
                UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
                //设置布局方向为垂直流布局
                layout.scrollDirection = UICollectionViewScrollDirectionVertical;
                //设置每个item的大小为100*100
                layout.itemSize = CGSizeMake(128, 128+52);
                CGFloat widthDiff = (self.view.width-layout.itemSize.width*3)/4.0;
                layout.sectionInset = UIEdgeInsetsMake(20,widthDiff, 20, widthDiff);
                return layout;
            })
            .lh_registerClass([LhCollectionCell class])
            .lh_numberOfItemsInSection(^(NSInteger index){
                @strongify(self);
                return self->_contenArray.count;
            })
            .lh_didSelectItemAtIndexPath(^(NSIndexPath *indexPath){
                @strongify(self);
                NSDictionary*dict = self->_contenArray[indexPath.row];
                NSLog(@"%@",[dict strValue:@"title"])
            })
            .lh_cellForItemAtIndexPath(^(NSIndexPath *indexPath){
                @strongify(self);
                NSDictionary*dict = self->_contenArray[indexPath.row];
                return [LhCollectionCell getLhCollectionCell:self.collection dict:dict indexPath:indexPath];
            })
            .lh_frame(self.view.bounds)
            .lh_backgroundColor([UIColor whiteColor]);
        }];
    }
    return _collection;
}


@end
