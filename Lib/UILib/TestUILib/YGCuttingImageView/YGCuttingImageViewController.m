#import "YGCuttingImageViewController.h"
#import "YGCuttingImageView.h"
@interface YGCuttingImageViewController ()
@property (nonatomic, strong) UIScrollView *scroollView;
@property(nonatomic,strong)UIButton*button;
@property(nonatomic,strong)UIButton*ygCuttingbutton;
@property(nonatomic,strong)UIImageView*uiImageView;
@property(nonatomic,strong)YGCuttingImageView*ygCuttingImageView;
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
    [self.view addSubview:self.ygCuttingbutton];
    
    
    
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
                self.uiImageView.image = [UIImage imageNamed:@"yg_80_gold_pro_bg.png"];
                [self.scroollView addSubview:self.uiImageView];
                [self.scroollView setupAutoContentSizeWithBottomView:self.uiImageView bottomMargin:100];
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

-(UIButton*)ygCuttingbutton{
    if(!_ygCuttingbutton){
        @weakify(self);
        _ygCuttingbutton = [UIButton return:^NSObject *(UIButton* value) {
            return value
            .lh_title(@"cut image",UIControlStateNormal)
            .lh_clickAction(^(UIButton *sender){
                @strongify(self);
                NSLog(@"clickAction");
//                
//                NSBundle *bundle = [NSBundle mainBundle];
//                NSString *resourcePath = [bundle resourcePath];
//                NSString *filePath = [resourcePath stringByAppendingPathComponent:@"yg_80_gold_pro_bg.png"];
//                UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                
                self.ygCuttingImageView.image = [UIImage imageNamed:@"yg_80_gold_pro_bg.png"];
                [self.scroollView addSubview:self.ygCuttingImageView];
                [self.scroollView setupAutoContentSizeWithBottomView:self.ygCuttingImageView bottomMargin:100];
            })
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftSpaceToView(self.view,10)
                .topSpaceToView(self.view,350)
                .widthIs(160)
                .heightIs(40);
            })
            .lh_backgroundColor([UIColor redColor]);
        }];
    }
    return _ygCuttingbutton;
}



-(UIImageView*)uiImageView{
    if(!_uiImageView){
        _uiImageView = [UIImageView return:^NSObject *(UIImageView* value) {
            return value;
        }];
        _uiImageView.frame = CGRectMake(0, 0, self.view.width, self.view.width*2727/1125);
        _uiImageView.backgroundColor = [UIColor lh_randomColor];
    }
    return _uiImageView;
}

-(YGCuttingImageView*)ygCuttingImageView{
    if(!_ygCuttingImageView){
        _ygCuttingImageView = [YGCuttingImageView return:^NSObject *(UIImageView* value) {
            return value;
        }];
        _ygCuttingImageView.frame = CGRectMake(0, 0, self.view.width, self.view.width*2727/1125);
        _ygCuttingImageView.backgroundColor = [UIColor lh_randomColor];
    }
    return _ygCuttingImageView;
}
@end
