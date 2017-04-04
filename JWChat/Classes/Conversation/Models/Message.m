//
//  Message.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "Message.h"
#import "TimeFormateTool.h"

@implementation Message

-(id)initWithConversationID:(NSString *)aConversationId from:(NSString *)aFrom to:(NSString *)aTo body:(MessageBody *)aBody ext:(NSDictionary *)aExt{

    if (self = [super init]) {
        
        self.conversationId = aConversationId;
        self.from = aFrom;
        self.to = aTo;
        self.body = aBody;
    }
    
    return  self;
}

// 格式化时间
-(NSString *)timeStr{
    // 时间字符串转时间对象
    NSDate * msgCreatTime = [NSDate dateWithString:_timeStr formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString * formatTime = [TimeFormateTool displayTimeStringWithDate:msgCreatTime];
    
    return formatTime;
}

@end
