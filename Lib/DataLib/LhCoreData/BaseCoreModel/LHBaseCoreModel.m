#import "LHBaseCoreModel.h"
#import "NSObject+MJProperty.h"
#import "MJProperty.h"
@implementation LHBaseCoreModel
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
    return self;
}
-(LHBaseCoreModel*)saveSelf{
    [[self class] saveAction:self resBlock:nil];
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
