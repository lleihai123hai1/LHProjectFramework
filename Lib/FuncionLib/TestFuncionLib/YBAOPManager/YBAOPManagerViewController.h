//
//  DataViewController.h
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBAOPNSObject1 : NSObject
@property(nonatomic,strong)NSString*obj1Str;
@end

@interface YBAOPNSObject2 : NSObject
@end

@interface YBAOPNSObject3 : NSObject
@end


@protocol YBAOPManagerViewControllerDelegate
@property(nonatomic,strong)NSString*obj1Str;
@optional
-(void)Object1;
-(void)Object2;
-(void)Object3;
-(void)Object3:(NSInteger)value;
-(void)Object3:(NSInteger)value str:(NSString*)str;
@end

@interface YBAOPManagerViewController : UIViewController

@end

