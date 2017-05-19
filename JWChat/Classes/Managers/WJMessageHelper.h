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
@class AMapGeoPoint;

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

/**
 发送文件消息

 @param model 文件模型
 @param toUser 消息接受者
 @param messageExt 扩展内容
 @return 文件消息对象
 */
+ (Message *)sendFileMessageWithFileModel:(FileSelectModel *)model
                                      to:(NSString *)toUser
                    messageExt:(NSDictionary *)messageExt;

/**
 发送位置消息

 @param address 所在位置的地理名称
 @param road 所在位置的地址
 @param screenshot 位置截图
 @param coordinate 位置坐标
 @return 位置消息对象
 */
+ (Message *)sendLocationMessageWithAddress:(NSString *)address
                                       road:(NSString *)road
                                 screenshot:(NSString  *)screenshot
                                 coordinate:(AMapGeoPoint *)coordinate
                                         to:(NSString *)toUser;

#pragma mark - 接收消息

/// 接收文本消息
+ (Message *)receivedTextMessage:(NSString *)text from:(NSString *)from;
+ (Message *)receivedTextMessage:(NSString *)text withUrl:(NSString *)url from:(NSString *)from;


/// 接收图片消息
+ (Message *)receivedImageMessageWithData:(NSData *)imageData localPath:(NSString *)localPath from:(NSString *)from;
/// 接收语言消息
+ (Message *)receivedVoiceMessageWithData:(NSData *)voiceData localPath:(NSString *)
localPath duration:(int)duration from:(NSString *)from;

@end
