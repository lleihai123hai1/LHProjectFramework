#import "LHBaseCoreModel.h"
#import "NSObject+MJProperty.h"
#import "MJProperty.h"
@implementation LHBaseCoreModel

static NSObject *_sharedManager = nil;
+(instancetype)getModel:(NSString*)hostID{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [NSObject new];
    });
    return _sharedManager.lh_weakGet([NSString stringWithFormat:@"%@_%@",[self class],hostID]);;
}
+(void)setModel:(LHBaseCoreModel*)model{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [NSObject new];
    });
    _sharedManager.lh_weakSet([NSString stringWithFormat:@"%@_%@",[model class],model.hostID],model);;
}

- (instancetype)init{
    self = [super init];
    @weakify(self);
    self.lh_kvo(@"hostID",^(id value){
        @strongify(self);
        if(self.hostID){
            self.lh_notification(self.hostID,^(id value){
                if(self.updateBindBlock){
                    [self updateSelf];
                    self.updateBindBlock(self);
                }
            });
        }
        
    });
    return self;
}

-(LHBaseCoreModel*)updateSelf{
    __block id result = [[self class] getModel:self.hostID];//可以用缓存
    if(!result){
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
-(LHBaseCoreModel*)saveSelf{
    [[self class] saveAction:self resBlock:^(BOOL res) {
        if(res)[[self class] setModel:self];
    }];
    return self;
}
-(LHBaseCoreModel*)deleteSelf{
    if(self.hostID.length){
        [[self class] deletehostID:self.hostID resBlock:nil];
    }
    return self;
}
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

//动态读取属性 并赋值  无需子类实现  遗留解决
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

-(BOOL)isNoCopyProperty:(NSString*)name{
    NSDictionary*dict = @{@"updateBindBlock":@"1"};
    return [dict intValue:name];
}
- (id)updateByDict:(NSDictionary *)dict{
    return self;
}
+ (instancetype)getLHBaseCoreModel:(NSDictionary*)dict{
    return [[[self alloc]init]updateByDict:dict];
}
@end
