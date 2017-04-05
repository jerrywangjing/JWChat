//
//  ContactsManager.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/12/2.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ContactsManager.h"
#import "ContactsModel.h"

@implementation ContactsManager

// 序列化联系人对象（已和pc同步）
+(NSData *)creatContactOfServerWithName:(NSString *)userId catalogName:(NSString *)catalogName{

    // 计算长度
    NSData * userNameData = [userId dataUsingEncoding:NSUTF8StringEncoding];
    NSData * catalogNameData = [catalogName dataUsingEncoding:NSUTF8StringEncoding];
    
    int userNameLength = (int)userNameData.length;
    int catalogNameLength = (int)catalogNameData.length;
    
    int totleLength = (int)(sizeof(userNameLength) + userNameData.length + sizeof(catalogNameLength) + catalogNameData.length);
    
    // 转二进制
    NSMutableData * data = [NSMutableData new];
    [data appendBytes:&totleLength length:sizeof(totleLength)];
    [data appendBytes:&catalogNameLength length:sizeof(catalogNameLength)];
    [data appendData:catalogNameData];
    [data appendBytes:&userNameLength length:sizeof(userNameLength)];
    [data appendData:userNameData];
    
    return data;
}
/*
  申请添加联系人（已和pc同步）
    注意：这里使用 message： 参数作为申请，拒绝，同意 标识
 */
+ (void)applyAddContact:(NSString *)aUserId  message:(NSString *)aMessage completion:(void (^)(NSString *aUserId, NSError *aError))aCompletionBlock{
    
    NSError * error = nil;
    //TODO： 判断此联系人是否为自己，是否已经是好友给出提示，是否此人在黑名单内
    // 发送请求添加消息到服务器
    // 第一个参数是：请求类型（请求，回复），第二个参数：是否离线（1在线0离线）第三个参数：发送请求者的用户名 *格式：6-True-10005
    NSString * tagStr = [NSString stringWithFormat:@"%d-%@-%@",ContactsOptionalRequestAdd,@"True",aUserId];
    
    // TODO：添加联系人
    
    if (aCompletionBlock) {
        aCompletionBlock(aUserId,error);
    }
}

// 对方已同意添加好友（已和pc同步）
+ (void)acceptedContactRequestFromUser:(NSString *)aUserId completion:(void (^)(NSString *aUserId, NSError *aError))aCompletionBlock{
    
    // 通知服务器添加好友 1043
    NSData * contactData = [self creatContactOfServerWithName:aUserId catalogName:@"我的好友"];
    NSError * error = nil;
    
    //TODO: 添加好友同步
    
//    if (!error) {
//        int result;
//        
//        [response getBytes:&result range:NSMakeRange(0, response.length)];
//        if (result == 0) {
//            NSLog(@"添加好友%@成功",aUserId);
//        }else{
//            
//            NSLog(@"添加好友%@失败",aUserId);
//        }
//    }else{
//        
//        NSLog(@"请求添加好友失败：%@",error);
//    }

    if (aCompletionBlock) {
        aCompletionBlock(aUserId,error);
    }
}

// 删除好友（已和pc同步）
+ (void)deleteContact:(NSString *)aUserId completion:(void (^)(NSString *aUserId, NSError *aError))aCompletionBlock{
    
    NSData * userName = [aUserId dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    
    //TODO: 删除好友
    
    if (aCompletionBlock) {
        aCompletionBlock(aUserId,error);
    };
}
// 获取当前用户资料
+ (void)getCurrentUserInfoWithUserId:(NSString *)currentUserId{

    [self getUserInfoFromServerWithUserId:currentUserId completeHandler:^(NSDictionary *infoDic) {
        ContactsModel * currentUser = [ContactsModel contactWithDic:infoDic];
        currentUser.state = kCurrentUser;
        [[DBManager shareManager] creatOrUpdateContactWith:currentUser];
    }];
}
// 获取好友资料

+ (void)getUserInfoFromServerWithUserId:(NSString *)userId completeHandler:(void(^)(NSDictionary * infoDic))completeHandler{
    
    NSString * url = @"http://192.168.2.233/imService/GetUser.ashx";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"userId"] = userId;
    
    [WJHttpTool get:url params:params success:^(id responseObject) {
        
        NSDictionary * dic = (NSDictionary *)responseObject;
        // 回调加载tableView数据
        completeHandler(dic);
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败：%@",error.localizedDescription);
    }];
}

//获取好友列表

+ (void)getAllFriendsFromServer:(void (^)(NSArray * dataArr,BOOL succeed))completeHandler{
    
    NSString * url = @"http://192.168.2.233/imService/GetContactors.ashx";
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"userId"] = [[NSUserDefaults standardUserDefaults] valueForKey:kIMUserId];
    
    [WJHttpTool get:url params:params success:^(id responseObject) {
        
        NSArray * arr = (NSArray * )responseObject;
        
        if (arr.count > 0) {
            NSDictionary * dic = arr.firstObject;
            //NSString * groupName = dic[@"Name"];
            NSArray * userArr = dic[@"Members"];

            NSMutableArray * tempArr = [NSMutableArray  array];
            for (NSDictionary * userDic in userArr) {
                
                ContactsModel * model = [ContactsModel contactWithDic:userDic];
                [tempArr addObject:model];

            }
            // 回调处理
            completeHandler(tempArr,YES);
            
        }else{
            // 回调空数组
            completeHandler(arr,YES);
        }
        
    } failure:^(NSError *error) {
        completeHandler(nil,NO);
        NSLog(@"请求失败：%@",error.localizedDescription);
        
    }];
}

+ (void)searchUserListWithKeyword:(NSString *)keyword completionHandler:(void (^)(NSArray *dataArr))completeHandler{

    //执行搜索
    
    NSString * url = @"http://192.168.2.233/imService/SearchUser.ashx";
    NSDictionary * param = [NSDictionary dictionaryWithObject:keyword forKey:@"key"];
    
    [WJHttpTool get:url params:param success:^(id responseObject) {
        
        NSArray * responseArr = responseObject;
        NSMutableArray * tempArr = [NSMutableArray array];
        for (NSDictionary * dic in responseArr) {
            
            ContactsModel * model = [ContactsModel contactWithDic:dic];
            if (![model.userId isEqualToString:CurrentUserId]) {
                [tempArr addObject:model];
            }
        }
        
        completeHandler(tempArr);
        
    } failure:^(NSError *error) {
        completeHandler(nil);
        NSLog(@"查询失败");
    }];

}

+ (void)changeHeadImageWithUser:(ContactsModel *)userModel imageData:(NSData *)imageData{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int headImageLen = (int)imageData.length;
        int headImageIndex = -1; // -1表示不使用默认图片，使用自定义图片
        int userLatestVersion = userModel.version.intValue;
        
        NSData * userIdData = [userModel.userId dataUsingEncoding:NSUTF8StringEncoding];
        int userIdLen = (int)userIdData.length;
        
        int totleLen = sizeof(headImageLen) + headImageLen + sizeof(headImageIndex) + sizeof(userIdLen) + userIdLen + sizeof(userLatestVersion);
        
        NSMutableData * data = [NSMutableData data];
        [data appendBytes:&totleLen length:sizeof(totleLen)];
        [data appendBytes:&headImageLen length:sizeof(headImageLen)];
        
        [data appendData:imageData];
        [data appendBytes:&headImageIndex length:sizeof(headImageIndex)];
        [data appendBytes:&userIdLen length:sizeof(userIdLen)];
        [data appendData:userIdData];
        [data appendBytes:&userLatestVersion length:sizeof(userLatestVersion)];
        
        //TODO: 修改头像
    });
    
}

+(void)changeFriendCommentName:(NSString *)commentName andUserId:(NSString *)userId{

    if (userId == nil) {
        NSLog(@"修改无效：%@",userId);
        return;
    }
    int totleLen;
    
    NSData * commentNameData = [commentName dataUsingEncoding:NSUTF8StringEncoding];
    int commentLen = (int)commentNameData.length;
    NSData * unitIdData = [userId dataUsingEncoding:NSUTF8StringEncoding];
    int unitIdLen = (int)unitIdData.length;
    
    totleLen = sizeof(commentLen) + commentLen + sizeof(unitIdLen) + unitIdLen;
    
    NSMutableData * data = [NSMutableData data];
    [data appendBytes:&totleLen length:sizeof(totleLen)];
    [data appendBytes:&commentLen length:sizeof(commentLen)];
    [data appendData:commentNameData];
    [data appendBytes:&unitIdLen length:sizeof(unitIdLen)];
    [data appendData:unitIdData];
    
    NSError * error = nil;
    // TODO:修改备注
    
    
    if (!error) {
        NSLog(@"备注修改成功");
    }else{
        NSLog(@"备注修改失败：%@",error.localizedDescription);
    }
    
}

+(void)changeMyBaseInfoWithName:(NSString *)name orgId:(NSString *)orgId signatureStr:(NSString *)signatureStr andCurrentUser:(ContactsModel *)user{
    
    if (user == nil) {
        NSLog(@"修改无效：%@",user);
        return;
    }
    
    int totleLen;
    NSData * nameData = [name dataUsingEncoding:NSUTF8StringEncoding];
    int nameLen = name == nil? -1:(int)nameData.length;
    NSData * orgIdData = [orgId dataUsingEncoding:NSUTF8StringEncoding];
    int orgIdLen = orgId == nil? -1:(int)orgIdData.length;
    NSData * signatrueData = [signatureStr dataUsingEncoding:NSUTF8StringEncoding];
    int signatureLen = signatureStr == nil? -1:(int)signatrueData.length;
    NSData * userIdData = [user.userId dataUsingEncoding:NSUTF8StringEncoding];
    int userIdLen = (int)userIdData.length;
    int userLatestVersion = user.version.intValue;
    
    totleLen = sizeof(nameLen) + nameLen + sizeof(orgIdLen) + (orgIdLen==-1?0:orgIdLen) + sizeof(signatureLen) + (signatureLen==-1?0:signatureLen) + sizeof(userIdLen) + userIdLen + sizeof(userLatestVersion);
    
    NSMutableData * data = [NSMutableData data];
    [data appendBytes:&totleLen length:sizeof(totleLen)];
    [data appendBytes:&nameLen length:sizeof(nameLen)];
    if (name != nil) {
        [data appendData:nameData];
    }
    
    [data appendBytes:&orgIdLen length:sizeof(orgIdLen)];
    if (orgId != nil) {
        [data appendData:orgIdData];
    }
    
    [data appendBytes:&userIdLen length:sizeof(userIdLen)];
    [data appendData:userIdData];
    [data appendBytes:&userLatestVersion length:sizeof(userLatestVersion)];
    
    NSError * error = nil;
    //TODO:修改基本信息
    
    if (!error) {
        NSLog(@"修改个人资料成功");
    }else{
    
        NSLog(@"修改个人资料失败：%@",error.localizedDescription);
    }
    
}



@end
