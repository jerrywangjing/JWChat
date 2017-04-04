//
//  ConversationModel.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/19.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ConversationModel.h"
#import "Conversation.h"

@implementation ConversationModel

-(instancetype)initWithConversation:(Conversation *)conversation{

    if (self = [super init]) {
        _conversation = conversation;
        _conversationId = conversation.conversationId;
    }
    return  self;
}
@end
