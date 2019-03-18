#import "YGCuttingImageViewController.h"
#import "YGCuttingImageView.h"
#import "YYImage.h"
@interface YGCuttingImageViewController ()
@property (nonatomic, strong) UIScrollView *scroollView;
@property(nonatomic,strong)UIButton*button;
@property(nonatomic,strong)UIButton*ygCuttingbutton;
@property(nonatomic,strong)UIImageView*uiImageView;
@property(nonatomic,strong)UIImageView*uiImageView1;
@property(nonatomic,strong)UIImageView*uiImageView2;
@end

@implementation YGCuttingImageViewController
-(void)dealloc{
    NSLog(@"dealloc %@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scroollView.hidden = NO;
    [self.view addSubview:self.button];
}

- (UIScrollView *)scroollView
{
    if (!_scroollView) {
        _scroollView = [UIScrollView new];
        _scroollView.frame = self.view.bounds;
        [self.view addSubview:_scroollView];
        
        _scroollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }
    return _scroollView;
}


-(UIButton*)button{
    if(!_button){
        @weakify(self);
        _button = [UIButton return:^NSObject *(UIButton* value) {
            return value
            .lh_title(@"normal image",UIControlStateNormal)
            .lh_clickAction(^(UIButton *sender){
                
                @strongify(self);
                self.uiImageView.image =  [UIImage imageNamed:@"Coupons_GoldPro_trial"];
                self.uiImageView1.image =  [UIImage imageNamed:@"Coupons_GoldPro_trial"];
                self.uiImageView2.image =  [UIImage imageNamed:@"Coupons_GoldPro_trial"];
//                self.uiImageView.image = [YYImage imageNamed:@"jpg_Coupons_GoldPro_trial"];
//                self.uiImageView1.image = [YYImage imageNamed:@"jpg_Coupons_GoldPro_trial"];
//                self.uiImageView2.image = [YYImage imageNamed:@"jpg_Coupons_GoldPro_trial"];
                [self.scroollView addSubview:self.uiImageView];
                [self.scroollView addSubview:self.uiImageView1];
                [self.scroollView addSubview:self.uiImageView2];
                [self.scroollView setupAutoContentSizeWithBottomView:self.uiImageView2 bottomMargin:300];
            })
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftSpaceToView(self.view,10)
                .topSpaceToView(self.view,100)
                .widthIs(160)
                .heightIs(40);
            })
            .lh_backgroundColor([UIColor redColor]);
        }];
    }
    return _button;
}
-(UIImageView*)uiImageView{
    if(!_uiImageView){
        _uiImageView = [UIImageView return:^NSObject *(UIImageView* value) {
            return value;
        }];
        _uiImageView.frame = CGRectMake(0, 0, self.view.width, self.view.width/1479*829);
        _uiImageView.backgroundColor = [UIColor lh_randomColor];
    }
    return _uiImageView;
}

-(UIImageView*)uiImageView1{
    if(!_uiImageView1){
        _uiImageView1 = [UIImageView return:^NSObject *(UIImageView* value) {
            return value;
        }];
        _uiImageView1.frame = CGRectMake(0, self.uiImageView.bottom + 10, self.view.width, self.view.width/1479*829);
        _uiImageView1.backgroundColor = [UIColor lh_randomColor];
    }
    return _uiImageView1;
}

-(UIImageView*)uiImageView2{
    if(!_uiImageView2){
        _uiImageView2 = [UIImageView return:^NSObject *(UIImageView* value) {
            return value;
        }];
        _uiImageView2.frame = CGRectMake(0, self.uiImageView1.bottom + 10, self.view.width, self.view.width/1479*829);
        _uiImageView2.backgroundColor = [UIColor lh_randomColor];
    }
    return _uiImageView2;
}




//-(NSString *)getPathByName:(NSString*)Name {
//    //成功找到标志
//    BOOL success = NO;
//    NSString* path = nil;
//    //搜索mainBundle
//    if (!success){
//        path = [[NSBundle mainBundle] bundlePath];
//        path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",Name]];
//        success = [[NSFileManager defaultManager] fileExistsAtPath:path];
//    }
//
//    if (success) {
//        //        EBLog(@"path %@",path);
//        return path;
//    }else{
//        //        EBLog(@"do not find file:%@",Name);
//        return  nil;
//    }
//}


@end
