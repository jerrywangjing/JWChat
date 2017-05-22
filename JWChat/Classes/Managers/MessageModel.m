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
static NSString * const kSend = @"send";
static NSString * const kReceived = @"received";

@implementation MessageModel

+(instancetype)modelWithMessage:(Message *)message{

    return [[self alloc] initWithModel:message];;
}

-(instancetype)initWithModel:(Message * )model{

    if (self = [super init]) {
        _time = model.timestamp;
        _direction = model.direction == 0 ? kSend : kReceived;
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
                _textContent = locationBody.address;
                _extraContent = locationBody.roadName;
                _localPath = locationBody.screenshotPath;
                _latitude = locationBody.latitude;
                _longitude = locationBody.longitude;
                
            }
                
                break;
            default:
                break;
        }
    }
    
    return self;
}

+(Message *)messageWithMessageModel:(MessageModel *)model convesationId:(NSString *)covId{
    
    
    MessageBody * body = nil;
    
    if ([model.type isEqualToString:kTypeText]) {
        body = [[TextMessageBody alloc] initWithText:model.textContent];
        
    }else if ([model.type isEqualToString:kTypeImage]){
        
        body = [[ImageMessageBody alloc] initWithData:nil localPath:model.localPath];
        
    }else if ([model.type isEqualToString:kTypeVoice]){
        
        // 拼装语音文件全路径
        NSString * voiceFullPath = [NSHomeDirectory() stringByAppendingString:model.localPath];
        
        body = [[VoiceMessageBody alloc] initWithLocalPath:voiceFullPath duration:model.duration];
        
    }else if ([model.type isEqualToString:kTypeFile]){
        //解析文件
//        NSString * filePath = [NSHomeDirectory() stringByAppendingString:model.localPath];
//        
//        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//        dic[@"fileName"] = model.textContent;
//        dic[@"filePath"] = model.localPath;
//        //注意： 文件消息的id是存放在数据库的duration字段中
//        dic[@"fileId"] = [NSString stringWithFormat:@"%d",model.duration];
//        
//        FileSelectModel * fileModel = [FileSelectModel modelWithDic:dic];
//        body = [[FileMessageBody alloc] initWithfileModel:fileModel];

    }else if ([model.type isEqualToString:kTypeLocation]){
    
        LocationMessageBody * locationBody = [[LocationMessageBody alloc] initWithLatitude:model.latitude longitude:model.longitude bodyType:MessageBodyTypeLocation];
        locationBody.address = model.textContent;
        locationBody.roadName = model.extraContent;
        locationBody.screenshotPath = model.localPath;
        body = locationBody;
    }
    
    Message * message = [[Message alloc] initWithConversationID:covId from:nil to:nil body:body ext:nil];
    message.messageId = model.uid;
    message.direction = [model.direction isEqualToString:kSend] ? MessageDirectionSend : MessageDirectionReceive;
    message.timeStr = model.time;
    message.timestamp = model.time;
    message.isRead = model.isRead;
    message.isHideTime = model.isHideTime;
    
    return message;
}

@end
