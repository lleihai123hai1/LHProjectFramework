#import "BaseViewCreateViewController.h"

@interface BaseViewCreateViewController ()
@property(nonatomic,strong)UIButton*button;
@property(nonatomic,strong)UITextField*textFiled;
@property(nonatomic,strong)UITextView*textView;
@property(nonatomic,strong)UILabel*lable;
@property(nonatomic,strong)UIImageView*uiImageView;
@property(nonatomic,strong)UIImageView*uiImageNameView;
@end

@implementation BaseViewCreateViewController
-(void)dealloc{
    NSLog(@"dealloc %@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.lh_signalForSelector(@selector(touchesBegan:withEvent:),^(RACTuple *tuple) {
        NSLog(@"touchesBegan");
    }).lh_signalForSelector(@selector(test),^(RACTuple *tuple) {
        NSLog(@"test");
    });
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];
    [self.view addSubview:self.textFiled];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.lable];
    [self.view addSubview:self.uiImageView];
    [self.view addSubview:self.uiImageNameView];
    @weakify(self);
    self.view
    .lh_gesture(1,2,^(id value){
        @strongify(self);
        NSLog(@"singleFingerTwo");
        [[UIActionSheet return:^NSObject *(UIActionSheet* value) {
            return value
            .lh_actionSheetStyle(UIActionSheetStyleBlackTranslucent)
            .lh_title(@"test")
            .lh_cancelButtonTitle(@"取消")
            .lh_destructiveButtonTitle(@"加入黑名单")
            .lh_cancelButtonTitle(@"test取消")
            .lh_btnTitle(@"click1",@"click2",nil)
            .lh_clickAction(^(id value,NSInteger index){
                NSLog(@"index %ld",(long)index);
            });
        }]showInView:self.view];
    })
    .lh_gesture(2,2,^(id value){
        NSLog(@"TwoFingerTwo");
    });
    self.lh_notification(@"hello",^(id value){
        NSLog(@"hello");
    });
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view.window endEditing:YES];
    self.lh_postNotification(@"hello",nil);
    [self test];
}
-(void)test{
    
}
-(UIButton*)button{
    if(!_button){
        @weakify(self);//只能解决一层block 循环引用  若是多层必须添加@strongify(self); 然而 __weak typeof(self) weakSelf = self;  不存在此问题
        _button = [UIButton return:^NSObject *(UIButton* value) {
            return value
            .lh_title(@"btn",UIControlStateNormal)
            .lh_clickAction(^(UIButton *sender){
                sender.width += 2;
                NSLog(@"clickAction");
                @strongify(self);
                [(UIAlertView*)[UIAlertView return:^NSObject *(UIAlertView* value) {
                    return value
                    .lh_title(@"hello")
                    .lh_message(@"good")
                    .lh_btnTitle(@"ok1",nil)
                    .lh_btnTitle(@"ok2",@"ok3",nil)
                    .lh_btnTitle(LH_Valist(@"ok4",@"ok5"))
                    .lh_btnTitle(LH_Valist(@"ok6",@"ok7",nil))
                    .lh_clickAction(^(UIAlertView* value,NSInteger index){
                        NSLog(@"UIAlertView:%ld",(long)index);
                        self.lh_removeNotification(@"hello");
                    });
                }] show];
            })
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftSpaceToView(self.view,10)
                .topSpaceToView(self.view,100)
                .widthIs(60)
                .heightIs(40);
            })
            .lh_backgroundColor([UIColor redColor])
            .lh_alpha(@(0.4))
            .lh_layer_cornerRadius(@(10))
            .lh_frame(CGRectMake(100, 200, 100, 100))
            .lh_kvo(@"frame",^(id value){
                NSLog(@"change_frame");
//                @strongify(self);
//                self.lh_removeNotification(@"hello");
            });
        }];
    }
    return _button;
}
-(UITextField*)textFiled{
    if(!_textFiled){
        _textFiled = [UITextField return:^NSObject *(UITextField* value) {
            return value
            .lh_clickAction(^(UITextField *sender,NSString*value){
                NSLog(@"%@",value);
            })
            .lh_backgroundColor(UIColor.lh_ff32ff)
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftSpaceToView(self.view,70)
                .topSpaceToView(self.view,100)
                .widthIs(140)
                .heightIs(40);
            });
        }];
    }
    return _textFiled;
}

-(UITextView*)textView{
    if(!_textView){
        _textView = [UITextView return:^NSObject *(UITextField* value) {
            return value
            .lh_clickAction(^(UITextField *sender,NSString*value){
                NSLog(@"%@",value);
            })
            .lh_backgroundColor([UIColor blueColor])
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftSpaceToView(self.view,70)
                .topSpaceToView(self.textFiled,10)
                .widthIs(140)
                .heightIs(80);
            });
        }];
    }
    return _textView;
}

-(UILabel*)lable{
    if(!_lable){
        _lable = [UILabel return:^NSObject *(UILabel* value) {
            return value
            .lh_text(@"uilable -_click， me")
            .lh_textColor([UIColor blackColor])
            .lh_textAlignment(NSTextAlignmentCenter)
            .lh_backgroundColor([UIColor whiteColor])
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftSpaceToView(self.textFiled,10)
                .topEqualToView(self.textFiled)
                .widthIs(150)
                .heightIs(50);
            })
            .lh_gesture(1,1,^(id value){
                [(UIAlertView*)[UIAlertView return:^NSObject *(UIAlertView* value) {
                    return value
                    .lh_title(@"hello")
                    .lh_message(@"thanks click")
                    .lh_btnTitle(LH_Valist(@"ok",nil))
                    .lh_clickAction(^(UIAlertView* value,NSInteger index){
                        NSLog(@"UIAlertView:%ld",(long)index);
                    });
                }] show];

            });
        }];
    }
    return _lable;
}


-(UIImageView*)uiImageView{
    if(!_uiImageView){
        _uiImageView = [UIImageView return:^NSObject *(UIImageView* value) {
            return value
            .lh_image([UIImage imageNamed:@"icon_ProRight2"])
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftEqualToView(self.lable)
                .topSpaceToView(self.lable,10)
                .widthIs(50)
                .heightIs(50);
            });
;
        }];
    }
    return _uiImageView;
}

-(UIImageView*)uiImageNameView{
    if(!_uiImageNameView){
        _uiImageNameView = [UIImageView return:^NSObject *(UIImageView* value) {
            return value
            .lh_name(@"icon_ProRight2")
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftEqualToView(self.uiImageView)
                .topSpaceToView(self.uiImageView,20)
                .widthIs(40)
                .heightIs(40);
            })
            .lh_gesture(1,1,^(id value){
                [(UIAlertView*)[UIAlertView return:^NSObject *(UIAlertView* value) {
                    return value
                    .lh_title(@"hello")
                    .lh_message(@"thanks click")
                    .lh_btnTitle(LH_Valist(@"ok",nil))
                    .lh_clickAction(^(UIAlertView* value,NSInteger index){
                        NSLog(@"UIAlertView:%ld",(long)index);
                    });
                }] show];
                
            });;
        }];
    }
    return _uiImageView;
}
@end
