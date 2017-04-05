//
//  WJMessageHelper.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/18.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileSelectModel;
@class Message;

@interface WJMessageHelper : NSObject

#pragma mark - 发送消息
/// 发送文本消息
+ (Message *)sendTextMessage:(NSString *)text
                            to:(NSString *)toUser
                    messageExt:(NSDictionary *)messageExt;
/// 发送数据图片消息
+(Message *)sendImageMessageWithImageData:(NSData *)imageData localPath:(NSString *)path to:(NSString *)toUser messageExt:(NSDictionary *)messageExt;
/// 发送对象图片消息
+ (Message *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)toUser
                    messageExt:(NSDictionary *)messageExt;
/// 发送语言消息
+ (Message *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(int)duration
                                          to:(NSString *)toUser
                    messageExt:(NSDictionary *)messageExt;

/// 发送文件消息
+ (Message *)sendFileMessageWithFileModel:(FileSelectModel *)model
                                      to:(NSString *)toUser
                    messageExt:(NSDictionary *)messageExt;

/// 接收文本消息
+ (Message *)receivedTextMessage:(NSString *)text from:(NSString *)from;
+ (Message *)receivedTextMessage:(NSString *)text withUrl:(NSString *)url from:(NSString *)from;

#pragma mark - 接收消息

/// 接收图片消息
+ (Message *)receivedImageMessageWithData:(NSData *)imageData localPath:(NSString *)localPath from:(NSString *)from;
/// 接收语言消息
+ (Message *)receivedVoiceMessageWithData:(NSData *)voiceData localPath:(NSString *)
localPath duration:(int)duration from:(NSString *)from;

@end
