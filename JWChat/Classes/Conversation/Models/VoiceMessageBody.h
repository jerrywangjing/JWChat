//
//  VoiceMessageBody.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//WJ: 框架接口

#import "FileMessageBody.h"

@interface VoiceMessageBody : FileMessageBody

/*!
 *  语音时长, 秒为单位
 */
@property (nonatomic,assign) int duration;
@property (nonatomic,copy) NSString * voiceLocalPath;


-(instancetype)initWithLocalPath:(NSString *)localPath duration:(int)duration;

@end
