//
//  YGMultiAdhesiveBaseModel.m
//  LhProjectFramework
//
//  Created by 雷海 on 2018/10/18.
//  Copyright © 2018年 LH. All rights reserved.
//

#import "YGMultiAdhesiveBaseModel.h"

@implementation YGMultiAdhesiveBaseModel
+(YGMultiOriginBaseModel*)createYGObject:(YGMultiOriginBaseModel*)originBaseModel initializeModel:(YGMultiInitializeModel*)initializeModel logicBaseModel:(YGMultiBusinessLogicBaseModel*)logicBaseModel{
    return initializeModel.intitBlock(originBaseModel, logicBaseModel);
}
@end
