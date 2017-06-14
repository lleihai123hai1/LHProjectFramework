//
//  DataViewController.h
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface KVCEmployee : NSObject
@property(nonatomic,strong)NSString* name;
@property(nonatomic,assign)CGFloat salary;
@property(nonatomic,assign)NSInteger order;
@property(nonatomic,assign)NSInteger daysOff;
@end
@implementation KVCEmployee
@end



@interface Product : NSObject
@property NSString *name;
@property double price;
@property NSDate *launchedOn;
@end
@implementation Product
@end

@interface ValueForKeyPathViewController : UIViewController

@end

