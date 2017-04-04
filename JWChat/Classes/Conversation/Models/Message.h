//
//  Message.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//WJ: 框架接口

#import <Foundation/Foundation.h>


/*!
 *  消息发送状态
 */
typedef enum{
    MessageStatusPending  = 0,    /*! \~chinese 发送未开始 \~english Pending */
    MessageStatusDelivering,      /*! \~chinese 正在发送 \~english Delivering */
    MessageStatusSuccessed,       /*! \~chinese 发送成功 \~english Successed */
    MessageStatusFailed,          /*! \~chinese 发送失败 \~english Failed */
}MessageStatus;

/*!
 *  消息方向
 */
typedef enum{
    MessageDirectionSend = 0,    /*! \~chinese 发送的消息 \~english Send */
    MessageDirectionReceive,     /*! \~chinese 接收的消息 \~english Receive */
}MessageDirection;

@class MessageBody;

@interface Message : NSObject

///消息的唯一标识符

@property (nonatomic, assign) NSInteger messageId;

///所属会话的唯一标识符

@property (nonatomic, copy) NSString *conversationId;

///消息的方向(send/receive)

@property (nonatomic) MessageDirection direction;

///发送方

@property (nonatomic, copy) NSString *from;

///接收方

@property (nonatomic, copy) NSString *to;

///时间戳，服务器收到此消息的时间
@property (nonatomic,copy) NSString * timestamp;

///格式化后的时间
@property (nonatomic,copy) NSString * timeStr;

///是否已读

@property (nonatomic) BOOL isRead;

///消息体

@property (nonatomic, strong) MessageBody *body;

/// 是否隐藏同一时间发送的消息
@property (nonatomic,assign) BOOL isHideTime;

/// 自定义额外消息（以弃用）
//@property (nonatomic, copy) NSDictionary *ext;



// --------------------------------------------------------
/*!
 *  客户端发送/收到此消息的时间
 */
@property (nonatomic) long long localTime;


/*!
 *  消息状态
 */
@property (nonatomic) MessageStatus status;

/*!
 *  已读回执是否已发送/收到, 对于发送方表示是否已经收到已读回执，对于接收方表示是否已经发送已读回执
 */
@property (nonatomic) BOOL isReadAcked;

/*!
 *  送达回执是否已发送/收到，对于发送方表示是否已经收到送达回执，对于接收方表示是否已经发送送达回执，如果Options设置了enableDeliveryAck，SDK收到消息后会自动发送送达回执
 */
@property (nonatomic) BOOL isDeliverAcked;


/*!
 *  初始化消息实例
 *
 *  @param aConversationId  会话ID
 *  @param aFrom            发送方
 *  @param aTo              接收方
 *  @param aBody            消息体实例
 *  @param aExt             扩展信息
 *
 *  @result 消息实例
 */
- (id)initWithConversationID:(NSString *)aConversationId
                        from:(NSString *)aFrom
                          to:(NSString *)aTo
                        body:(MessageBody *)aBody
                         ext:(NSDictionary *)aExt;


@end
