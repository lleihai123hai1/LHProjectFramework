//
//  DataViewController.h
//  LhProjectFramework
//
//  Created by lh on 2017/2/21.
//  Copyright © 2017年 LH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCollectionViewCell.h"
@interface LhCollectionCell : UICollectionViewCell
+(LhCollectionCell*)getLhCollectionCell:(UICollectionView*)collectionCell dict:(NSDictionary*)dict indexPath:(NSIndexPath *)indexPath;

@end

@interface BaseViewCreateUICollectionView : UIViewController

@end

