#import "BaseCoreModel.h"
typedef  void (^LHBaseCoreModelUpdateViewBlock)(id value);
@interface LHBaseCoreModel : BaseCoreModel
@property(nonatomic,strong)LHBaseCoreModelUpdateViewBlock updateBindBlock;
- (id)copyWithZone:(NSZone *)zone;
- (id)updateByDict:(NSDictionary *)dict;
-(LHBaseCoreModel*)updateSelf;
-(LHBaseCoreModel*)saveSelf;
-(LHBaseCoreModel*)deleteSelf;
-(BOOL)isNoCopyProperty:(NSString*)name;
-(void)updateBindView;
+ (LHBaseCoreModel *)getLHBaseCoreModel:(NSDictionary*)dict;
@end
