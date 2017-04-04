//
//  ContactsModel.m
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/11/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ContactsModel.h"

@implementation ContactsModel

-(instancetype)initWithUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (instancetype) initWithDic:(NSDictionary *)dic{

    if (self = [super init]) {
        _userId = dic[@"UserID"];
        NSNumber * version = dic[@"Version"];
        _version = [NSString stringWithFormat:@"%ld",version.integerValue];
        _avatarImageUrl = dic[@"HeadImageData"];
        _userName = dic[@"Name"];
        _sex = dic[@"Sex"];
        _neckName = dic[@"Signature"];
        _online = [self getOnlineStateWithUserId:_userId];
    }
    return self;
}

+(instancetype)contactWithDic:(NSDictionary *)dic{

    return [[self alloc] initWithDic:dic];
}

-(NSString *)getOnlineStateWithUserId:(NSString * )userId{

    // 获取在线状态
    BOOL isOnline = YES;
    if (isOnline) {
        return @"1";
    }else{
    
        return @"0";
    }
}


@end
