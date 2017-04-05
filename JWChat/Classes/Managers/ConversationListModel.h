//
//  ConversationListModel.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/31.
//  Copyright © 2016年 jerry. All rights reserved.
//***已弃用

#import <Foundation/Foundation.h>
@class Message;

@interface ConversationListModel : NSObject

@property (nonatomic,assign) NSInteger  uid;
@property (nonatomic,copy) NSString * conversationId; // 即用户名
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * lastMsgTime;
@property (nonatomic,copy) NSString * lastMsgContent;
@property (nonatomic,copy) NSString * avatarImgPath;
@property (nonatomic,assign) NSInteger  unreadCount;
///消息模型构造方法
+(instancetype)modelWithMessage:(Message *)message;
@end
