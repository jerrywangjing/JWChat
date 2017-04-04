//
//  NSDate+FormatTime.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/11/7.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FormatTime)
/// 当前默认格式化时间
+ (NSString *)currentFormattedDate;
/// 时间格式化
- (NSString *)defaultFormattedDate;
/// 获取UTC时间字符串
- (NSString *)getUTCTimeString;
@end
