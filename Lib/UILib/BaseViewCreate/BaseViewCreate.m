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
        return block([self new]);
    }
    return [self new];
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
@end


@implementation UIView (LHUI)

-(UISetValueBlock)lh_layer_cornerRadius{
    @weakify(self);
    UISetValueBlock tmpBlock= ^(id value){
        @strongify(self);
        return (UIView*)(self
                         .lh_propertyById(@"layer.cornerRadius",value)
                         .lh_propertyById(@"layer.masksToBounds",0));
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
            if(value){
                value(x);
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
//@property (nonatomic,readonly) UILabelSetTextColorBlock lh_textColor;
//@property (nonatomic,readonly) UILabelSetTextAlignmentBlock lh_textAlignment;
//@property (nonatomic,readonly) UILabelSetLineBreakModeBlock lh_lineBreakMode;
//@property (nonatomic,readonly) UILabelSetNumberOfLinesBlock lh_numberOfLines;
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
        self.image = [UIImage imageNamed:value];
        return self;
    };
    return tmpBlock;
}
@end
