//
//  Constant.h
//  JWChat
//
//  Created by JerryWang on 2017/5/28.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

// 宏定义字符串

#define HeaderTitle @"headerTitle"
#define RowContent @"rowContent"
#define FooterTitle @"footerTitle"
#define Title @"title"
#define SubTitle @"subTitle"
#define ImageUrl @"imageUrl"

#define kDatabaseName @"conversationDB.sqlite" // 数据库名
#define kConversationListName @"t_conversation_list"  // 会话表名
#define kContactsListName @"t_contacts_list" // 联系人表名
#define kMessagesListName @"t_messages_list" // 好友消息表
#define kImageRelativePath @"/Library/appdata/imagebuffer"  // 图片消息缓存路径
#define kVoiceRelativePath @"/Library/appdata/chatbuffer"   // 语音数据缓存路径
#define kLocationRelativePath @"/Library/appdata/locationbuffer" // 位置消息缓存路径
#define MsgNoticeKey @"msgNoticeState"
#define ContactsStateNoVerify @"等待验证" // 联系人状态
#define ContactsStateIsFriend @"我的好友"


#define kUserId @"validUserId" // 当前用户id
#define kIMUserId @"imUserId" //即时通讯当前登录用户
#define kCurrentUser @"当前联系人" // 当前用户资料键

// 数据库相关宏

#define CurrentUserId [[NIMSDK sharedSDK].loginManager currentAccount] // 当前登录用户id
#define DBTableName(tableName) [NSString stringWithFormat:@"%@_%@",tableName,CurrentUserId] // 消息表名
#define DBConversationListName [NSString stringWithFormat:@"%@_%@",kConversationListName,CurrentUserId] // 会话表名
#define DBContactsListName [NSString stringWithFormat:@"%@_%@",kContactsListName,CurrentUserId] // 联系人表名


#endif /* Constant_h */
