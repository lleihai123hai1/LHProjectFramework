//
//  YGMultiOriginBaseModel.h
//  LhProjectFramework
//
//  Created by 雷海 on 2018/10/18.
//  Copyright © 2018年 LH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//多代理拆分对象存储
@interface YGMultiOriginBaseModel : NSObject
@property(nonatomic,weak) id ygOriginObject;
@end

NS_ASSUME_NONNULL_END
