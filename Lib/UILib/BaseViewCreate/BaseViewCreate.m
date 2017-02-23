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
        self.size = value;
        return self;
    };
    return tmpBlock;
}



@end


@implementation UIButton (LHUI)
-(ClickActionBlock)lh_clickAction{
    @weakify(self);
    ClickActionBlock tmpBlock= ^(ClickBlock value){
        @strongify(self);
        self.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            value(input);
            return [RACSignal empty];
        }];
        return self;
    };
    return tmpBlock;
}

@end

