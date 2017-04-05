//
//  ContactsManager.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/12/2.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    ContactsOptionalRequestAdd = 6, // 请求添加好友
    ContactsOptionalResponseAdd = 7, // 响应添加联系人
    ContactsOptionalDelete,    // 删除联系人
    ContactsOptionalAccepted,  // 已添加联系人
    ContactsOptionalGetUserAvatarUrl, // 获取联系人头像
    ContactsOptionalGetUserNeckName   // 获取联系人昵称
    
}ContactsOptional;


@interface ContactsManager : NSObject

// 创建发送给服务器的好友对象
+ (NSData *)creatContactOfServerWithName:(NSString *)userId catalogName:(NSString *)catalogName;
/// 初始化自己的用户信息（获取自己的用户资料）
+(void)getCurrentUserInfoWithUserId:(NSString *)currentUserId;

/// 请求对方添加
+ (void)applyAddContact:(NSString *)aUserId  message:(NSString *)aMessage completion:(void (^)(NSString *aUserId, NSError *aError))aCompletionBlock;  // message 为申请信息
/// 告知服务器已删除此人
+ (void)deleteContact:(NSString *)aUserId
           completion:(void (^)(NSString *aUserId, NSError *aError))aCompletionBlock;
/// 告知服务器已添加此人
+ (void)acceptedContactRequestFromUser:(NSString *)aUserId
                          completion:(void (^)(NSString *aUserId, NSError *aError))aCompletionBlock;
/// 获取当前用户所有好友id列表
+(NSArray *)getAllContacts;
/// 获取好友资料
+(void)getUserInfoFromServerWithUserId:(NSString *)userId completeHandler:(void(^)(NSDictionary * infoDic))completeHandler;
/// 获取好友列表
+ (void)getAllFriendsFromServer:(void (^)(NSArray * dataArr,BOOL succeed))completeHandler;
/// 搜索查询好友
+ (void)searchUserListWithKeyword:(NSString *)keyword completionHandler:(void (^)(NSArray *dataArr))completeHandler;
/// 修改头像
+ (void)changeHeadImageWithUser:(ContactsModel *)userModel imageData:(NSData *)imageData;

/// 修改好友备注名(unitID：指需要修改的用户id)
+(void)changeFriendCommentName:(NSString *)commentName andUserId:(NSString *)userId;
/// 修改我的基本资料
+(void)changeMyBaseInfoWithName:(NSString *)name orgId:(NSString *)orgId signatureStr:(NSString *)signatureStr andCurrentUser:(ContactsModel *)user;

@end
