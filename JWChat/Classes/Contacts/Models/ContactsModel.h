//
//  ContactsModel.h
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/11/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsModel : NSObject

@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * version;  // 用户资料版本
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * sex; // 性别
@property (nonatomic,copy) NSString * avatarImageUrl;
@property (nonatomic,copy) NSString * neckName;
@property (nonatomic,copy) NSString * userComment; // 用户备注
@property (nonatomic,copy) NSString * noBothered; // 是否开启消息免打扰 1 是开启
@property (nonatomic,copy) NSString * verifyMsg; // 申请添加联系人的验证信息
@property (nonatomic,copy) NSString * state;    // 联系人是否被添加状态
@property (nonatomic,copy) NSString * online;   // 在线状态 1：在线 0 ：离线

-(instancetype)initWithUserId:(NSString *)userId;
+(instancetype)contactWithDic:(NSDictionary *)dic;
@end
