#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface YGAOPManager : NSObject

- (void)addTarget:(id)target;
- (void)removeTarget:(id)target;

@property (nonatomic, strong, readonly) NSPointerArray *targets;

@end

NS_ASSUME_NONNULL_END
