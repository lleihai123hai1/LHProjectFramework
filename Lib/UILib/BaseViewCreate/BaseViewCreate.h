#import <UIKit/UIKit.h>
#pragma mark --基本方法扩展
#define LH_Valist(...)  lh_valist(metamacro_argcount(__VA_ARGS__),__VA_ARGS__)
NSMutableArray* lh_valist(NSUInteger count, NSString* value,...);
#define NullReturn(property) if (!property || [property isKindOfClass:[NSNull class]]) {NSLog(@"不能输入nill");return self;}
typedef  NSObject* (^NSObjectVoidBlock)();
typedef  void (^ClickBlock)(id value);
typedef  void (^SelfClickBlock)(id selfValue,id value);
typedef  void (^ClickIndexBlock)(id value,NSInteger index);
typedef  void (^KVOBlock)(id value);
typedef  NSObject * (^PropertyKVOBlock)(NSString*property,KVOBlock blcok);
typedef  NSObject * (^NSNotificationBlock)(NSString*property,KVOBlock blcok);
typedef  NSObject * (^RemoveNSNotificationBlock)(NSString*name);
typedef  NSObject * (^PostNSNotificationBlock)(NSString*name,id value);
typedef  void (^UIViewAnimationBlock)(UIView* value);
typedef  NSObject * (^PropertyBlock)(NSString*propertyList,id value);
typedef  NSObject * (^ReturnBlock)(id value);
typedef  NSObject* (^SetWeakObjBlock)(NSString* key,id value);
typedef  id (^GetWeakObjBlock)(NSString* key);
typedef  void (^RACTupleBlock)(RACTuple *tuple);
typedef  NSObject* (^SignalForSelectorBlock)(SEL selector,RACTupleBlock value);
@interface NSObject (LHUI)
@property (nonatomic,readonly) NSMutableDictionary* lh_Mudict;
@property (nonatomic,readonly) PropertyBlock lh_propertyById;
@property (nonatomic,readonly) PropertyKVOBlock lh_kvo;
@property (nonatomic,readonly) NSNotificationBlock lh_notification;
@property (nonatomic,readonly) RemoveNSNotificationBlock lh_removeNotification;
@property (nonatomic,readonly) PostNSNotificationBlock lh_postNotification;
@property (nonatomic,readonly) SetWeakObjBlock lh_weakSet;
@property (nonatomic,readonly) GetWeakObjBlock lh_weakGet;
@property (nonatomic,readonly) SignalForSelectorBlock lh_signalForSelector;
@property (nonatomic,readonly) NSString* lh_NSObjectId;
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
typedef  UIView * (^UITapGestureBlock)(NSInteger numberTouches,NSInteger numberTaps,ClickBlock value);
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
@property (nonatomic,readonly) UITapGestureBlock lh_gesture;
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

#pragma mark --UITextField扩展
typedef  UITextField* (^UITextFieldClickActionBlock)(SelfClickBlock value);
@interface UITextField (LHUI)
@property (nonatomic,readonly) UITextFieldClickActionBlock lh_clickAction;
@end

#pragma mark --UITextView扩展
typedef  UITextView* (^UITextViewClickActionBlock)(SelfClickBlock value);
@interface UITextView (LHUI)
@property (nonatomic,readonly) UITextViewClickActionBlock lh_clickAction;
@end

#pragma mark --UILabel扩展
typedef  UILabel * (^UILabelSetTextColorBlock)(UIColor* value);
typedef  UILabel * (^UILabelSetTextAlignmentBlock)(NSTextAlignment value);
typedef  UILabel * (^UILabelSetLineBreakModeBlock)(NSLineBreakMode value);
typedef  UILabel * (^UILabelSetNumberOfLinesBlock)(NSInteger value);
typedef  UILabel * (^UILabelSetTextBlock)(NSString* value);
@interface UILabel (LHUI)
@property (nonatomic,readonly) UILabelSetTextColorBlock lh_textColor;
@property (nonatomic,readonly) UILabelSetTextAlignmentBlock lh_textAlignment;
@property (nonatomic,readonly) UILabelSetLineBreakModeBlock lh_lineBreakMode;
@property (nonatomic,readonly) UILabelSetTextBlock lh_text;
@end


#pragma mark --UIImageView扩展
typedef  UIImageView * (^UIImageViewSetImageBlock)(UIImage* value);
typedef  UIImageView * (^UIImageViewSetNameBlock)(NSString* value);
@interface UIImageView (LHUI)
@property (nonatomic,readonly) UIImageViewSetImageBlock lh_image;
@property (nonatomic,readonly) UIImageViewSetNameBlock lh_name;
@end

#pragma mark --UIActionSheet扩展
typedef  UIActionSheet * (^UIActionSheetSetActionSheetStyleBlock)(UIActionSheetStyle value);
typedef  UIActionSheet * (^UIActionSheetSetPropertyBlock)(NSString* value);
typedef  UIActionSheet * (^UIActionSheetSetBtnTitleBlock)(id value,...);
typedef  UIActionSheet* (^UIActionSheetClickActionBlock)(ClickIndexBlock value);
@interface UIActionSheet (LHUI)

@property (nonatomic,readonly) UIActionSheetSetActionSheetStyleBlock lh_actionSheetStyle;
@property (nonatomic,readonly) UIActionSheetSetPropertyBlock lh_title;
@property (nonatomic,readonly) UIActionSheetSetPropertyBlock lh_cancelButtonTitle;
@property (nonatomic,readonly) UIActionSheetSetPropertyBlock lh_destructiveButtonTitle;
@property (nonatomic,readonly) UIActionSheetSetBtnTitleBlock lh_btnTitle;//NSString结尾必须nill
@property (nonatomic,readonly) UIActionSheetClickActionBlock lh_clickAction;
@end

#pragma mark --UIProgressView扩展
typedef  UIProgressView * (^UIProgressViewSetPropertyBlock)(UIColor* value);
@interface UIProgressView (LHUI)
@property (nonatomic,readonly) UIProgressViewSetPropertyBlock lh_progressTintColor;
@property (nonatomic,readonly) UIProgressViewSetPropertyBlock lh_trackTintColor;
@end

#pragma mark --UIProgressView扩展 切记退出的时候调用lh_clear
typedef  UITableView * (^UITableViewDelegateBlock)(id<UITableViewDelegate> value);
typedef  UITableView * (^UITableViewDataSourceBlock)(id<UITableViewDataSource> value);
typedef  UITableView * (^UITableDelegateAndDataBlock)(id value);
typedef  UITableView * (^UITableViewCellSeparatorStyleBlock)(UITableViewCellSeparatorStyle value);
typedef  UITableView * (^UITableViewStyleBlock)(UITableViewStyle value);
typedef  UITableView * (^UITableViewSetUIViewBlock)(UIView* value);
typedef  UITableView * (^UITableViewSetUIEdgeInsetsBlock)(UIEdgeInsets value);
typedef  NSUInteger (^DataSourceNumberOfRowsBlock)(NSInteger section);
typedef  CGFloat (^DelegatehHeightForRowAtIndexPathBlock)(NSIndexPath *indexPath);
typedef  void (^DelegateDidSelectRowBlock)(NSIndexPath *indexPath);
typedef  UITableView* (^UITableDataSourceNumberOfRowsBlock)(DataSourceNumberOfRowsBlock value);
typedef  UITableView* (^UITableViewDelegatehHeightForRowAtIndexPathBlock)(DelegatehHeightForRowAtIndexPathBlock value);
typedef  UITableView* (^UITableViewDelegateDidSelectRowBlock)(DelegateDidSelectRowBlock value);
typedef  NSUInteger (^NumberOfSectionsBlock)(id value);
typedef  UITableView* (^UITableDataSourceNumberOfSectionsBlock)(NumberOfSectionsBlock value);

typedef  id (^CellForRowAtIndexPathBlock)(NSIndexPath *indexPath);
typedef  UITableView* (^UITableDataSourceCellForRowAtIndexPathBlock)(CellForRowAtIndexPathBlock value);
typedef  UITableView * (^UITableViewRegisterClass)(Class value);
@interface UITableView (LHUI)<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,readonly) UITableViewDelegateBlock lh_delegate;
@property (nonatomic,readonly) UITableViewDataSourceBlock lh_dataSource;
@property (nonatomic,readonly) UITableDelegateAndDataBlock lh_delegateDataSource;
@property (nonatomic,readonly) UITableViewCellSeparatorStyleBlock lh_separatorStyle;
@property (nonatomic,readonly) UITableViewStyleBlock lh_style;
@property (nonatomic,readonly) UITableViewSetUIViewBlock lh_tableFooterView;
@property (nonatomic,readonly) UITableViewSetUIViewBlock lh_tableHeaderView;
@property (nonatomic,readonly) UITableViewSetUIEdgeInsetsBlock lh_separatorInset;
@property (nonatomic,readonly) UITableDataSourceNumberOfRowsBlock lh_numberOfRowsInSection;
@property (nonatomic,readonly) UITableViewDelegatehHeightForRowAtIndexPathBlock lh_heightForRowAtIndexPath;
@property (nonatomic,readonly) UITableViewDelegateDidSelectRowBlock lh_didSelectRowAtIndexPath;
@property (nonatomic,readonly) UITableDataSourceNumberOfSectionsBlock lh_numberOfSectionsInTableView;
@property (nonatomic,readonly) UITableDataSourceCellForRowAtIndexPathBlock lh_cellForRowAtIndexPath;
@property (nonatomic,readonly) UITableViewRegisterClass lh_registerClass;
@end

#pragma mark --UICollectionViewFlowLayout扩展
typedef  UICollectionViewFlowLayout * (^UICollectionViewFlowLayoutScrollDirectionBlock)(UICollectionViewScrollDirection value);
typedef  UICollectionViewFlowLayout * (^UICollectionViewFlowLayoutItemSizeBlock)(CGSize value);
typedef  UICollectionViewFlowLayout * (^UICollectionViewFlowLayoutSectionInsetBlock)(UIEdgeInsets value);
@interface UICollectionViewFlowLayout (LHUI)
@property (nonatomic,readonly) UICollectionViewFlowLayoutScrollDirectionBlock lh_scrollDirection;
@property (nonatomic,readonly) UICollectionViewFlowLayoutItemSizeBlock lh_itemSize;
@property (nonatomic,readonly) UICollectionViewFlowLayoutSectionInsetBlock lh_sectionInset;
@end

#pragma mark --UICollectionView扩展
typedef  UICollectionViewLayout * (^UICollectionViewGetLayout)();
typedef  UICollectionView * (^UICollectionViewSetLayout)(UICollectionViewGetLayout value);
typedef  UICollectionView * (^UICollectionViewRegisterClass)(Class value);
typedef  UICollectionView * (^UICollectionViewDataSourceAndDelegateBlock)(id value);


typedef  NSUInteger (^NumberOfItemsInSectionBlock)(NSInteger value);
typedef  UICollectionView* (^UICollectionViewDelegateDidSelectRowBlock)(DelegateDidSelectRowBlock value);
typedef  UICollectionView* (^UICollectionDataSourceNumberOfItemsInSectionBlock)(NumberOfItemsInSectionBlock value);
typedef  UICollectionView* (^UICollectionDataSourceNumberOfSectionsBlock)(NumberOfSectionsBlock value);
typedef  UICollectionView* (^UICollectionDataSourceCellForItemAtIndexPathBlock)(CellForRowAtIndexPathBlock value);
@interface UICollectionView (LHUI)<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,readonly) UICollectionViewDataSourceAndDelegateBlock lh_delegate;
@property (nonatomic,readonly) UICollectionViewDataSourceAndDelegateBlock lh_dataSource;
@property (nonatomic,readonly) UICollectionViewDataSourceAndDelegateBlock lh_delegateDataSource;
@property (nonatomic,readonly) UICollectionViewSetLayout lh_collectionViewLayout;
@property (nonatomic,readonly) UICollectionViewRegisterClass lh_registerClass;

@property (nonatomic,readonly) UICollectionViewDelegateDidSelectRowBlock lh_didSelectItemAtIndexPath;
@property (nonatomic,readonly) UICollectionDataSourceNumberOfItemsInSectionBlock lh_numberOfItemsInSection;
@property (nonatomic,readonly) UICollectionDataSourceNumberOfSectionsBlock lh_numberOfSectionsInCollectionView;
@property (nonatomic,readonly) UICollectionDataSourceCellForItemAtIndexPathBlock lh_cellForItemAtIndexPath;
+ (instancetype)return:(ReturnBlock)block;
@end
#pragma mark --UIColor扩展
@interface UIColor (LHUI)
+ (UIColor*)lh_ff32ff;
+ (UIColor *)lh_randomColor;
@end

