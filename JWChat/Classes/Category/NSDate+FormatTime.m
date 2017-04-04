//
//  NSDate+FormatTime.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/11/7.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "NSDate+FormatTime.h"

#define  DefaultDateStyle @"yyyy-MM-dd HH:mm:ss"
@implementation NSDate (FormatTime)

//时间格式化
+ (NSString *)currentFormattedDate{
    
    // 使用NSDate Tools 对时间进行格式化

    NSString * timeStr = [[NSDate date] formattedDateWithFormat:DefaultDateStyle];
    return  timeStr;
}

- (NSString *)defaultFormattedDate{

    NSString * timeStr = [self formattedDateWithFormat:DefaultDateStyle];
    return  timeStr;
}

- (NSString *)getUTCTimeString{

    NSString * timeStr = [self formattedDateWithFormat:DefaultDateStyle timeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return timeStr;
}
@end
