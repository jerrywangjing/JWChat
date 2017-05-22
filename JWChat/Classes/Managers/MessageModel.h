//
//  MessageModel.h
//  FMDB_sqlite3_test
//
//  Created by JerryWang on 16/10/29.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;
@interface MessageModel : NSObject

@property (nonatomic,assign) NSInteger uid; // 作为消息的唯一标记
@property (nonatomic,copy) NSString * friendId; //聊天消息对应的好友id
@property (nonatomic,copy) NSString * time;
@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSString * textContent;
@property (nonatomic,copy) NSString * extraContent; // 额外内容
@property (nonatomic,copy) NSString * localPath;
@property (nonatomic,assign) int duration; //语音时间（只有语音消息才有）
@property (nonatomic,assign) double latitude; // 纬度
@property (nonatomic,assign) double longitude; // 经度 
@property (nonatomic,copy) NSString * direction;
@property (nonatomic,assign) BOOL  isRead;
@property (nonatomic,assign) BOOL  isHideTime;

+(instancetype)modelWithMessage:(Message *)message;
+(Message *)messageWithMessageModel:(MessageModel *)model convesationId:(NSString *)covId;
@end
