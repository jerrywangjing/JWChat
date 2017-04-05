//
//  TimeFormateTool.h
//  ESDemo
//
//  Created by jerry on 16/9/22.
//  Copyright © 2016年 Zhang, Lawrence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeFormateTool : NSObject
/// 格式化UI显示时间
+ (NSString *)displayTimeStringWithDate:(NSDate *)msgDate;
@end
