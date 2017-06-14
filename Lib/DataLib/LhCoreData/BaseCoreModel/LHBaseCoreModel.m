#import "LHBaseCoreModel.h"
#import "NSObject+MJProperty.h"
#import "MJProperty.h"
@implementation LHBaseCoreModel
@synthesize hostID;
static NSObject *_sharedManager = nil;
static dispatch_once_t onceToken;

/**
 返回缓存的model

 @param hostID hostID
 @return model
 */
+(instancetype)getModel:(NSString*)hostID{
    dispatch_once(&onceToken, ^{
        _sharedManager = [NSObject new];
    });
    return [_sharedManager.lh_Mudict objectForKey:[NSString stringWithFormat:@"%@_%@",[self class],hostID]];
}

/**
 week方式缓存model

 @param model model
 */
+(void)setModel:(LHBaseCoreModel*)model{
    dispatch_once(&onceToken, ^{
        _sharedManager = [NSObject new];
    });
    //缓存最新的model即和数据库一直的数据model，以后都可以 先读缓存，在读数据库。
    [_sharedManager.lh_Mudict setObject:[model copy] forKey:[NSString stringWithFormat:@"%@_%@",[model class],model.hostID]];
}


/**
 注入kvo并绑定通知
 
 @param hostID hostID
 */
-(void)setHostID:(NSString *)hostID{
    if(self.hostID){
        self.lh_removeNotification(self.hostID);
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshadow-ivar"
    self->hostID = hostID;
#pragma clang diagnostic pop
    @weakify(self);
    if(self.hostID){
        self.lh_notification(self.hostID,^(id value){
            @strongify(self);
            if(self.updateBindBlock){
                [self updateSelf];
                self.updateBindBlock(self);
            }
        });
    }
    
}

/**
 动态读取属性 并赋值  无需子类实现

 @return self
 */
-(LHBaseCoreModel*)updateSelf{
    __block id result = [[self class] getModel:self.hostID];//可以用缓存
    if(!result && [self isSaveDataBase]){
        [[self class] findAction:self.hostID selectResultBlock:^(id selectResult) {
            result = selectResult;
        }];
    }
    if(result){
        [self.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
            if(![@"updateBindBlock" isEqualToString:property.name]){
                id value =[result valueForKeyPath:property.name];
                [self setValue:value forKey:property.name];
            }
        }];
        
    }

    return self;
}

/**
 保存自己到数据库

 @return self
 */
-(LHBaseCoreModel*)saveSelf{
    if([self isSaveDataBase]){
        [[self class] saveAction:self resBlock:^(BOOL res) {
            if(res)[[self class] setModel:self];//数据库保存的数据临时缓存
        }];
    }else{
        [[self class] setModel:self];//数据库保存的数据临时缓存
    }
    return self;
}

/**
 删除自己从数据库

 @return self
 */
-(LHBaseCoreModel*)deleteSelf{
    if(self.hostID.length && [self isSaveDataBase]){
        [[self class] deletehostID:self.hostID resBlock:nil];
    }
    return self;
}

/**
 刷新关联model的view
 */
-(void)updateBindView{
    if(self.hostID.length){
        if(self.updateBindBlock){
            self.updateBindBlock(self);
        }
        self.lh_removeNotification(self.hostID);
        self.lh_postNotification(self.hostID,self);
        self.lh_notification(self.hostID,^(id value){
            if(self.updateBindBlock){
                [self updateSelf];
                self.updateBindBlock(self);
            }
        });
    }
    
}

/**
 动态读取属性 并赋值  无需子类实现
 
 @return self
 */
- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    [self.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        if(!property || [self isNoCopyProperty:property.name] || [property.type.code isEqualToString:@"@?"]){
            return ;
        }
        id value =[self valueForKeyPath:property.name];
        if(value){
            @try{
                value = [value copy];
            }@catch(NSException* e) {
                NSLog(@"copy_error:%@",value);
            }
            [one setValue:value forKey:property.name];
        }
    }];
    return one;
}


/**
 无需copy的属性

 @param name 属性
 @return 无需copy的属性返回YES  否则返回NO
 */
-(BOOL)isNoCopyProperty:(NSString*)name{
    NSDictionary*dict = @{@"updateBindBlock":@"1"};
    return [dict intValue:name];
}


/**
 是否保存数据库

 @return 保存数据库 YES  否则返回NO
 */
-(BOOL)isSaveDataBase{
    return YES;
}

/**
 通过dict生成model

 @param  dict 字典
 @return model
 */
- (id)updateByDict:(NSDictionary *)dict{
    return self;
}

/**
  外部调用生成model方法

  @param dict 字典
  @return model
  */
+ (instancetype)getLHBaseCoreModel:(NSDictionary*)dict{
    return [[[self alloc]init]updateByDict:dict];
}
@end
