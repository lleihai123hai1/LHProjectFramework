#import <UIKit/UIKit.h>
typedef  NSObject * (^PropertyBlock)(NSString*propertyList,id value);
typedef  NSObject * (^ReturnBlock)(id value);
@interface NSObject (LHUI)
@property (nonatomic,readonly) PropertyBlock lh_propertyById;
+ (instancetype)return:(ReturnBlock)block;
@end

typedef  UIView * (^UISetValueBlock)(id value);
typedef  UIView * (^UISetCGRectBlock)(CGRect value);
typedef  UIView * (^UISetCGSizeBlock)(CGSize value);
@interface UIView (LHUI)
@property (nonatomic,readonly) UISetValueBlock lh_backgroundColor;
@property (nonatomic,readonly) UISetValueBlock lh_alpha;
@property (nonatomic,readonly) UISetValueBlock lh_layer_cornerRadius;
@property (nonatomic,readonly) UISetCGRectBlock lh_frame;
@property (nonatomic,readonly) UISetCGSizeBlock lh_size;
@end


typedef  void (^ClickBlock)(id value);
typedef  UIButton* (^ClickActionBlock)(ClickBlock value);
@interface UIButton (LHUI)
@property (nonatomic,readonly) ClickActionBlock lh_clickAction;
@end

//UIButton*button = [UIButton return:^UIView *(UIButton* value) {
//    value.propertyById(@"backgroundColor",hColorRandomColor)
//    .propertyById(@"layer.cornerRadius",@(5))
//    .propertyById(@"frame.size.height",@"100");
//    return value;
//}];


