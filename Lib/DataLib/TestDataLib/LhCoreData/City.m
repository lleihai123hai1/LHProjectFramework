//
//  City.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "City.h"

@implementation City
- (id)updateByDict:(NSDictionary *)dict{
    self.hostID = [dict strValue:@"hostID"];
    self.cityName = [dict strValue:@"cityName"];
    self.spell = [dict strValue:@"spell"];
    return self;
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
