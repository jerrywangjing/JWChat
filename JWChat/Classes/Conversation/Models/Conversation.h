//
//  Conversation.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/19.
//  Copyright © 2016年 jerry. All rights reserved.
//WJ: 框架接口

#import <Foundation/Foundation.h>

typedef enum {

    ErrorTypeXX,
    ErrorTypeXXX,
    
}ErrorType;

@interface Conversation : NSObject

/// 会话唯一表示id
@property (nonatomic,copy) NSString * conversationId;

/*!
 *   会话未读消息数量
 */
@property (nonatomic, assign) int unreadMessagesCount;

/*!
 *  会话扩展属性
 */
@property (nonatomic, copy) NSDictionary *ext;

/*!
 *  会话最新一条消息
 */
@property (nonatomic, strong) Message *latestMessage;
@property (nonatomic,copy) NSString * avatarImgPath;

/// 会话模型构造方法
- (instancetype)initWithLatestMessage:(Message *)latestMessage;


@end
