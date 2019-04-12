//
//  LhDefine.h
//  LhProjectFramework
//
//  Created by lh on 2017/2/28.
//  Copyright © 2017年 LH. All rights reserved.
//

#ifndef LhDefine_h
#define LhDefine_h
#define RGB(x) [UIColor colorWithRed:((x & 0xff0000) >> 16)/255.0 green:((x & 0x00ff00) >> 8)/255.0 blue:(x & 0x0000ff)/255.0 alpha:1.0]

#ifdef DEBUG
#define NSLog(format, ...) NSLog((@"%s [Line %d] " format), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(FORMAT, ...) nil
#endif

// 获取时间间隔
#define YGHttpBegin                        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define YGHttpEnd                          NSLog(@"HY: Function Run Time: %f", CFAbsoluteTimeGetCurrent() - start);

#endif /* LhDefine_h */
