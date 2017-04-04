//
//  Conversation.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/19.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "Conversation.h"

@implementation Conversation

-(instancetype)initWithLatestMessage:(Message *)latestMessage{

    if (self = [super init]) {
        _latestMessage = latestMessage;
        _conversationId = latestMessage.conversationId;
    }
    
    return self;
}
@end
