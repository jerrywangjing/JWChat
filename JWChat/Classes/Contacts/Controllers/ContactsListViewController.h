//
//  SearchContactsController.h
//  contactsAndSearchBar
//
//  Created by jerry on 16/6/28.
//  Copyright © 2016年 jerry. All rights reserved.

// **注意：导入ESFramework 框架的时候需要配置：BuildSetting -> Other Flags 添加代码 “-ObjC”
// >联系人列表

#import <UIKit/UIKit.h>

typedef void(^deleteUserCallback)(NIMUser *);

@interface ContactsListViewController : UIViewController

@property (nonatomic,copy)deleteUserCallback deleteUser ; // 回调会话列表删除会话记录
///用户上线回调
-(void)addUserForOnline:(NSString *)userID;
///用户下线回调
-(void)removeUserForOffline:(NSString *)userID;
/// 有新的添加请求
-(void)receivedNewApply;
/// 被好友删除的通知
-(void)receivedDeletedFromUser:(NSString *)userId;
/// 被好友添加的通知
-(void)receivedAddedFromUser:(NSString *)userId;
@end
