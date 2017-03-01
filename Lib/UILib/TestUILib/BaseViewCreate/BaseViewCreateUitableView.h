//
//  DataViewController.h
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LhDemoCell : DemoCell
+(UITableViewCell*)getLhDemoCell:(UITableView*)table  dict:(NSDictionary*)dict;
@end

@interface BaseViewCreateUitableView : UIViewController

@end

