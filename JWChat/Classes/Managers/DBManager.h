//
//  DBManager.h
//  FMDB_sqlite3_test
//
//  Created by JerryWang on 16/10/29.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@class MessageModel,ConversationModel,ContactsModel,Message;

typedef void(^LastOffsetBlock) (NSInteger lastOffset);
@interface DBManager : NSObject

@property (nonatomic,strong) FMDatabase * fmdb;
+ (DBManager *)shareManager;

/// 创建/更新消息记录
-(BOOL)creatTableOrUpdateMsg:(NSString *)tableName messageModel:(MessageModel *)model;
/// 创建/更新会话记录
-(BOOL)creatOrUpdateConversationWith:(ConversationModel *)model;
/// 创建/更新联系人记录
-(BOOL)creatOrUpdateContactWith:(ContactsModel *)model;
/// 更改一条消息的已读状态
- (BOOL)messageHasReadFromTable:(NSString *)tableName withMessagesId:(NSArray *)messages;
/// 查询会话消息中的未读消息数
- (int)queryUnreadCountFormTable:(NSString *)tableName;
/// 更新会话记录
-(BOOL)updateConversationWithConversationModel:(ConversationModel *)model;
/// 查询消息表中的指定记录
- (NSMutableArray *)getMessagesFromTable:(NSString *)tableName lastOffsetValues:(NSInteger)lastOffset withLastOffsetHandler:(LastOffsetBlock)handler;
/// 查询会话表中的所有记录
-(NSMutableArray *)getAllConversationsFromDB;
/// 查询指定联系人
-(ContactsModel *)getUserWithUserId:(NSString *)userId;
/// 查询所有联系人表中的添加状态
-(NSMutableArray *)getUsersWithState:(NSString *)state;
/// 查询所有联系人
-(NSMutableArray *)getAllContactsFromDB;
/// 更改联系人字段信息
-(BOOL)updateContactsInfoWithUserId:(NSString *)userId ColumuName:(NSString *)columnName value:(NSString *)value;
/// 查询表中指定记录是否存在
- (BOOL)isExistsRecordInTable:(NSString *)tableName withColumnName:(NSString *)columnName andColumnValue:(NSString *)value;
/// 删除消息记录
- (BOOL)deleteMessageFromTable:(NSString *)tableName withMessage:(Message *)message;
/// 删除联系人记录
- (BOOL)deleteContactsRecordWithUserId:(NSString *)userId;
/// 删除会话记录
-(BOOL)deleteConversationRecordWithConversationId:(NSString *)converId;
/// 删除一张表
- (BOOL)deleteFullTable:(NSString *)tableName;

@end
