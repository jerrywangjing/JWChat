//
//  MessageModel.m
//  FMDB_sqlite3_test
//
//  Created by JerryWang on 16/10/29.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import "MessageModel.h"
#import "Message.h"
#import "TextMessageBody.h"
#import "ImageMessageBody.h"
#import "VoiceMessageBody.h"
#import "FileMessageBody.h"

static NSString * const kTypeText = @"text";
static NSString * const kTypeImage = @"image";
static NSString * const kTypeVoice = @"voice";
static NSString * const kTypeLocation = @"location";
static NSString * const kTypeFile = @"file";

@implementation MessageModel

+(instancetype)modelWithMessage:(Message *)message{

    return [[self alloc] initWithModel:message];;
}

-(instancetype)initWithModel:(Message * )model{

    if (self = [super init]) {
        _time = model.timestamp;
        _direction = model.direction == 0? @"send":@"received";
        _isRead = model.isRead;
        _isHideTime = model.isHideTime;
        
        switch (model.body.type) {
            case MessageBodyTypeText:{
                
                TextMessageBody * textBody = (TextMessageBody *)model.body;
                _type = kTypeText;
                _textContent = textBody.text;
            }
                break;
            case MessageBodyTypeImage:{
                ImageMessageBody * imageBody = (ImageMessageBody *)model.body;
                _type = kTypeImage;
                _localPath = imageBody.imageLocalPath;
                
            }
                break;
            case MessageBodyTypeVoice:{
            
                VoiceMessageBody * voiceBody = (VoiceMessageBody *)model.body;
                _type = kTypeVoice;
                //注意： 存入数据库的时候需要把路径转为相对路径
                // 包装语言消息使用相对路径
                NSString * voiceRelativePath = [kVoiceRelativePath stringByAppendingPathComponent:voiceBody.voiceLocalPath.lastPathComponent];
                
                _localPath = voiceRelativePath;
                _duration = voiceBody.duration;
            }
                
                break;
            case MessageBodyTypeFile:{
            
                FileMessageBody * fileBody = (FileMessageBody *)model.body;
                _type = kTypeFile;
                _localPath = fileBody.localPath;
                _textContent = fileBody.displayName; // 存放文件名
                _duration = fileBody.fileId.intValue; // 存放fileId
            }
                break;
            case MessageBodyTypeLocation:{
            
                LocationMessageBody * locationBody = (LocationMessageBody *)model.body;
                _type = kTypeLocation;
                
                
            }
                
                break;
            default:
                break;
        }
    }
    
    return self;
}

+(Message *)messageWithMessageModel:(MessageModel *)model convesationId:(NSString *)covId{
    
    if ([model.type isEqualToString:@"text"]) {
        TextMessageBody * textBody = [[TextMessageBody alloc] initWithText:model.textContent];
        Message * message = [[Message alloc] initWithConversationID:covId from:nil to:nil body:textBody ext:nil];
        message.messageId = model.uid;
        message.direction = [model.direction isEqualToString:@"send"] ? MessageDirectionSend : MessageDirectionReceive;
        message.timeStr = model.time;
        message.timestamp = model.time;
        message.isRead = model.isRead;
        message.isHideTime = model.isHideTime;
        return message;
        
    }else if ([model.type isEqualToString:@"image"]){
        
        ImageMessageBody * imageBody = [[ImageMessageBody alloc] initWithData:nil localPath:model.localPath];
        
        Message * message = [[Message alloc] initWithConversationID:covId from:nil to:nil body:imageBody ext:nil];
        message.messageId = model.uid;
        message.direction = [model.direction isEqualToString:@"send"] ? MessageDirectionSend : MessageDirectionReceive;
        message.timeStr = model.time;
        message.timestamp = model.time;
        message.isRead = model.isRead;
        message.isHideTime = model.isHideTime;
        
        return message;
        
    }else if ([model.type isEqualToString:@"voice"]){
        
        // 拼装语音文件全路径
        NSString * voiceFullPath = [NSHomeDirectory() stringByAppendingString:model.localPath];
        
        VoiceMessageBody * voiceBody = [[VoiceMessageBody alloc] initWithLocalPath:voiceFullPath duration:model.duration];
        Message * message = [[Message alloc] initWithConversationID:covId from:nil to:nil body:voiceBody ext:nil];
        message.messageId = model.uid;
        message.direction = [model.direction isEqualToString:@"send"] ? MessageDirectionSend : MessageDirectionReceive;
        message.timeStr = model.time;
        message.timestamp = model.time;
        message.isRead = model.isRead;
        message.isHideTime = model.isHideTime;
        return message;
        
    }else if ([model.type isEqualToString:@"file"]){
        
        //解析文件
       // NSString * filePath = [NSHomeDirectory() stringByAppendingString:model.localPath];
        
//        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//        dic[@"fileName"] = model.textContent;
//        dic[@"filePath"] = model.localPath;
//        //注意： 文件消息的id是存放在数据库的duration字段中
//        dic[@"fileId"] = [NSString stringWithFormat:@"%d",model.duration];
//        
//        FileSelectModel * fileModel = [FileSelectModel modelWithDic:dic];
//        FileMessageBody * body = [[FileMessageBody alloc] initWithfileModel:fileModel];
//        
//        Message * message = [[Message alloc] initWithConversationID:covId from:nil to:nil body:body ext:nil];
//        message.messageId = model.uid;
//        message.direction = [model.direction isEqualToString:@"send"] ? MessageDirectionSend : MessageDirectionReceive;
//        message.timeStr = model.time;
//        message.timestamp = model.time;
//        message.isRead = model.isRead;
//        message.isHideTime = model.isHideTime;
        return nil;
    }
    
    return nil;
}

@end
