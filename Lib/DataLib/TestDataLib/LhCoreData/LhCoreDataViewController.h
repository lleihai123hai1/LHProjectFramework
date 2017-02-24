//
//  DataViewController.h
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCoreModel.h"
@interface BaseCoreModel1 : BaseCoreModel
@property (nonatomic, retain) NSString * objDesc;
@property (nonatomic, retain) NSString * downloadLink;
@property (nonatomic, assign) NSInteger isMySession;
@property (nonatomic, assign) BOOL isDownloaded;
@property (nonatomic, assign) CGFloat percentage;
@property (nonatomic, retain) NSMutableArray *poseArray;
@end

@interface LhCoreDataViewController : UIViewController

@end

