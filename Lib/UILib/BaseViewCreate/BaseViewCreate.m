#import "BaseViewCreate.h"
#import <objc/runtime.h>
NSMutableArray* lh_valist(NSUInteger count, NSString* value,...){
    NSMutableArray*array = [NSMutableArray array];
    va_list params;
    va_start(params, value);
    NSString*valueeee = [[NSString alloc] initWithFormat:@"%@" arguments:params];
    NSLog(@"%@",valueeee);
    [array addObject:value];
    NSString *temp = nil;
    while (--count) {
        @try{
            temp = va_arg(params, NSString*);
        }@catch(NSException* e) {
            NSLog(@"Error:动态读取属性错误");
            break;
        }
        if (temp ==nil) {
            break;
        }else{
            [array addObject:temp];
        }
    }
    NSLog(@"%@",array);
    return array;
}



@implementation NSObject (LHUI)
@dynamic lh_Mudict;
const static void *lh_Mudict_Key = &lh_Mudict_Key;
-(PropertyBlock)lh_propertyById{
    @weakify(self);
    PropertyBlock tmppropertyById = ^(NSString*propertyList,id value){
        @strongify(self);
        NullReturn(propertyList)
        NSArray *aArray = [propertyList componentsSeparatedByString:@"."];
        __block id tmpValue = self;
        NSInteger count = aArray.count -1;
        for (NSInteger i = 0; i < count; i++) {
            @try{
                tmpValue = [tmpValue valueForKey:aArray[i]];
            }@catch(NSException* e) {
                NSLog(@"Error:传入的(%@)属性没有读取到",aArray[i]);
                return self;
            }
            
            if(!tmpValue || ![tmpValue isKindOfClass:[NSObject class]]){
                NSLog(@"Error:传入的(%@)属性没有读取到",aArray[i]);
                return self;
            }
        }
        if(value){
            @try{
                [tmpValue setValue:value forKey:aArray[count]];
            }@catch(NSException* e) {
                NSLog(@"Error:修改(%@)属性错误",aArray[count]);
            }
        }else{
            NSLog(@"warning:传入的value的类型和要修改的属性的类型一样");
        }
        
        return self;
    };
    return tmppropertyById;
}

+ (instancetype)return:(ReturnBlock)block {
    if(block){
        return block(self.new);
    }
    return self.new;
}
-(NSString*)lh_NSObjectId{
    return ([NSString stringWithFormat:@"%ld",(long)((NSInteger)self)]);
}

-(PropertyKVOBlock)lh_kvo{
    @weakify(self);
    PropertyKVOBlock tmpBlock= ^(NSString*property,KVOBlock blcok){
        NullReturn(blcok)
        NullReturn(property)
        @strongify(self);
        [[self rac_valuesForKeyPath:property observer:nil] subscribeNext:^(id x) {
            blcok(x);
        }];
        
        return self;
    };
    return tmpBlock;
}
-(NSNotificationBlock)lh_notification{
    @weakify(self);
    NSNotificationBlock tmpBlock= ^(NSString*property,KVOBlock blcok){
        NullReturn(blcok)
        NullReturn(property)
        @strongify(self);
        self.lh_removeNotification(property);
        RACDisposable*disposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:property object:nil] subscribeNext:^(NSNotification *notification) {
            blcok(notification);
        }];
        [self.lh_Mudict setObject:disposable forKey:property];
        return self;
    };
    return tmpBlock;
}

-(RemoveNSNotificationBlock)lh_removeNotification{
    @weakify(self);
    RemoveNSNotificationBlock tmpBlock= ^(NSString*property){
        NullReturn(property)
        @strongify(self);
        RACDisposable*disposable = [self.lh_Mudict objectForKey:property];
        if(disposable){
            [disposable dispose];
            [self.lh_Mudict removeObjectForKey:property];
        }
        return self;
    };
    return tmpBlock;
}
-(PostNSNotificationBlock)lh_postNotification{
    @weakify(self);
    PostNSNotificationBlock tmpBlock= ^(NSString*property,id value){
        NullReturn(property)
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:property object:value];
        return self;
    };
    return tmpBlock;
}


- (NSMutableDictionary *)lh_Mudict {
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &lh_Mudict_Key);
    if (operations) {
        return operations;
    }
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &lh_Mudict_Key, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}

-(SetWeakObjBlock)lh_weakSet{
    @weakify(self);
    SetWeakObjBlock tmpBlock= ^(NSString*key,id value){
        NullReturn(key)
        @strongify(self);
        [self.lh_Mudict setObject:@"" forKey:key];
        objc_setAssociatedObject(self,(__bridge const void *)([self.lh_Mudict objectForKey:key]),value,OBJC_ASSOCIATION_ASSIGN);
        return self;
    };
    return tmpBlock;
    
}

-(GetWeakObjBlock)lh_weakGet{
    @weakify(self);
    GetWeakObjBlock tmpBlock= ^(NSString*key){
        NullReturn(key)
        @strongify(self);
        NSObject* value = nil;
        if(!key || ![self.lh_Mudict objectForKey:key]){
            return value;
        }
        value = objc_getAssociatedObject(self,(__bridge const void *)([self.lh_Mudict objectForKey:key]));
        return value;
    };
    return tmpBlock;
}

-(SignalForSelectorBlock)lh_signalForSelector{
    @weakify(self);
    SignalForSelectorBlock tmpBlock= ^(SEL selector,RACTupleBlock value){
        @strongify(self);
        NullReturn(value)
        if([self respondsToSelector:selector]){
            [[self rac_signalForSelector:selector] subscribeNext:^(RACTuple *tuple) {
                value(tuple);
            }];
        }
        return self;
    };
    return tmpBlock;
}
@end

@implementation NSString (LHUI)
-(NSUInteger)lh_StrUniqueNumber{
    NSUInteger value = 1;
    NSUInteger count = 15;
    if(self.length && self.length <= count){
        count = self.length;
    }
    NSUInteger diffCount = self.length/count;
    for(int i=0; i < self.length; ){
        value += ([self characterAtIndex: i])*value;
        i += diffCount;
    }
    return value+self.length;
}
@end

@implementation UIView (LHUI)

-(UISetValueBlock)lh_layer_cornerRadius{
    @weakify(self);
    UISetValueBlock tmpBlock= ^(id value){
        @strongify(self);
        return (UIView*)(self
                         .lh_propertyById(@"layer.cornerRadius",value)
                         .lh_propertyById(@"layer.masksToBounds",@(0)));
    };
    return tmpBlock;
}


-(UISetValueBlock)lh_backgroundColor{
    @weakify(self);
    UISetValueBlock tmpBlock= ^(id value){
        @strongify(self);
        return (UIView*)(self
                         .lh_propertyById(@"backgroundColor",value));
    };
    return tmpBlock;
}
-(UISetValueBlock)lh_alpha{
    @weakify(self);
    UISetValueBlock tmpBlock= ^(id value){
        @strongify(self);
        return (UIView*)(self
                         .lh_propertyById(@"alpha",value));
    };
    return tmpBlock;
}

-(UIAddSubviewBlock)lh_addSubview{
    @weakify(self);
    UIAddSubviewBlock tmpBlock= ^(UIView* value){
        @strongify(self);
        [self addSubview:value];
        return self;
    };
    return tmpBlock;
}

-(UIViewMoreSubviewBlock)lh_addMoreSubview{
    @weakify(self);
    UIViewMoreSubviewBlock tmpBlock= ^(id value,...){
        @strongify(self);
        if(!value){
            return self;
        }else if ([value isKindOfClass:[NSArray class]]){
            for (UIView* v in value) {
                [self addSubview:v];
            }
            return self;
        }
        va_list params;
        va_start(params, value);
        if (value) {
            [self addSubview:value];
            UIView *temp = nil;;
            while (YES) {
                NSLog(@"%@",[NSString stringWithCString:params encoding:NSUTF8StringEncoding]);
                @try{
                    temp = va_arg(params, UIView*);
                }@catch(NSException* e) {
                    NSLog(@"Error:动态读取属性错误");
                    break;
                }
                if (temp ==nil) {
                    break;
                }else{
                    [self addSubview:temp];
                }
            }
        }
        va_end(params);
        return self;
    };
    return tmpBlock;
}

-(UIAddSubviewBlock)lh_beAddSubview{
    @weakify(self);
    UIAddSubviewBlock tmpBlock= ^(UIView* value){
        @strongify(self);
        [value addSubview:self];
        return self;
    };
    return tmpBlock;
}


-(UISetCGRectBlock)lh_frame{
    @weakify(self);
    UISetCGRectBlock tmpBlock= ^(CGRect value){
        @strongify(self);
        self.frame = value;
        return self;
    };
    return tmpBlock;
}

-(UISetCGSizeBlock)lh_size{
    @weakify(self);
    UISetCGSizeBlock tmpBlock= ^(CGSize value){
        @strongify(self);
        self.size_sd = value;
        return self;
    };
    return tmpBlock;
}
-(UISetCGPointBlock)lh_point{
    @weakify(self);
    UISetCGPointBlock tmpBlock= ^(CGPoint value){
        @strongify(self);
        self.origin_sd = value;
        return self;
    };
    return tmpBlock;
}

-(UISetValueBlock)lh_hidden{
    @weakify(self);
    UISetValueBlock tmpBlock= ^(id value){
        @strongify(self);
        return (UIView*)(self
                         .lh_propertyById(@"hidden",value));
    };
    return tmpBlock;
}
-(UISetValueBlock)lh_enabled{
    @weakify(self);
    UISetValueBlock tmpBlock= ^(id value){
        @strongify(self);
        return (UIView*)(self
                         .lh_propertyById(@"enabled",value));
    };
    return tmpBlock;
}
-(UISetValueBlock)lh_scale{
    @weakify(self);
    UISetValueBlock tmpBlock= ^(id value){
        @strongify(self);
        NSNumber *number = value;
        CGFloat scale = [number floatValue];
        self.transform = CGAffineTransformMakeScale(scale,scale);
        return self;
    };
    return tmpBlock;
}
-(UIViewAnimationActionBlock)lh_anim{
    @weakify(self);
    UIViewAnimationActionBlock tmpBlock= ^(UIViewAnimationBlock value,UIViewAnimationCurve curve,NSTimeInterval duration){
        @strongify(self);
        NullReturn(value)
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationDuration:duration];
        value(self);
        [UIView commitAnimations];
        return self;
    };
    return tmpBlock;
}

-(UILayoutActionBlock)lh_layout{
    @weakify(self);
    UILayoutActionBlock tmpBlock= ^(UIView*superview,UILayoutBlock value){
        @strongify(self);
        NullReturn(value)
        NullReturn(superview)
        [superview addSubview:self];
        value(self.sd_layout);
        return self;
    };
    return tmpBlock;
}

-(UITapGestureBlock)lh_gesture{
    @weakify(self);
    UITapGestureBlock tmpBlock= ^(NSInteger numberTouches,NSInteger numberTaps,ClickBlock value){
        @strongify(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.numberOfTouchesRequired = numberTouches; //手指数
        tap.numberOfTapsRequired = numberTaps; //tap次数
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            @try{
                if(value){
                    value(x);
                }
            }@catch(NSException* e) {
                NSLog(@"Error:lh_gesture");
            }
            
            
        }];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        return self;
    };
    return tmpBlock;
}

@end


@implementation UIButton (LHUI)
-(UIButtonClickActionBlock)lh_clickAction{
    @weakify(self);
    UIButtonClickActionBlock tmpBlock= ^(ClickBlock value){
        @strongify(self);
        self.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            if(value){
                value(input);
            }
            return [RACSignal empty];
        }];
        return self;
    };
    return tmpBlock;
}
-(UIButtonSetTitleBlock)lh_title{
    @weakify(self);
    UIButtonSetTitleBlock tmpBlock= ^(NSString* value,UIControlState state){
        @strongify(self);
        [self setTitle:value forState:state];
        return self;
    };
    return tmpBlock;
}
-(UIButtonSetTitleColorBlock)lh_titleColor{
    @weakify(self);
    UIButtonSetTitleColorBlock tmpBlock= ^(UIColor* value,UIControlState state){
        @strongify(self);
        [self setTitleColor:value forState:state];
        return self;
    };
    return tmpBlock;
}

-(UIButtonSetTitleFontBlock)lh_titleFont{
    @weakify(self);
    UIButtonSetTitleFontBlock tmpBlock= ^(UIFont* value){
        @strongify(self);
        return (UIButton*)(self
                           .lh_propertyById(@"titleLabel.font",value));
    };
    return tmpBlock;
}

-(UIButtonSetImageBlock)lh_backgroundImage{
    @weakify(self);
    UIButtonSetImageBlock tmpBlock= ^(UIImage* value,UIControlState state){
        @strongify(self);
        [self setBackgroundImage:value forState:state];
        return self;
    };
    return tmpBlock;
}

-(UIButtonSetImageBlock)lh_image{
    @weakify(self);
    UIButtonSetImageBlock tmpBlock= ^(UIImage* value,UIControlState state){
        @strongify(self);
        [self setImage:value forState:state];
        return self;
    };
    return tmpBlock;
}


@end



@implementation UIAlertView (LHUI)
-(UIAlertViewSetPropertyBlock)lh_title{
    @weakify(self);
    UIAlertViewSetPropertyBlock tmpBlock= ^(NSString* value){
        @strongify(self);
        self.title = value;
        return self;
    };
    return tmpBlock;
}
-(UIAlertViewSetPropertyBlock)lh_message{
    @weakify(self);
    UIAlertViewSetPropertyBlock tmpBlock= ^(NSString* value){
        @strongify(self);
        self.message = value;
        return self;
    };
    return tmpBlock;
}
-(UIAlertViewSetBtnTitleBlock)lh_btnTitle{
    @weakify(self);
    UIAlertViewSetBtnTitleBlock tmpBlock= ^(id value,...){
        @strongify(self);
        if(!value){
            return self;
        }else if ([value isKindOfClass:[NSArray class]]){
            for (NSString*title in value) {
                [self addButtonWithTitle:title];
            }
            return self;
        }
        va_list params;
        va_start(params, value);
        if (value) {
            [self addButtonWithTitle:value];
            NSString *temp = nil;;
            while (YES) {
                NSLog(@"%@",[NSString stringWithCString:params encoding:NSUTF8StringEncoding]);
                @try{
                    temp = va_arg(params, NSString*);
                }@catch(NSException* e) {
                    NSLog(@"Error:动态读取属性错误");
                    break;
                }
                if (temp ==nil) {
                    break;
                }else{
                    [self addButtonWithTitle:temp];
                }
            }
        }
        va_end(params);
        return self;
    };
    return tmpBlock;
}
-(UIAlertViewClickActionBlock)lh_clickAction{
    @weakify(self);
    UIAlertViewClickActionBlock tmpBlock= ^(ClickIndexBlock value){
        @strongify(self);
        [[self rac_buttonClickedSignal] subscribeNext:^(id x) {
            if(value){
                value(self,[x integerValue]);
            }
        }];
        return self;
    };
    return tmpBlock;
}
@end

@implementation UITextField (LHUI)
-(UITextFieldClickActionBlock)lh_clickAction{
    @weakify(self);
    UITextFieldClickActionBlock tmpBlock= ^(SelfClickBlock value){
        @strongify(self);
        [[self rac_textSignal] subscribeNext:^(id x) {
            if(value){
                value(self,x);
            }
        }];
        return self;
    };
    return tmpBlock;
    
}
@end


@implementation UITextView (LHUI)
-(UITextViewClickActionBlock)lh_clickAction{
    @weakify(self);
    UITextViewClickActionBlock tmpBlock= ^(SelfClickBlock value){
        @strongify(self);
        [[self rac_textSignal] subscribeNext:^(id x) {
            if(value){
                value(self,x);
            }
        }];
        return self;
    };
    return tmpBlock;
    
}
@end

#pragma mark --UILabel扩展
@implementation UILabel (LHUI)
-(UILabelSetTextColorBlock)lh_textColor{
    @weakify(self);
    UILabelSetTextColorBlock tmpBlock= ^(UIColor* value){
        @strongify(self);
        return (UILabel*)(self
                          .lh_propertyById(@"textColor",value));
    };
    return tmpBlock;
}

-(UILabelSetTextAlignmentBlock)lh_textAlignment{
    @weakify(self);
    UILabelSetTextAlignmentBlock tmpBlock= ^(NSTextAlignment value){
        @strongify(self);
        return (UILabel*)(self
                          .lh_propertyById(@"textAlignment",@(value)));
    };
    return tmpBlock;
}

-(UILabelSetLineBreakModeBlock)lh_lineBreakMode{
    @weakify(self);
    UILabelSetLineBreakModeBlock tmpBlock=  ^(NSLineBreakMode value){
        @strongify(self);
        return (UILabel*)(self
                          .lh_propertyById(@"lineBreakMode",@(value)));
    };
    return tmpBlock;
}

-(UILabelSetNumberOfLinesBlock)lh_numberOfLines{
    @weakify(self);
    UILabelSetNumberOfLinesBlock tmpBlock=  ^(NSInteger value){
        @strongify(self);
        return (UILabel*)(self
                          .lh_propertyById(@"numberOfLines",@(value)));
    };
    return tmpBlock;
}

-(UILabelSetTextBlock)lh_text{
    @weakify(self);
    UILabelSetTextBlock tmpBlock=  ^(NSString* value){
        @strongify(self);
        return (UILabel*)(self
                          .lh_propertyById(@"text",value));
    };
    return tmpBlock;
}

@end


@implementation LHUIImageView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGFloat lhwidth = 55;
    CGRect bounds = self.bounds;
    //若原热区小于55x55，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(lhwidth - bounds.size.width, 0);
    CGFloat heightDelta = MAX(lhwidth - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
@end
#pragma mark --UIImageView扩展
@implementation UIImageView (LHUI)
-(UIImageViewSetImageBlock)lh_image{
    @weakify(self);
    UIImageViewSetImageBlock tmpBlock=  ^(UIImage* value){
        @strongify(self);
        return (UIImageView*)(self
                              .lh_propertyById(@"image",value));
    };
    return tmpBlock;
}
-(UIImageViewSetNameBlock)lh_name{
    @weakify(self);
    UIImageViewSetNameBlock tmpBlock=  ^(NSString* value){
        @strongify(self);
        NullReturn(value);
        return (UIImageView*)(self
                              .lh_propertyById(@"image",[UIImage imageNamed:value]));
        return self;
    };
    return tmpBlock;
}

-(UIImageViewSetImageTintColorBlock)lh_imageAndTintColor{
    @weakify(self);
    UIImageViewSetImageTintColorBlock tmpBlock=  ^(UIImage* value,UIColor*color){
        @strongify(self);
        return (UIImageView*)(self
                              .lh_propertyById(@"image",[value imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)])
                              .lh_propertyById(@"tintColor",color));
    };
    return tmpBlock;
}
-(UIImageViewSetNameTintColorBlock)lh_nameAndTintColor{
    @weakify(self);
    UIImageViewSetNameTintColorBlock tmpBlock=  ^(NSString* value,UIColor*color){
        @strongify(self);
        NullReturn(value);
        return (UIImageView*)(self
                              .lh_propertyById(@"image",[[UIImage imageNamed:value] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)])
                              .lh_propertyById(@"tintColor",color));
        return self;
    };
    return tmpBlock;
}

-(UIViewContentModeBlock)lh_contentMode{
    @weakify(self);
    UIViewContentModeBlock tmpBlock=  ^(UIViewContentMode value){
        @strongify(self);
        self.contentMode = value;
        return self;
    };
    return tmpBlock;
}
-(UIViewTintColorBlock)lh_tintColor{
    @weakify(self);
    UIViewTintColorBlock tmpBlock=  ^(UIColor* value){
        @strongify(self);
        self.tintColor = value;
        return self;
    };
    return tmpBlock;
}

@end

#pragma mark --UIActionSheet扩展
@implementation UIActionSheet (LHUI)
-(UIActionSheetSetActionSheetStyleBlock)lh_actionSheetStyle{
    @weakify(self);
    UIActionSheetSetActionSheetStyleBlock tmpBlock=  ^(UIActionSheetStyle value){
        @strongify(self);
        self.actionSheetStyle = value;
        return self;
    };
    return tmpBlock;
}

-(UIActionSheetSetPropertyBlock)lh_title{
    @weakify(self);
    UIActionSheetSetPropertyBlock tmpBlock=  ^(NSString* value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"title"];
        [self lh_initView];
        return self;
    };
    return tmpBlock;
}

-(UIActionSheetSetPropertyBlock)lh_cancelButtonTitle{
    @weakify(self);
    UIActionSheetSetPropertyBlock tmpBlock=  ^(NSString* value){
        @strongify(self);
        NullReturn(value);
        self.title = value;
        [self.lh_Mudict setObject:value forKey:@"cancelButtonTitle"];
        [self lh_initView];
        return self;
    };
    return tmpBlock;
}
-(UIActionSheetSetPropertyBlock)lh_destructiveButtonTitle{
    @weakify(self);
    UIActionSheetSetPropertyBlock tmpBlock=  ^(NSString* value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"destructiveButtonTitle"];
        [self lh_initView];
        return self;
    };
    return tmpBlock;
}

-(UIActionSheetClickActionBlock)lh_clickAction{
    @weakify(self);
    UIActionSheetClickActionBlock tmpBlock= ^(ClickIndexBlock value){
        @strongify(self);
        [[self rac_buttonClickedSignal] subscribeNext:^(id x) {
            if(value){
                value(self,[x integerValue]);
            }
        }];
        return self;
    };
    return tmpBlock;
}

-(UIActionSheetSetBtnTitleBlock)lh_btnTitle{
    @weakify(self);
    UIActionSheetSetBtnTitleBlock tmpBlock= ^(id value,...){
        @strongify(self);
        NSMutableArray*array = [self.lh_Mudict arraymuValue:@"btnTitle"];
        [self.lh_Mudict setObject:array forKey:@"btnTitle"];
        if(!value){
            return self;
        }else if ([value isKindOfClass:[NSArray class]]){
            for (NSString*title in value) {
                [self addButtonWithTitle:title];
                [array addObject:title];
            }
            return self;
        }
        va_list params;
        va_start(params, value);
        if (value) {
            [self addButtonWithTitle:value];
            [array addObject:value];
            NSString *temp = nil;;
            while (YES) {
                NSLog(@"%@",[NSString stringWithCString:params encoding:NSUTF8StringEncoding]);
                @try{
                    temp = va_arg(params, NSString*);
                }@catch(NSException* e) {
                    NSLog(@"Error:动态读取属性错误");
                    break;
                }
                if (temp ==nil) {
                    break;
                }else{
                    [self addButtonWithTitle:temp];
                    [array addObject:temp];
                }
            }
        }
        va_end(params);
        return self;
    };
    return tmpBlock;
}
-(void)lh_initView{
    UIActionSheet* tmpSelf = [self initWithTitle:[self.lh_Mudict strValue:@"title"] delegate:nil cancelButtonTitle:[self.lh_Mudict strValue:@"cancelButtonTitle"] destructiveButtonTitle:[self.lh_Mudict strValue:@"destructiveButtonTitle"] otherButtonTitles: nil];
    NSMutableArray*array = [self.lh_Mudict arraymuValue:@"btnTitle"];
    for (NSString*title in array) {
        [tmpSelf addButtonWithTitle:title];
    }
}
@end

#pragma mark --UIProgressView扩展
@implementation UIProgressView (LHUI)
-(UIProgressViewSetPropertyBlock)lh_progressTintColor{
    @weakify(self);
    UIProgressViewSetPropertyBlock tmpBlock= ^(UIColor* value){
        @strongify(self);
        self.progressTintColor = value;
        return self;
    };
    return tmpBlock;
}
-(UIProgressViewSetPropertyBlock)lh_trackTintColor{
    @weakify(self);
    UIProgressViewSetPropertyBlock tmpBlock= ^(UIColor* value){
        @strongify(self);
        self.trackTintColor = value;
        return self;
    };
    return tmpBlock;
}
@end

#pragma mark --UITableView扩展
@implementation LHUITableView
@end
@implementation LHUITableView (LHUI)
-(UITableViewDelegateBlock)lh_delegate{
    @weakify(self);
    UITableViewDelegateBlock tmpBlock= ^(id<UITableViewDelegate> value){
        @strongify(self);
        NullReturn(value);
        self.lh_weakSet(@"delegate",value);
        self.delegate = self;
        return self;
    };
    return tmpBlock;
}
-(UITableViewDataSourceBlock)lh_dataSource{
    @weakify(self);
    UITableViewDataSourceBlock tmpBlock= ^(id<UITableViewDataSource> value){
        @strongify(self);
        NullReturn(value);
        self.lh_weakSet(@"dataSource",value);
        self.dataSource = self;
        return self;
    };
    return tmpBlock;
}
-(UITableDelegateAndDataBlock)lh_delegateDataSource{
    @weakify(self);
    UITableDelegateAndDataBlock tmpBlock= ^(id<UITableViewDelegate,UITableViewDataSource> value){
        @strongify(self);
        NullReturn(value);
        self.delegate = self;
        self.dataSource = self;
        self.lh_weakSet(@"dataSource",value);
        self.lh_weakSet(@"delegate",value);
        return self;
    };
    return tmpBlock;
}
-(UITableViewCellSeparatorStyleBlock)lh_separatorStyle{
    @weakify(self);
    UITableViewCellSeparatorStyleBlock tmpBlock= ^(UITableViewCellSeparatorStyle value){
        @strongify(self);
        self.separatorStyle = value;
        return self;
    };
    return tmpBlock;
}
-(UITableViewStyleBlock)lh_style{
    @weakify(self);
    UITableViewStyleBlock tmpBlock= ^(UITableViewStyle value){
        @strongify(self);
        id tmpself = [self initWithFrame:self.frame style:value];
        return tmpself;
    };
    return tmpBlock;
}

-(UITableViewSetUIViewBlock)lh_tableFooterView{
    @weakify(self);
    UITableViewSetUIViewBlock tmpBlock= ^(UIView* value){
        @strongify(self);
        self.tableFooterView = value;
        return self;
    };
    return tmpBlock;
}

-(UITableViewSetUIViewBlock)lh_tableHeaderView{
    @weakify(self);
    UITableViewSetUIViewBlock tmpBlock= ^(UIView* value){
        @strongify(self);
        self.tableHeaderView = value;
        return self;
    };
    return tmpBlock;
}
-(UITableViewSetUIEdgeInsetsBlock)lh_separatorInset{
    @weakify(self);
    UITableViewSetUIEdgeInsetsBlock tmpBlock= ^(UIEdgeInsets value){
        @strongify(self);
        self.separatorInset = value;
        return self;
    };
    return tmpBlock;
}

-(UITableDataSourceNumberOfRowsBlock)lh_numberOfRowsInSection{
    @weakify(self);
    UITableDataSourceNumberOfRowsBlock tmpBlock= ^(DataSourceNumberOfRowsBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"dataSource_numberOfRowsInSection"];
        return self;
    };
    return tmpBlock;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    @try{
        DataSourceNumberOfRowsBlock valueBlcok = [self.lh_Mudict objectForKey:@"dataSource_numberOfRowsInSection"];
        if(valueBlcok){
            return  valueBlcok(section);
        }
        id<UITableViewDataSource> value = self.lh_weakGet(@"dataSource");
        if(value && [value respondsToSelector:@selector(tableView:numberOfRowsInSection:)]){
            return [value tableView:tableView numberOfRowsInSection:section];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:numberOfRowsInSection");
    }
    return 0;
}


-(UITableViewDelegatehHeightForRowAtIndexPathBlock)lh_heightForRowAtIndexPath{
    @weakify(self);
    UITableViewDelegatehHeightForRowAtIndexPathBlock tmpBlock= ^(DelegatehHeightForRowAtIndexPathBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_heightForRowAtIndexPath"];
        return self;
    };
    return tmpBlock;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try{
        DelegatehHeightForRowAtIndexPathBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_heightForRowAtIndexPath"];
        if(valueBlcok){
            return  valueBlcok(indexPath);
        }
        id<UITableViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
            return [value tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:heightForRowAtIndexPath");
    }
    return 0;
}

-(UITableViewDelegateDidSelectRowBlock)lh_didSelectRowAtIndexPath{
    @weakify(self);
    UITableViewDelegateDidSelectRowBlock tmpBlock= ^(DelegateDidSelectRowBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_didSelectRowAtIndexPath"];
        return self;
    };
    return tmpBlock;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        DelegateDidSelectRowBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_didSelectRowAtIndexPath"];
        if(valueBlcok){
            valueBlcok(indexPath);
        }
        id<UITableViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            return [value tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:didSelectRowAtIndexPath");
    }
}


-(UITableDataSourceNumberOfSectionsBlock)lh_numberOfSectionsInTableView{
    @weakify(self);
    UITableDataSourceNumberOfSectionsBlock tmpBlock= ^(NumberOfSectionsBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"dataSource_numberOfSectionsInTableView"];
        return self;
    };
    return tmpBlock;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    @try{
        NumberOfSectionsBlock valueBlcok = [self.lh_Mudict objectForKey:@"dataSource_numberOfSectionsInTableView"];
        if(valueBlcok){
            return valueBlcok(self);
        }
        id<UITableViewDataSource> value = self.lh_weakGet(@"dataSource");
        if(value && [value respondsToSelector:@selector(numberOfSectionsInTableView:)]){
            return [value numberOfSectionsInTableView:self];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:numberOfSectionsInTableView");
    }
    return 1;
}


-(UITableDataSourceCellForRowAtIndexPathBlock)lh_cellForRowAtIndexPath{
    @weakify(self);
    UITableDataSourceCellForRowAtIndexPathBlock tmpBlock= ^(CellForRowAtIndexPathBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"dataSource_cellForRowAtIndexPath"];
        return self;
    };
    return tmpBlock;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try{
        CellForRowAtIndexPathBlock valueBlcok = [self.lh_Mudict objectForKey:@"dataSource_cellForRowAtIndexPath"];
        if(valueBlcok){
            return valueBlcok(indexPath);
        }
        id<UITableViewDataSource> value = self.lh_weakGet(@"dataSource");
        if(value && [value respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]){
            return [value tableView:tableView cellForRowAtIndexPath:indexPath];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:cellForRowAtIndexPath");
    }
    NSString *ID = self.lh_NSObjectId;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(UITableViewRegisterClass)lh_registerClass{
    @weakify(self);
    UITableViewRegisterClass tmpBlock= ^(Class value){
        @strongify(self);
        NullReturn(value)
        [self registerClass:value forCellReuseIdentifier:self.lh_NSObjectId];
        return self;
    };
    return tmpBlock;
}


-(UITableViewDelegateViewForHeaderInSectionBlock)lh_viewForHeaderInSection{
    @weakify(self);
    UITableViewDelegateViewForHeaderInSectionBlock tmpBlock= ^(ViewForHeaderInSectionBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_viewForHeaderInSection"];
        return self;
    };
    return tmpBlock;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    @try{
        ViewForHeaderInSectionBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_viewForHeaderInSection"];
        if(valueBlcok){
            return valueBlcok(section);
        }
        id<UITableViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(tableView:viewForHeaderInSection:)]){
            return [value tableView:tableView viewForHeaderInSection:section];
        }
        
    }@catch(NSException* e) {
        NSLog(@"Error:viewForHeaderInSection");
    }
    return [UIView new];
}

-(UITableViewDelegateHeightForHeaderInSectionBlock)lh_heightForHeaderInSection{
    @weakify(self);
    UITableViewDelegateHeightForHeaderInSectionBlock tmpBlock= ^(HeightForHeaderInSectionBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_heightForHeaderInSection"];
        return self;
    };
    return tmpBlock;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    @try{
        HeightForHeaderInSectionBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_heightForHeaderInSection"];
        if(valueBlcok){
            return valueBlcok(section);
        }
        id<UITableViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(tableView:heightForHeaderInSection:)]){
            return [value tableView:self heightForHeaderInSection:section];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:heightForHeaderInSection");
    }
    return 0.0;
}

-(UITableViewDelegateEditingStyleForRowAtIndexPathBlock)lh_editingStyleForRowAtIndexPath{
    @weakify(self);
    UITableViewDelegateEditingStyleForRowAtIndexPathBlock tmpBlock= ^(EditingStyleForRowAtIndexPathBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_editingStyleForRowAtIndexPath"];
        return self;
    };
    return tmpBlock;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try{
        EditingStyleForRowAtIndexPathBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_editingStyleForRowAtIndexPath"];
        if(valueBlcok){
            return valueBlcok(indexPath);
        }
        id<UITableViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]){
            return [value tableView:self editingStyleForRowAtIndexPath:indexPath];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:heightForHeaderInSection");
    }
    return UITableViewCellEditingStyleNone;
    
}

-(UITableDataSourceCanMoveRowAtIndexPathBlockBlock)lh_canMoveRowAtIndexPath{
    @weakify(self);
    UITableDataSourceCanMoveRowAtIndexPathBlockBlock tmpBlock= ^(CanMoveRowAtIndexPathBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"dataSource_canMoveRowAtIndexPath"];
        return self;
    };
    return tmpBlock;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    @try{
        CanMoveRowAtIndexPathBlock valueBlcok = [self.lh_Mudict objectForKey:@"dataSource_canMoveRowAtIndexPath"];
        if(valueBlcok){
            return valueBlcok(indexPath);
        }
        id<UITableViewDataSource> value = self.lh_weakGet(@"dataSource");
        if(value && [value respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]){
            return [value tableView:tableView canMoveRowAtIndexPath:indexPath];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:cellForRowAtIndexPath");
    }
    return  NO;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        CanMoveRowAtIndexPathBlock valueBlcok = [self.lh_Mudict objectForKey:@"dataSource_canMoveRowAtIndexPath"];
        if(valueBlcok){
            valueBlcok(indexPath);
        }
        id<UITableViewDataSource> value = self.lh_weakGet(@"dataSource");
        if(value && [value respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]){
            return [value tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:cellForRowAtIndexPath");
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    @try{
        id<UITableViewDataSource> value = self.lh_weakGet(@"dataSource");
        if(value && [value respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]){
            return [value tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:cellForRowAtIndexPath");
    }
    
}
@end

#pragma mark --UICollectionViewFlowLayout扩展
@implementation UICollectionViewFlowLayout (LHUI)
-(UICollectionViewFlowLayoutScrollDirectionBlock)lh_scrollDirection{
    @weakify(self);
    UICollectionViewFlowLayoutScrollDirectionBlock tmpBlock= ^(UICollectionViewScrollDirection value){
        @strongify(self);
        self.scrollDirection = value;
        return self;
    };
    return tmpBlock;
}
-(UICollectionViewFlowLayoutItemSizeBlock)lh_itemSize{
    @weakify(self);
    UICollectionViewFlowLayoutItemSizeBlock tmpBlock= ^(CGSize value){
        @strongify(self);
        self.itemSize = value;
        return self;
    };
    return tmpBlock;
}
-(UICollectionViewFlowLayoutSectionInsetBlock)lh_sectionInset{
    @weakify(self);
    UICollectionViewFlowLayoutSectionInsetBlock tmpBlock= ^(UIEdgeInsets value){
        @strongify(self);
        self.sectionInset = value;
        return self;
    };
    return tmpBlock;
}
@end
#pragma mark --UICollectionView扩展
@implementation LHUICollectionView
@end
@implementation LHUICollectionView (LHUI)
-(UICollectionViewSetLayout)lh_collectionViewLayout{
    @weakify(self);
    UICollectionViewSetLayout tmpBlock= ^(UICollectionViewGetLayout value){
        @strongify(self);
        NullReturn(value)
        return [self initWithFrame:self.frame collectionViewLayout:value()];
    };
    return tmpBlock;
}
-(UICollectionViewRegisterClass)lh_registerClass{
    @weakify(self);
    UICollectionViewRegisterClass tmpBlock= ^(Class value){
        @strongify(self);
        NullReturn(value)
        [self registerClass:value forCellWithReuseIdentifier:self.lh_NSObjectId];
        return self;
    };
    return tmpBlock;
}
-(UICollectionViewDataSourceAndDelegateBlock)lh_delegate{
    @weakify(self);
    UICollectionViewDataSourceAndDelegateBlock tmpBlock= ^(id value){
        @strongify(self);
        NullReturn(value);
        self.lh_weakSet(@"delegate",value);
        self.delegate = self;
        return self;
    };
    return tmpBlock;
}
-(UICollectionViewDataSourceAndDelegateBlock)lh_dataSource{
    @weakify(self);
    UICollectionViewDataSourceAndDelegateBlock tmpBlock= ^(id value){
        @strongify(self);
        NullReturn(value);
        self.lh_weakSet(@"dataSource",value);
        self.dataSource = self;
        return self;
    };
    return tmpBlock;
}
-(UICollectionViewDataSourceAndDelegateBlock)lh_delegateDataSource{
    @weakify(self);
    UICollectionViewDataSourceAndDelegateBlock tmpBlock= ^(id value){
        @strongify(self);
        NullReturn(value);
        self.delegate = self;
        self.dataSource = self;
        self.lh_weakSet(@"dataSource",value);
        self.lh_weakSet(@"delegate",value);
        return self;
    };
    return tmpBlock;
}
-(UICollectionDataSourceNumberOfSectionsBlock)lh_numberOfSectionsInCollectionView{
    @weakify(self);
    UICollectionDataSourceNumberOfSectionsBlock tmpBlock= ^(NumberOfSectionsBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"dataSource_numberOfSectionsInCollectionView"];
        return self;
    };
    return tmpBlock;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    @try{
        id<UICollectionViewDataSource> value = self.lh_weakGet(@"dataSource");
        if(value && [value respondsToSelector:@selector(numberOfSectionsInCollectionView:)]){
            return [value numberOfSectionsInCollectionView:self];
        }
        NumberOfSectionsBlock valueBlcok = [self.lh_Mudict objectForKey:@"dataSource_numberOfSectionsInCollectionView"];
        if(valueBlcok){
            return valueBlcok(self);
        }
    }@catch(NSException* e) {
        NSLog(@"Error:numberOfSectionsInCollectionView");
    }
    return 1;
}

-(UICollectionDataSourceNumberOfItemsInSectionBlock)lh_numberOfItemsInSection{
    @weakify(self);
    UICollectionDataSourceNumberOfItemsInSectionBlock tmpBlock= ^(NumberOfItemsInSectionBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"dataSource_numberOfItemsInSection"];
        return self;
    };
    return tmpBlock;
}


//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    @try{
        id<UICollectionViewDataSource> value = self.lh_weakGet(@"dataSource");
        if(value && [value respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]){
            return [value numberOfSectionsInCollectionView:self];
        }
        NumberOfSectionsBlock valueBlcok = [self.lh_Mudict objectForKey:@"dataSource_numberOfItemsInSection"];
        if(valueBlcok){
            return valueBlcok(self);
        }
    }@catch(NSException* e) {
        NSLog(@"Error:numberOfItemsInSection");
    }
    return 1;
}

-(UICollectionDataSourceCellForItemAtIndexPathBlock)lh_cellForItemAtIndexPath{
    @weakify(self);
    UICollectionDataSourceCellForItemAtIndexPathBlock tmpBlock= ^(CellForRowAtIndexPathBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"dataSource_cellForItemAtIndexPath"];
        return self;
    };
    return tmpBlock;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    @try{
        id<UICollectionViewDataSource> value = self.lh_weakGet(@"dataSource");
        if(value && [value respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]){
            return [value collectionView:self cellForItemAtIndexPath:indexPath];
        }
        CellForRowAtIndexPathBlock valueBlcok = [self.lh_Mudict objectForKey:@"dataSource_cellForItemAtIndexPath"];
        if(valueBlcok){
            return valueBlcok(indexPath);
        }
    }@catch(NSException* e) {
        NSLog(@"Error:cellForItemAtIndexPath");
    }
    NSString *ID = self.lh_NSObjectId;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [UICollectionViewCell return:^NSObject *(UICollectionViewCell* value) {
            return value;
        }];
    }
    return cell;
    
}

-(UICollectionViewDelegateDidSelectRowBlock)lh_didSelectItemAtIndexPath{
    @weakify(self);
    UICollectionViewDelegateDidSelectRowBlock tmpBlock= ^(DelegateDidSelectRowBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_didSelectItemAtIndexPath"];
        return self;
    };
    return tmpBlock;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    @try{
        id<UICollectionViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]){
            return [value collectionView:self didSelectItemAtIndexPath:indexPath];
        }
        DelegateDidSelectRowBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_didSelectItemAtIndexPath"];
        if(valueBlcok){
            return valueBlcok(indexPath);
        }
    }@catch(NSException* e) {
        NSLog(@"Error:didSelectItemAtIndexPath");
    }
}
+ (instancetype)return:(ReturnBlock)block{
    if(block){
        return (LHUICollectionView*)block([[LHUICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]]);
    }
    return [[LHUICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
}
@end

#pragma mark --UIScrollView扩展
@implementation LHUIScrollView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
@end

@implementation UIScrollView (LHUI)
-(UIScrollViewDelegateBlock)lh_delegate{
    @weakify(self);
    UIScrollViewDelegateBlock tmpBlock= ^(id value){
        @strongify(self);
        NullReturn(value);
        self.lh_weakSet(@"delegate",value);
        self.delegate = self;
        return self;
    };
    return tmpBlock;
}

-(UIScrollViewBlock)lh_scrollViewDidScroll{
    @weakify(self);
    UIScrollViewBlock tmpBlock= ^(ScrollViewBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_scrollViewDidScroll"];
        return self;
    };
    return tmpBlock;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    @try{
        ScrollViewBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_scrollViewDidScroll"];
        if(valueBlcok){
            return valueBlcok(self);
        }
        id<UIScrollViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(scrollViewDidScroll:)]){
            return [value scrollViewDidScroll:self];
        }
        
    }@catch(NSException* e) {
        NSLog(@"Error:scrollViewDidScroll");
    }
}


-(UIScrollViewBlock)lh_scrollViewDidZoom{
    @weakify(self);
    UIScrollViewBlock tmpBlock= ^(ScrollViewBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_scrollViewDidZoom"];
        return self;
    };
    return tmpBlock;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    @try{
        ScrollViewBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_scrollViewDidZoom"];
        if(valueBlcok){
            return valueBlcok(self);
        }
        id<UIScrollViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(scrollViewDidZoom:)]){
            return [value scrollViewDidZoom:self];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:scrollViewDidZoom");
    }
}



-(UIScrollViewBlock)lh_scrollViewWillBeginDragging{
    @weakify(self);
    UIScrollViewBlock tmpBlock= ^(ScrollViewBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_scrollViewWillBeginDragging"];
        return self;
    };
    return tmpBlock;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    @try{
        ScrollViewBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_scrollViewWillBeginDragging"];
        if(valueBlcok){
            return valueBlcok(self);
        }
        id<UIScrollViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(scrollViewWillBeginDragging:)]){
            return [value scrollViewWillBeginDragging:self];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:scrollViewWillBeginDragging");
    }
}



-(UIScrollViewBlock)lh_scrollViewWillBeginDecelerating{
    @weakify(self);
    UIScrollViewBlock tmpBlock= ^(ScrollViewBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_scrollViewWillBeginDecelerating"];
        return self;
    };
    return tmpBlock;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    @try{
        ScrollViewBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_scrollViewWillBeginDecelerating"];
        if(valueBlcok){
            return valueBlcok(self);
        }
        id<UIScrollViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]){
            return [value scrollViewWillBeginDecelerating:self];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:scrollViewWillBeginDecelerating");
    }
}


-(UIScrollViewBlock)lh_scrollViewDidEndDecelerating{
    @weakify(self);
    UIScrollViewBlock tmpBlock= ^(ScrollViewBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_scrollViewDidEndDecelerating"];
        return self;
    };
    return tmpBlock;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    @try{
        
        ScrollViewBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_scrollViewDidEndDecelerating"];
        if(valueBlcok){
            return valueBlcok(self);
        }
        id<UIScrollViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(scrollViewDidEndDecelerating:)]){
            return [value scrollViewWillBeginDragging:self];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:scrollViewDidEndDecelerating");
    }
}
-(UIScrollViewBlock)lh_scrollViewDidEndScrollingAnimation{
    @weakify(self);
    UIScrollViewBlock tmpBlock= ^(ScrollViewBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_scrollViewDidEndScrollingAnimation"];
        return self;
    };
    return tmpBlock;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    @try{
        
        ScrollViewBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_scrollViewDidEndScrollingAnimation"];
        if(valueBlcok){
            return valueBlcok(self);
        }
        id<UIScrollViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]){
            return [value scrollViewDidEndScrollingAnimation:self];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:scrollViewDidEndScrollingAnimation");
    }
}

-(UIScrollViewBlock)lh_scrollViewDidScrollToTop{
    @weakify(self);
    UIScrollViewBlock tmpBlock= ^(ScrollViewBlock value){
        @strongify(self);
        NullReturn(value);
        [self.lh_Mudict setObject:value forKey:@"delegate_scrollViewDidScrollToTop"];
        return self;
    };
    return tmpBlock;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    @try{
        ScrollViewBlock valueBlcok = [self.lh_Mudict objectForKey:@"delegate_scrollViewDidScrollToTop"];
        if(valueBlcok){
            return valueBlcok(self);
        }
        id<UIScrollViewDelegate> value = self.lh_weakGet(@"delegate");
        if(value && [value respondsToSelector:@selector(scrollViewDidScrollToTop:)]){
            return [value scrollViewDidScrollToTop:self];
        }
    }@catch(NSException* e) {
        NSLog(@"Error:scrollViewDidScrollToTop");
    }
}
@end
#pragma mark --UIColor扩展
@implementation UIColor(LHUI)
+ (NSObject*)lh_manager{
    static dispatch_once_t onceToken;
    static NSObject *_manager = nil;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc] init];
        [_manager.lh_Mudict setObject:@"" forKey:@""];
    });
    return _manager;
}

+ (UIColor*)lh_ff32ff{
    if(![[self lh_manager].lh_Mudict objectForKey:@"0xff32ff"]){
        [[self lh_manager].lh_Mudict setObject:RGB(0xff32ff) forKey:@"0xff32ff"];
    }
    return [[self lh_manager].lh_Mudict objectForKey:@"0xff32ff"];
}
+ (UIColor *)lh_randomColor{
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}
@end
