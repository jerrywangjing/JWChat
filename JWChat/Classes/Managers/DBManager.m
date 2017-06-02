//
//  DBManager.m
//  FMDB_sqlite3_test
//
//  Created by JerryWang on 16/10/29.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"
#import "MessageModel.h"
#import "ConversationModel.h"
#import "ContactsModel.h"
#import "Message.h"

#define LIMIT_COUNT 12  // 每次加载的消息数
#define DB_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:kDatabaseName]

static DBManager *_dB = nil;

@implementation DBManager

+ (DBManager *)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _dB = [[DBManager alloc] init];
        
    });
    return _dB;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString * path = DB_PATH;
        //NSLog(@"数据库路径:%@",path);
        
        _fmdb = [FMDatabase databaseWithPath:path];
        
        if (!_fmdb.open) {
            NSLog(@"数据库创建失败-%@,error-%@",path,_fmdb.lastErrorMessage);
        }

    }
    return self;
}
#pragma mark - public 数据库操作

// 创建消息表
-(BOOL)creatTableOrUpdateMsg:(NSString *)tableName messageModel:(MessageModel *)model{
    
    if (![self isExistsTable:DBTableName(tableName)]) { // 注意：如果数据表名是纯数字需要加双引号例如："表名" 才能被sqlite 识别
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS \"%@\"(id integer PRIMARY KEY AUTOINCREMENT,time text NOT NULL,type text NOT NULL,textContent text,extraContent text,localPath text, duration integer,latitude real,longitude real,direction text NOT NULL, isRead integer,isHideTime integer);",DBTableName(tableName)];
        BOOL isSuccess = [_fmdb executeUpdate:sql];
        if (!isSuccess) {
            NSLog(@"创表失败:%@",_fmdb.lastErrorMessage);
            return NO;
        }
    }
    
    // 插入消息记录
   BOOL success = [self insertTable:tableName withModel:model];
    if (!success) {
       NSLog(@"消息插入失败:%@",_fmdb.lastErrorMessage);
        return NO;
    }
    
    return  YES;
}

// 创建会话列表

-(BOOL)creatOrUpdateConversationWith:(ConversationModel *)model{

    
    //字段：id<自动>，conversationId，userName,lastMsgTime,lastMsgContent,avatarImgPath,unreadCount
    
    // 创建会话表...
    if (![self isExistsTable:DBConversationListName]) {
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS \"%@\" (id integer PRIMARY KEY AUTOINCREMENT,conversationId text NOT NULL,lastMsgTime text,lastMsgContent text,avatarImgPath text,unreadCount integer);",DBConversationListName];
        BOOL success = [_fmdb executeUpdate:sql];
        if (!success) {
            NSLog(@"会话列表创建失败：%@",_fmdb.lastErrorMessage);
            return NO;
        }
    }
    //插入/更新会话记录
    
    Message * latestMsg = model.conversation.latestMessage;
    TextMessageBody * textBody;
    
    if (latestMsg.body.type == MessageBodyTypeText ) {
        textBody  = (TextMessageBody *)latestMsg.body;
    }
    
    if (![self isExistsRecordInTable:DBConversationListName withColumnName:@"conversationId" andColumnValue:model.conversation.conversationId]) {
        
        // 插入新记录
        NSString * sql = [NSString stringWithFormat:@"INSERT INTO \"%@\" (conversationId,lastMsgTime,lastMsgContent,avatarImgPath,unreadCount) VALUES (?,?,?,?,?);",DBConversationListName];
        BOOL success = [_fmdb executeUpdate:sql,model.conversation.conversationId,latestMsg.timestamp,textBody.text,model.user.userInfo.thumbAvatarUrl,@(model.conversation.unreadMessagesCount)];
        if (!success) {
            NSLog(@"会话记录插入失败：%@",_fmdb.lastErrorMessage);
            return NO;
        }
    }else{
        
        BOOL success = [self updateConversationWithConversationModel:model];
        if (!success) {
            NSLog(@"会话更新失败：%@",_fmdb.lastErrorMessage);
            return NO;
        }
    }
    
    return YES;
}

// 创建/更新联系人记录

-(BOOL)creatOrUpdateContactWith:(ContactsModel *)model{
    
    // 创建联系人表

    if (![self isExistsTable:DBContactsListName]) {
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS \"%@\" (id integer PRIMARY KEY AUTOINCREMENT,userId text NOT NULL,userName text ,sex  text ,avatarImageUrl text,neckName text,userComment text,noBothered text,verifyMsg text,state text,online text,version text);",DBContactsListName];
        BOOL success = [_fmdb executeUpdate:sql];
        if (!success) {
            NSLog(@"联系人列表创建失败：%@",_fmdb.lastErrorMessage);
            return NO;
        }
    }
    // 插入/更新联系人记录
    if (![self isExistsRecordInTable:DBContactsListName withColumnName:@"userId" andColumnValue:model.userId]) {

        // 插入记录
        NSString * sql = [NSString stringWithFormat:@"INSERT INTO \"%@\" (userId,userName,sex,avatarImageUrl,neckName,userComment,noBothered,verifyMsg,state,online,version) VALUES (?,?,?,?,?,?,?,?,?,?,?);",DBContactsListName];
        BOOL success = [_fmdb executeUpdate:sql,model.userId,model.userName,model.sex,model.avatarImageUrl,model.neckName,model.userComment,model.noBothered,model.verifyMsg,model.state,model.online,model.version];
        if (!success) {
            NSLog(@"联系人记录插入失败：%@",_fmdb.lastErrorMessage);
            return NO;
        }
    }else{
    
        // 更新记录

        NSString * sql = [NSString stringWithFormat:@"UPDATE \"%@\" SET userName = ?,sex = ?, avatarImageUrl = ? ,neckName = ?,userComment = ?,noBothered = ?,verifyMsg = ?, state = ?, online = ? ,version = ? WHERE userId = ?;",DBContactsListName];
        BOOL success = [_fmdb executeUpdate:sql,model.userName,model.sex, model.avatarImageUrl,model.neckName,model.userComment,model.noBothered,model.verifyMsg, model.state,model.online,model.version,model.userId];
        if (!success) {
            NSLog(@"更新联系人记录失败：%@",_fmdb.lastErrorMessage);
            return NO;
        }
    }
    return YES;
    
}

//插入消息记录
- (BOOL)insertTable:(NSString *)tableName withModel:(MessageModel *)model{
    
    NSNumber * isRead = [NSNumber numberWithInt:model.isRead ? 1:0];
    NSNumber * isHideTime = [NSNumber numberWithInt:model.isHideTime ? 1:0];
    
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO \"%@\" (time,type,textContent,extraContent,localPath,duration, latitude,longitude,direction,isRead,isHideTime) VALUES (?,?,?,?,?,?,?,?,?,?,?);",DBTableName(tableName)];
    BOOL success = [_fmdb executeUpdate:sql,model.time,model.type,model.textContent,model.extraContent, model.localPath,@(model.duration),@(model.latitude),@(model.longitude), model.direction,isRead,isHideTime];

    return success;
}


//修改指定表中消息状态为已读
- (BOOL)messageHasReadFromTable:(NSString *)tableName withMessagesId:(NSArray *)messages{
    
    BOOL success = NO;
    
    for (NSNumber * num in messages) {
        
        NSString * sql = [NSString stringWithFormat:@"UPDATE \"%@\" SET isRead = ? WHERE id = ?;",DBTableName(tableName)];
        
        success = [_fmdb executeUpdate:sql,@1,num];

    }
    return success;
}

// 查询会话表中的全部记录
-(NSMutableArray *)getAllConversationsFromDB{
    
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\";",DBConversationListName];

    //装数据模型
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:DB_PATH];
    
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:sql];
        
        while (set.next) {
            // 创建会话对象
            
            Message * latestMsg = [[Message alloc] init];
            
            latestMsg.timeStr = [set stringForColumn:@"lastMsgTime"];
            latestMsg.timestamp = [set stringForColumn:@"lastMsgTime"];
            if ([[set stringForColumn:@"lastMsgContent"] isEqualToString:@"图片"]) {
                latestMsg.body.type = MessageBodyTypeImage;
            }else if ([[set stringForColumn:@"lastMsgContent"] isEqualToString:@"语音"]){
                
                latestMsg.body.type = MessageBodyTypeVoice;
            }else if ([[set stringForColumn:@"lastMsgContent"] isEqualToString:@"文件"]){
                
                latestMsg.body.type = MessageBodyTypeFile;
            }else{ // 最近消息是文本消息
                
                latestMsg.body.type = MessageBodyTypeText;
                latestMsg.body = [[TextMessageBody alloc] initWithText:[set stringForColumn:@"lastMsgContent"]];
            }
            
            // 创建会话
            Conversation * cover = [[Conversation alloc] initWithLatestMessage:latestMsg];
            
            cover.conversationId = [set stringForColumn:@"conversationId"];
            cover.unreadMessagesCount = [set intForColumn:@"unreadCount"];
            cover.latestMessage = latestMsg;
            // 创建联系人模型
            
            NIMUser * user = [[NIMSDK sharedSDK].userManager userInfo:cover.conversationId];
            // 创建会话模型对象
            ConversationModel * model = [[ConversationModel alloc] initWithConversation:cover];
            model.user = user;
            model.uid = [set intForColumn:@"id"];
            
            [array addObject:model];
        }

    }];
    
    return array;
}

// 查询消息表中的指定记录

- (NSMutableArray *)getMessagesFromTable:(NSString *)tableName lastOffsetValues:(NSInteger)lastOffset withLastOffsetHandler:(LastOffsetBlock)handler{
    
    NSString * sql = nil;
    NSInteger count = [self getRowCountFromTable:DBTableName(tableName)];
    
    NSInteger offset = 0;
    NSInteger limitCount = 0;
    
    if ( count <= LIMIT_COUNT ) {
        sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\";",DBTableName(tableName)];
        handler(-1); // 回调上次offset
        limitCount = -1; // 此方法只执行一次
        
    }else{
        
        if (lastOffset == 0) { // 第一次获取，取最后12条
            limitCount = LIMIT_COUNT;
            offset = count - LIMIT_COUNT;
            
        }else{
        
            if ((lastOffset - LIMIT_COUNT) > 0) {
                limitCount =  LIMIT_COUNT;
                offset = lastOffset - limitCount;
                
            }else{
                limitCount = lastOffset;
                offset = -1; // -1 表示从头开始取值，即：不偏移
            }
        }
        
        sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" LIMIT %ld,%ld;",DBTableName(tableName),offset,limitCount];
        //NSLog(@"加载消息sql:%@",sql);
        handler(offset); // 回调上次offset
    }
    
    NSMutableArray *array = [NSMutableArray array];
    //NSLog(@"offset:%ld,limitCount:%ld",lastOffset,limitCount);
    if (lastOffset == -1 && limitCount == -1) { // 如果limit -1，-1 时 直接返回空数组，说明已经显示全部数据
        //NSLog(@"以显示全部消息");
        return array;
    }
    // 执行sql
    FMResultSet *set = [_fmdb executeQuery:sql];
    
    while (set.next) {
        
        // 查询的是消息列表
        MessageModel *model = [[MessageModel alloc] init];
        model.uid = [set intForColumn:@"id"];
        model.time = [set stringForColumn:@"time"];
        model.type = [set stringForColumn:@"type"];
        model.textContent = [set stringForColumn:@"textContent"];
        model.extraContent = [set stringForColumn:@"extraContent"];
        model.localPath = [set stringForColumn:@"localPath"];
        model.duration = [set intForColumn:@"duration"];
        model.latitude = [set doubleForColumn:@"latitude"];
        model.longitude = [set doubleForColumn:@"longitude"];
        model.direction = [set stringForColumn:@"direction"];
        model.isRead = [set intForColumn:@"isRead"] == 1 ? YES:NO;
        model.isHideTime = [set intForColumn:@"isHideTime"] == 1 ? YES:NO;
        
        [array addObject:model];
        
    }
    
    return array;
}


// 删除指定表中聊天记录
- (BOOL)deleteMessageFromTable:(NSString *)tableName withMessage:(Message *)message{
    
    // DELETE FORM t_conversation_01  删除表中所有记录
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM \"%@\" WHERE id = ?",DBTableName(tableName)];
    BOOL success = [_fmdb executeUpdate:sql,@(message.messageId)];
    
    return success;
}

// 删除会话表中的记录

-(BOOL)deleteConversationRecordWithConversationId:(NSString *)converId{
    
    // DELETE FORM t_conversation_01  删除表中所有记录
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM \"%@\" WHERE conversationId = ?",DBConversationListName];
    BOOL success = [_fmdb executeUpdate:sql,converId];

    return success;
}

// 删除联系人记录
- (BOOL)deleteContactsRecordWithUserId:(NSString *)userId{
    
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM \"%@\" WHERE userId = ?",DBContactsListName];
    BOOL success = [_fmdb executeUpdate:sql,userId];
    
    return success;
}
// 删除整张表
- (BOOL)deleteFullTable:(NSString *)tableName{

    NSString * sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS \"%@\"",DBTableName(tableName)];
   return [_fmdb executeUpdate:sql];
    
}

// 删除所有聊天记录

- (BOOL)deleteAllMessageRecord{

    BOOL success = YES;
    NSArray * conversations = [self getAllConversationsFromDB];
    for (ConversationModel * model in conversations) {
        NSString * covId = model.conversationId;
        if (![self deleteFullTable:covId]) {
            success = NO;
        }
    }
    return success;
}

// 更新会话记录
- (BOOL)updateConversationWithConversationModel:(ConversationModel *)model{
    
    TextMessageBody * textBody;
    Message * lastMessage = model.conversation.latestMessage;
    
    if (lastMessage.body.type == MessageBodyTypeText ) {
        textBody  = (TextMessageBody *)lastMessage.body;
    }
    
    NSString * lastMsgContent;
    switch (lastMessage.body.type) {
        case MessageBodyTypeText:
            lastMsgContent = textBody.text;
            break;
        case MessageBodyTypeImage:
            lastMsgContent = @"[图片]";
            break;
        case MessageBodyTypeFile:
            lastMsgContent = @"[文件]";
            break;
        case MessageBodyTypeVoice:
            lastMsgContent = @"[语音]";
            break;
        case MessageBodyTypeLocation:
            lastMsgContent = @"[位置]";
            break;
        default:
            break;
    }
    
    //更新记录中的最后一条消息
    NSString * sql = [NSString stringWithFormat:@"UPDATE \"%@\" SET lastMsgTime = ? , lastMsgContent = ? ,unreadCount = ? WHERE conversationId = ?;",DBConversationListName];
    BOOL success = [_fmdb executeUpdate:sql,lastMessage.timestamp,lastMsgContent,@(model.conversation.unreadMessagesCount),lastMessage.conversationId];

    if (!success) {
        NSLog(@"会话记录更新失败:%@",_fmdb.lastErrorMessage);
        return NO;
    }
    return YES;
}

-(BOOL)updateContactsInfoWithUserId:(NSString *)userId ColumuName:(NSString *)columnName value:(NSString *)value{
    
    NSString * sql = [NSString stringWithFormat:@"UPDATE \"%@\" SET %@ = ? WHERE userId = ?",DBContactsListName,columnName];
    BOOL success = [_fmdb executeUpdate:sql,value,userId];
    return success;
}

-(int)queryUnreadCountFormTable:(NSString *)tableName{
    
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE isRead = ?;",DBTableName(tableName)];
    FMResultSet * set = [_fmdb executeQuery:sql,@(0)];
    int count = 1;
    while (set.next) {
        count++;
    }
    
    return  count;
}


-(NSMutableArray *)getUsersWithState:(NSString *)state{
    
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE state = ?;",DBContactsListName];
    
    FMResultSet * set = [_fmdb executeQuery:sql,state];
    NSMutableArray * arr = [NSMutableArray array];
    while (set.next) {
        ContactsModel * model = [[ContactsModel alloc] init];
        model.userId = [set stringForColumn:@"userId"];
        model.userName = [set stringForColumn:@"userName"];
        model.avatarImageUrl = [set stringForColumn:@"avatarImageUrl"];
        model.neckName = [set stringForColumn:@"neckName"];
        model.userComment = [set stringForColumn:@"userComment"];
        model.noBothered = [set stringForColumn:@"noBothered"];
        model.verifyMsg = [set stringForColumn:@"verifyMsg"];
        model.state = [set stringForColumn:@"state"];
        model.online = [set stringForColumn:@"online"];
        
        [arr addObject:model];
    }
    return arr;
}

-(NSMutableArray *)getAllContactsFromDB{

    // 使用fmdb数据库串行队列来执行多线程数据库访问示例：
//    First, make your queue.
//    
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:aPath];
//    
//    Then use it like so:
//    
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
//        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
//        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];
//        
//        FMResultSet *rs = [db executeQuery:@"select * from foo"];
//        while ([rs next]) {
//            //…
//        }
//    }];

    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\";",DBContactsListName];
    NSString * dbPath = DB_PATH;
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    NSMutableArray * arr = [NSMutableArray array];
    
    // 将数据库任务添加到串行队列中执行，防止多线程访问db造成crash
    
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet * set = [db executeQuery:sql];
        
        while (set.next) {
            ContactsModel * model = [[ContactsModel alloc] init];
            model.userId = [set stringForColumn:@"userId"];
            model.version = [set stringForColumn:@"version"];
            model.userName = [set stringForColumn:@"userName"];
            model.sex = [set stringForColumn:@"sex"];
            model.avatarImageUrl = [set stringForColumn:@"avatarImageUrl"];
            model.neckName = [set stringForColumn:@"neckName"];
            model.userComment = [set stringForColumn:@"userComment"];
            model.noBothered = [set stringForColumn:@"noBothered"];
            model.verifyMsg = [set stringForColumn:@"verifyMsg"];
            model.state = [set stringForColumn:@"state"];
            model.online = [set stringForColumn:@"online"];
            // 获取当前用户
            if (![model.userId isEqualToString:CurrentUserId]) {
                [arr addObject:model];
            }
        }
    }];
    
    return arr;
}

// 查询联系人
-(ContactsModel *)getUserWithUserId:(NSString *)userId{
    
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE userId = ?;",DBContactsListName];
    FMResultSet * set = [_fmdb executeQuery:sql,userId];
    
    ContactsModel * model = [[ContactsModel alloc] init];
    while (set.next) {
        
        model.userId = [set stringForColumn:@"userId"];
        model.version = [set stringForColumn:@"version"];
        model.userName = [set stringForColumn:@"userName"];
        model.sex = [set stringForColumn:@"sex"];
        model.avatarImageUrl = [set stringForColumn:@"avatarImageUrl"];
        model.neckName = [set stringForColumn:@"neckName"];
        model.userComment = [set stringForColumn:@"userComment"];
        model.noBothered = [set stringForColumn:@"noBothered"];
        model.verifyMsg = [set stringForColumn:@"verifyMsg"];
        model.state = [set stringForColumn:@"state"];
        model.online = [set stringForColumn:@"online"];
        
    }
    return model;
}

// 判断一条记录是否存在于表中

- (BOOL)isExistsRecordInTable:(NSString *)tableName withColumnName:(NSString *)columnName andColumnValue:(NSString *)value{
    
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE %@ = ?;",tableName,columnName];
    
    //_fmdb
    //这个方法是查询
    FMResultSet *set = [_fmdb executeQuery:sql,value];
    
    //[set next] 如果你查询到了 这个方法会返回一个真值
    
    return [set next];
}

#pragma mark - pravite 私有方法

// 判断表是否已存在
-(BOOL)isExistsTable:(NSString *)tableName{
    
    FMResultSet *rs = [_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

// 获取表中的记录数
-(NSInteger)getRowCountFromTable:(NSString *)tableName{

    NSInteger count = 0;
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\";",tableName];
    FMResultSet * set = [_fmdb executeQuery:sql];
    while ([set next]) {
        count++;
    }
    
    return count;
}

@end
