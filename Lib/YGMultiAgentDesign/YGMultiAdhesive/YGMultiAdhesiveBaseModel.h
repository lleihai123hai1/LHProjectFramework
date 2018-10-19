//
//  YGMultiAdhesiveBaseModel.h
//  LhProjectFramework
//
//  Created by 雷海 on 2018/10/18.
//  Copyright © 2018年 LH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGMultiOriginBaseModel.h"
#import "YGMultiInitializeModel.h"
#import "YGMultiBusinessLogicBaseModel.h"
NS_ASSUME_NONNULL_BEGIN
//多代理粘合剂
//@protocol YGMultiAdhesiveBaseModelDelegate
//@optional
//-(void)action1;
//@end

@interface YGMultiAdhesiveBaseModel : NSObject
-(id)createYGObject:(YGMultiOriginBaseModel*)originBaseModel initializeModel:(YGMultiInitializeModel*)initializeModel logicBaseModel:(YGMultiBusinessLogicBaseModel*)logicBaseModel;
@end

NS_ASSUME_NONNULL_END
