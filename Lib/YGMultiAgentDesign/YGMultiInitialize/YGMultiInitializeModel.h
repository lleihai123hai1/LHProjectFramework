//
//  YGMultiInitializeModel.h
//  LhProjectFramework
//
//  Created by 雷海 on 2018/10/19.
//  Copyright © 2018年 LH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGMultiOriginBaseModel.h"
#import "YGMultiBusinessLogicBaseModel.h"

typedef  YGMultiOriginBaseModel* (^YGMultiInitializeModelBlock)(YGMultiOriginBaseModel*baseModel,YGMultiBusinessLogicBaseModel*logicModel);
NS_ASSUME_NONNULL_BEGIN
//多代理初始化
@interface YGMultiInitializeModel : NSObject
@property(nonatomic,strong)YGMultiInitializeModelBlock intitBlock;
@end
#define YGMultiInitializeModelBindBlock(block) [YGMultiInitializeModel return:^NSObject *(YGMultiInitializeModel* value) {\
value.intitBlock = block;\
return value;\
}]
NS_ASSUME_NONNULL_END
