
#import "YGUICollectionViewCrash.h"
@interface YGUICollectionViewCrash ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView*collectionView;
@end

@implementation YGUICollectionViewCrash
-(void)dealloc{
    NSLog(@"dealloc %@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //关闭自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview: self.collectionView];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        fl.minimumInteritemSpacing = 0;
        fl.minimumLineSpacing = 5;
        self.view.bounds
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)collectionViewLayout:fl];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:0.8 ];
        _collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        [_collectionView registerClass:[UICollectionViewCell class]
             forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

#pragma mark -- dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  [UICollectionViewCell new];
}




//item大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     return CGSizeMake(self.view.width, 202);
    
}



//调节item边距

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 0, 5);
    
}

#pragma mark -- item点击跳转

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    
}

@end
