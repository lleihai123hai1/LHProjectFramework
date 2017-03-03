//
//  Person.h
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "LHBaseCoreModel.h"
#import "City.h"
#import "Pen.h"
#import <UIKit/UIKit.h>

@interface Person : LHBaseCoreModel


@property (nonatomic,assign) NSUInteger nsu;
@property (nonatomic,assign) NSInteger nsi;
@property (nonatomic,assign) CGFloat cgf;
@property (nonatomic,assign) unsigned long UNLong;
@property (nonatomic,assign) long LOng;
@property (nonatomic,assign) double Double;
@property (nonatomic,assign) float Float;
@property (nonatomic,assign) int Int;
@property (nonatomic,assign) unsigned int UNInt;
@property (nonatomic,assign) short Short;
@property (nonatomic,assign) unsigned short UNShort;
@property (nonatomic,assign) unsigned char  UNichar;
@property (nonatomic,assign) char Char;

@property (nonatomic,strong) NSData *photoData;
@property (nonatomic,strong) NSDate*date;
@property (nonatomic,strong) City*city;
@property (nonatomic,strong) NSString*name;
@property (nonatomic,strong) NSDictionary*dict;
@property (nonatomic,strong) NSArray*array;
@property (nonatomic,strong) Pen*pen;

@end
