//
//  TimeFormateTool.m
//  ESDemo
//
//  Created by jerry on 16/9/22.
//  Copyright © 2016年 Zhang, Lawrence. All rights reserved.
//

#import "TimeFormateTool.h"
#import <UIKit/UIKit.h>

@implementation TimeFormateTool

+ (NSString *)displayTimeStringWithDate:(NSDate *)msgDate{

    NSDateFormatter * dateFmt = [[NSDateFormatter alloc] init];
    
    if ([msgDate isToday]) {
        dateFmt.dateFormat = @"HH:mm";
    }else if ([msgDate isYesterday]){
    
        dateFmt.dateFormat = @"昨天 HH:mm";
    }else if (msgDate.daysAgo < 6){

        dateFmt.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",[NSDate weekTimeAgoSinceDate:msgDate]];

    }else{
    
        if (msgDate.year == [NSDate date].year) { // 今年
            dateFmt.dateFormat = @"MM-dd HH:mm";
        }else{

            dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
        }
    }
    
    return  [dateFmt stringFromDate:msgDate];
}

// 原生方法（已弃用）
- (NSString *)oldMethod:(NSDate * )msgDate{

    // ------------------------------------------
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    
    // 获取当前时间的年、月、日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    
    // 获取消息发送时间的年、月、日
    //NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
    CGFloat msgYear = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
    
    // 判断
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
        //今天
        dateFmt.dateFormat = @"HH:mm";
    }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay ){
        //昨天
        dateFmt.dateFormat = @"昨天 HH:mm";
    }else{
        //昨天以前
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    
    return [dateFmt stringFromDate:msgDate];
}
@end
