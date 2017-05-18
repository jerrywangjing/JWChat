//
//  WJMessageHelper.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/18.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "WJMessageHelper.h"


@implementation WJMessageHelper

#pragma mark - send message 

+(Message *)sendTextMessage:(NSString *)text to:(NSString *)toUser messageExt:(NSDictionary *)messageExt{
    
    //1. 包装为文本消息体
    TextMessageBody * body = [[TextMessageBody alloc] initWithText:text];
    // 2.包装为消息对象并返回
    Message * msg = [[Message alloc] initWithConversationID:toUser from:CurrentUserId to:toUser body:body ext:messageExt];

    return msg;
}

+(Message *)sendImageMessageWithImage:(UIImage *)image to:(NSString *)toUser messageExt:(NSDictionary *)messageExt{

    NSData * data = UIImageJPEGRepresentation(image, 1);
    return [self sendImageMessageWithImageData:data localPath:nil to:toUser messageExt:nil];
    
}

+(Message *)sendImageMessageWithImageData:(NSData *)imageData localPath:(NSString *)path to:(NSString *)toUser messageExt:(NSDictionary *)messageExt{

    ImageMessageBody * body = [[ImageMessageBody alloc] initWithData:imageData localPath:path];
    Message * msg = [[Message alloc] initWithConversationID:toUser from:CurrentUserId to:toUser body:body ext:messageExt];
    
    return msg;
}

+(Message *)sendVoiceMessageWithLocalPath:(NSString *)localPath duration:(int)duration to:(NSString *)toUser messageExt:(NSDictionary *)messageExt{

    VoiceMessageBody * body = [[VoiceMessageBody alloc] initWithLocalPath:localPath duration:duration];

    Message * msg = [[Message alloc] initWithConversationID:toUser from:CurrentUserId to:toUser body:body ext:messageExt];
    
    return  msg;
}

+(Message *)sendFileMessageWithFileModel:(FileSelectModel *)model to:(NSString *)toUser messageExt:(NSDictionary *)messageExt{

    FileMessageBody * body = [[FileMessageBody alloc] initWithfileModel:model];
    Message * msg = [[Message alloc] initWithConversationID:toUser from:CurrentUserId to:toUser body:body ext:messageExt];
    return msg;
}

+ (Message *)sendLocationMessageWithAddress:(NSString *)address road:(NSString *)road screenshot:(UIImage *)screenshot coordinate:(AMapGeoPoint *)coordinate to:(NSString *)toUser{

    return nil;
}

#pragma mark - received message

+(Message *)receivedTextMessage:(NSString *)text from:(NSString *)from{

    return [self receivedTextMessage:text withUrl:nil from:from];
    
}

+(Message *)receivedTextMessage:(NSString *)text withUrl:(NSString *)url from:(NSString *)from{

    TextMessageBody * body = [[TextMessageBody alloc] initWithText:text];
    body.textUrl = url;
    Message * msg = [[Message alloc] initWithConversationID:from from:from to:CurrentUserId body:body ext:nil];
    
    return msg;
}

+ (Message *)receivedImageMessageWithData:(NSData *)imageData localPath:(NSString *)localPath from:(NSString *)from{

    ImageMessageBody * body = [[ImageMessageBody alloc] initWithData:imageData localPath:localPath];
    Message * msg = [[Message alloc] initWithConversationID:from from:from to:CurrentUserId body:body ext:nil];
    return msg;
}

+(Message *)receivedVoiceMessageWithData:(NSData *)voiceData localPath:(NSString *)
    localPath duration:(int)duration from:(NSString *)from{

    // 需要给voice 包装全路径
    NSString * fullPath = [NSHomeDirectory() stringByAppendingString:localPath];
    
    VoiceMessageBody * body = [[VoiceMessageBody alloc] initWithLocalPath:fullPath duration:duration];
    Message * msg = [[Message alloc] initWithConversationID:from from:from to:CurrentUserId body:body ext:nil];
    return msg;
}



@end

