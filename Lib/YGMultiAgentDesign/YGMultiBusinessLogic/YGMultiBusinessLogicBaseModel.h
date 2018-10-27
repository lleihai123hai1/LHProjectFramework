//
//  YGMultiBusinessLogicBaseModel.h
//  LhProjectFramework
//
//  Created by 雷海 on 2018/10/18.
//  Copyright © 2018年 LH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//多代理业务处理
typedef  void (^YGMultiBusinessLogicBaseModelBlock)(id value);
@interface YGMultiBusinessLogicBaseModel : NSObject
@property(nonatomic,strong)YGMultiBusinessLogicBaseModelBlock logicBlock;
@end
#define YGMultiBusinessLogicBaseModelBindBlock(block) [YGMultiBusinessLogicBaseModel return:^YGMultiBusinessLogicBaseModel *(YGMultiBusinessLogicBaseModel* value) {\
value.logicBlock = block;\
return value;\
}]
NS_ASSUME_NONNULL_END
