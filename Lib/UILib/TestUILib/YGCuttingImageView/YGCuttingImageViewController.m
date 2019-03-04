#import "YGCuttingImageViewController.h"
#import "YGCuttingImageView.h"
@interface YGCuttingImageViewController ()
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
    [self.view addSubview:self.button];
    [self.view addSubview:self.ygCuttingbutton];
}

-(UIButton*)button{
    if(!_button){
        _button = [UIButton return:^NSObject *(UIButton* value) {
            return value
            .lh_title(@"normal image",UIControlStateNormal)
            .lh_clickAction(^(UIButton *sender){
                self.uiImageView.image = [UIImage imageNamed:@""];
            })
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftSpaceToView(self.view,10)
                .topSpaceToView(self.view,100)
                .widthIs(60)
                .heightIs(40);
            })
            .lh_backgroundColor([UIColor redColor]);
        }];
    }
    return _button;
}


-(UIButton*)ygCuttingbutton{
    if(!_ygCuttingbutton){
        _ygCuttingbutton = [UIButton return:^NSObject *(UIButton* value) {
            return value
            .lh_title(@"cut image",UIControlStateNormal)
            .lh_clickAction(^(UIButton *sender){
                NSLog(@"clickAction");
                self.ygCuttingImageView.image = [UIImage imageNamed:@""];
            })
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftSpaceToView(self.view,10)
                .topSpaceToView(self.view,200)
                .widthIs(60)
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
            return value
            .lh_image([UIImage imageNamed:@"icon_ProRight2"])
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftEqualToView(self.button)
                .topSpaceToView(self.button,10)
                .widthIs(150)
                .heightIs(150);
            });
        }];
    }
    return _uiImageView;
}

-(YGCuttingImageView*)ygCuttingImageView{
    if(!_ygCuttingImageView){
        _ygCuttingImageView = [YGCuttingImageView return:^NSObject *(UIImageView* value) {
            return value
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftEqualToView(self.ygCuttingbutton)
                .topSpaceToView(self.ygCuttingbutton,20)
                .widthIs(150)
                .heightIs(150);
            })
            .lh_gesture(1,1,^(id value){
                
            });
        }];
    }
    return _ygCuttingImageView;
}
@end
