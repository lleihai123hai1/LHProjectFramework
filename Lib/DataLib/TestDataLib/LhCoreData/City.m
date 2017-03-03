//
//  City.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "City.h"

@implementation City
- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [super copyWithZone:zone];
    one.cityName = self.cityName;
    one.spell = self.spell;
    return one;
}
-(LHBaseCoreModel*)updateSelf{
    [[self class] findAction:self.hostID selectResultBlock:^(City* selectResult) {
        if(selectResult){
            self.cityName = selectResult.cityName;
            self.spell = selectResult.spell;
        }
    }];
    return [super updateSelf];
}
@end
