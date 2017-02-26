#import <UIKit/UIKit.h>
#pragma mark --基本方法扩展
#define LH_Valist(...)  lh_valist(metamacro_argcount(__VA_ARGS__),__VA_ARGS__)
NSMutableArray* lh_valist(NSUInteger count, NSString* value,...);
#define NullReturn(property) if (!property || [property isKindOfClass:[NSNull class]]) {NSLog(@"不能输入nill");return self;}
typedef  void (^ClickBlock)(id value);
typedef  void (^ClickIndexBlock)(id value,NSInteger index);
typedef  void (^KVOBlock)(id value);
typedef  NSObject * (^PropertyKVOBlock)(NSString*property,KVOBlock blcok);
typedef  void (^UIViewAnimationBlock)(UIView* value);
typedef  NSObject * (^PropertyBlock)(NSString*propertyList,id value);
typedef  NSObject * (^ReturnBlock)(id value);
@interface NSObject (LHUI)
@property (nonatomic,readonly) PropertyBlock lh_propertyById;
@property (nonatomic,readonly) PropertyKVOBlock lh_kvo;
+ (instancetype)return:(ReturnBlock)block;
@end

#pragma mark --UIView扩展
typedef  void (^UILayoutBlock)(SDAutoLayoutModel *sd_layout);
typedef  UIView* (^UILayoutActionBlock)(UIView*superview,UILayoutBlock value);
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
@property (nonatomic,readonly) UILayoutActionBlock lh_layout;

@end

#pragma mark --UIButton扩展
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

#pragma mark --UIAlertView扩展
typedef  UIAlertView* (^UIAlertViewClickActionBlock)(ClickIndexBlock value);
typedef  UIAlertView * (^UIAlertViewSetPropertyBlock)(NSString* value);
typedef  UIAlertView * (^UIAlertViewSetBtnTitleBlock)(id value,...);
@interface UIAlertView (LHUI)
@property (nonatomic,readonly) UIAlertViewSetPropertyBlock lh_title;
@property (nonatomic,readonly) UIAlertViewSetPropertyBlock lh_message;
@property (nonatomic,readonly) UIAlertViewSetBtnTitleBlock lh_btnTitle;//NSString结尾必须nill
@property (nonatomic,readonly) UIAlertViewClickActionBlock lh_clickAction;
@end
