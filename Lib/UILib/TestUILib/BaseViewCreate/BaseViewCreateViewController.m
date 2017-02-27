#import "BaseViewCreateViewController.h"

@interface BaseViewCreateViewController ()
@property(nonatomic,strong)UIButton*button;
@property(nonatomic,strong)UITextField*textFiled;
@property(nonatomic,strong)UITextView*textView;

@end

@implementation BaseViewCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];
    [self.view addSubview:self.textFiled];
    [self.view addSubview:self.textView];
    
    self.view.lh_gesture(1,1,^(id value){
        NSLog(@"singleFingerOne");
    })
    .lh_gesture(1,2,^(id value){
        NSLog(@"singleFingerTwo");
    })
    .lh_gesture(2,2,^(id value){
        NSLog(@"TwoFingerTwo");
    });
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view.window endEditing:YES];
}
-(UIButton*)button{
    if(!_button){
        _button = [UIButton return:^NSObject *(UIButton* value) {
            return value
            .lh_clickAction(^(UIButton *sender){
                sender.width += 2;
                NSLog(@"clickAction");
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
                    });
                }] show];
            })
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftSpaceToView(self.view,50)
                .topSpaceToView(self.view,100)
                .widthIs(40)
                .heightIs(90);
            })
            .lh_backgroundColor([UIColor redColor])
            .lh_alpha(@(0.4))
            .lh_layer_cornerRadius(@(10))
//            .lh_frame(CGRectMake(100, 200, 100, 100))
            .lh_kvo(@"frame",^(id value){
                NSLog(@"change_frame");
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
            .lh_backgroundColor([UIColor grayColor])
            .lh_layout(self.view,^(SDAutoLayoutModel *sd_layout){
                sd_layout.leftSpaceToView(self.view,150)
                .topSpaceToView(self.view,100)
                .widthIs(140)
                .heightIs(50);
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
                sd_layout.leftSpaceToView(self.view,150)
                .topSpaceToView(self.view,200)
                .widthIs(140)
                .heightIs(50);
            });
        }];
    }
    return _textView;
}


@end
