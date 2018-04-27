//
//  DataViewController.h
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGAOPNSObject1 : NSObject
@property(nonatomic,strong)NSString*obj1Str;
@end

@interface YGAOPNSObject2 : NSObject
@end

@interface YGAOPNSObject3 : NSObject
@end


@protocol YGAOPManagerViewControllerDelegate
@property(nonatomic,strong)NSString*obj1Str;
@optional
-(void)Object1;
-(void)Object2;
-(void)Object3;
-(void)Object3:(NSInteger)value;
-(void)Object3:(NSInteger)value str:(NSString*)str;
@end

@interface YGAOPManagerViewController : UIViewController

@end

