//
//  City.h
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "LHBaseCoreModel.h"

@interface LHAddress : NSObject

@property (nonatomic,copy) NSString *code;


@end

@interface CityTest : LHBaseCoreModel

@property (nonatomic,copy) NSString *cityName;

@property (nonatomic,copy) NSString *spell;
@property (nonatomic,strong) LHAddress*adress;

@end
