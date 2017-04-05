//
//  ConversationListModel.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/31.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ConversationListModel.h"
#import "Message.h"
#import "TextMessageBody.h"
#import "ImageMessageBody.h"
#import "VoiceMessageBody.h"
#import "FileMessageBody.h"

@implementation ConversationListModel

+(instancetype)modelWithMessage:(Message *)message{

    return [[self alloc] initWithMessage:message];
}

-(instancetype)initWithMessage:(Message *)message{

    if (self = [super init]) {
        _conversationId = message.conversationId;
        _lastMsgTime = message.timeStr;
        switch (message.body.type) {
            case MessageBodyTypeText:{
            
                TextMessageBody * textBody = (TextMessageBody *)message.body;
                _lastMsgContent = textBody.text;
            }
                break;
            case MessageBodyTypeImage:{
                
                _lastMsgContent = @"[图片]";
            }
                break;
            case MessageBodyTypeVoice:{
                
                
                _lastMsgContent = @"[语音]";
            }
                break;
            case MessageBodyTypeFile:{
                
                _lastMsgContent = @"[文件]";
            }
                break;
                
            default:
                break;
        }
    }
    
    return self;
}
@end
