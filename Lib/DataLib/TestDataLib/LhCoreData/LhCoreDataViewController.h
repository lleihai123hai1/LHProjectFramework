//
//  DataViewController.h
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
#import "Pen.h"
#import "Person.h"
@interface LhDataBaseDemoCell : DemoCell
@property(nonatomic,strong)City*city;
+(UITableViewCell*)getLhDataBaseDemoCell:(UITableView*)table  dict:(NSDictionary*)dict;
+(UITableViewCell*)getLhDataBaseDemoCell:(UITableView*)table  city:(City*)city;
@end

@interface LhCoreDataViewController : UIViewController

@end

