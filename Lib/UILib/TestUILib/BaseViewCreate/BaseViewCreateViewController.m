#import "BaseViewCreateViewController.h"

@interface BaseViewCreateViewController ()
@property(nonatomic,strong)UIButton*button;
@end

@implementation BaseViewCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];

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
                    .lh_btnTitle(@"ok")
                    .lh_btnTitle(@"cancel<,>later")
                    .lh_clickAction(^(UIAlertView* value,NSInteger index){
                        NSLog(@"UIAlertView:%ld",(long)index);
                    });
                }] show];
            })
            .lh_backgroundColor([UIColor redColor])
            .lh_alpha(@(0.4))
            .lh_layer_cornerRadius(@(10))
            .lh_frame(CGRectMake(100, 200, 100, 100))
            .lh_kvo(@"frame",^(id value){
                NSLog(@"change_frame");
            });
        }];
    }
    return _button;
}


@end
