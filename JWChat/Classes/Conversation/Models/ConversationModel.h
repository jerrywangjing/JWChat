//
//  ConversationModel.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/19.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Conversation,ContactsModel;

@interface ConversationModel : NSObject

@property (nonatomic,assign) NSInteger uid; // 作为消息的唯一标记
@property (nonatomic,strong) Conversation *conversation; // 会话
@property (nonatomic,strong) ContactsModel * contact; // 联系人模型
@property (nonatomic,strong) NIMUser * user;
@property (nonatomic,copy) NSString * conversationId; // 会话名称（即好友id）

- (instancetype)initWithConversation:(Conversation *)conversation;

@end
