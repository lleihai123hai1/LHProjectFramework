//
//  XRDragTableView.h
//  XRDragTableViewDemo
//
//  Created by 肖睿 on 16/4/9.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRDragTableView : LHUITableView
/**
 *  tableView的数据源，必须跟外界的数据源一致
 *  不能是外界数据源copy出来的，也必须是可变的
 *
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  当cell拖拽到tableView边缘时,tableView的滚动速度
 *  每个时间单位滚动多少距离，默认为3
 */
@property (nonatomic, assign) CGFloat scrollSpeed;


@end
