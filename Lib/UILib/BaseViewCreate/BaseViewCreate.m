#import "BaseViewCreate.h"

@implementation NSObject (LHUI)
-(PropertyBlock)lh_propertyById{
    @weakify(self);
    PropertyBlock tmppropertyById = ^(NSString*propertyList,id value){
        @strongify(self);
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
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationDuration:duration];
        value(self);
        [UIView commitAnimations];
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
            value(input);
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

