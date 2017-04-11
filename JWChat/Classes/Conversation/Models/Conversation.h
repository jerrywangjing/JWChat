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



// ------------------------------------------------------
/*!
 *  插入一条消息，消息的conversationId应该和会话的conversationId一致，消息会被插入DB，并且更新会话的latestMessage等属性
 *
 *  @param aMessage 消息实例
 *  @param pError   错误信息
 */
- (void)insertMessage:(Message *)aMessage
                error:(ErrorType)pError;

/*!
 *  插入一条消息到会话尾部，消息的conversationId应该和会话的conversationId一致，消息会被插入DB，并且更新会话的latestMessage等属性
 *
 *  @param aMessage 消息实例
 *  @param pError   错误信息
 *
 */
- (void)appendMessage:(Message *)aMessage
                error:(ErrorType)pError;

/*!
 *  删除一条消息
 *
 *  @param aMessageId   要删除消失的ID
 *  @param pError       错误信息
 *
 */
- (void)deletessageWithId:(NSString *)aMessageId
                      error:(ErrorType)pError;

/*!
 *  删除该会话所有消息
 *  @param pError       错误信息
 */
- (void)deleteAllMessages:(ErrorType)pError;

/*!
 *  更新一条消息，不能更新消息ID，消息更新后，会话的latestMessage等属性进行相应更新
 *
 *  @param aMessage 要更新的消息
 *  @param pError   错误信息
 *
 */
- (void)updatessageChange:(Message *)aMessage
                      error:(ErrorType)pError;

/*!
 *  将消息设置为已读
 *
 *  @param aMessageId   要设置消息的ID
 *  @param pError       错误信息
 *
 */
- (void)markMessageAsReadWithId:(NSString *)aMessageId
                          error:(ErrorType)pError;

/*!
 *  将所有未读消息设置为已读
 *
 *  @param pError   错误信息
 *
 */
- (void)markAllMessagesAsRead:(ErrorType)pError;

/*!
 *  获取指定ID的消息
 *
 *  @param aMessageId       消息ID
 *  @param pError           错误信息
 *
 */
- (Message *)loadMessageWithId:(NSString *)aMessageId
                           error:(ErrorType)pError;

/*!
 *  收到的对方发送的最后一条消息
 *
 *  @result 消息实例
 */
- (Message *)lastReceivedMessage;

@end
