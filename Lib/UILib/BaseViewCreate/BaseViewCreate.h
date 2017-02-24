#import <UIKit/UIKit.h>
typedef  void (^ClickBlock)(id value);
typedef  void (^UIViewAnimationBlock)(UIView* value);
typedef  NSObject * (^PropertyBlock)(NSString*propertyList,id value);
typedef  NSObject * (^ReturnBlock)(id value);
@interface NSObject (LHUI)
@property (nonatomic,readonly) PropertyBlock lh_propertyById;
+ (instancetype)return:(ReturnBlock)block;
@end

typedef  UIView * (^UISetValueBlock)(id value);
typedef  UIView * (^UISetCGRectBlock)(CGRect value);
typedef  UIView * (^UISetCGSizeBlock)(CGSize value);
typedef  UIView * (^UISetCGPointBlock)(CGPoint value);


typedef  UIView* (^UIViewAnimationActionBlock)(UIViewAnimationBlock value,UIViewAnimationCurve curve,NSTimeInterval duration);


@interface UIView (LHUI)
@property (nonatomic,readonly) UISetValueBlock lh_layer_cornerRadius;
@property (nonatomic,readonly) UISetValueBlock lh_backgroundColor;
@property (nonatomic,readonly) UISetValueBlock lh_alpha;
@property (nonatomic,readonly) UISetCGRectBlock lh_frame;
@property (nonatomic,readonly) UISetCGSizeBlock lh_size;
@property (nonatomic,readonly) UISetCGPointBlock lh_point;
@property (nonatomic,readonly) UISetValueBlock lh_hidden;
@property (nonatomic,readonly) UISetValueBlock lh_enabled;
@property (nonatomic,readonly) UISetValueBlock lh_scale;
@property (nonatomic,readonly) UIViewAnimationActionBlock lh_anim;
@end


typedef  UIButton * (^UIButtonSetTitleFontBlock)(UIFont* value);
typedef  UIButton* (^UIButtonClickActionBlock)(ClickBlock value);

typedef  UIButton * (^UIButtonSetTitleBlock)(NSString* value,UIControlState state);
typedef  UIButton * (^UIButtonSetTitleColorBlock)(UIColor* value,UIControlState state);
typedef  UIButton * (^UIButtonSetImageBlock)(UIImage* value,UIControlState state);
@interface UIButton (LHUI)
@property (nonatomic,readonly) UIButtonClickActionBlock lh_clickAction;
@property (nonatomic,readonly) UIButtonSetTitleBlock lh_title;
@property (nonatomic,readonly) UIButtonSetTitleColorBlock lh_titleColor;
@property (nonatomic,readonly) UIButtonSetTitleFontBlock lh_titleFont;
@property (nonatomic,readonly) UIButtonSetImageBlock lh_backgroundImage;
@property (nonatomic,readonly) UIButtonSetImageBlock lh_image;
@end

//-(UIButton*)button{
//    if(!_button){
//        _button = [UIButton return:^NSObject *(UIButton* value) {
//            return value
//            .lh_clickAction(^(UIButton *sender){
//                NSLog(@"clickAction");
//            })
//            .lh_backgroundColor([UIColor redColor])
//            .lh_alpha(@(0.4))
//            .lh_layer_cornerRadius(@(10))
//            .lh_frame(CGRectMake(100, 200, 100, 100));
//        }];
//    }
//    return _button;
//}


