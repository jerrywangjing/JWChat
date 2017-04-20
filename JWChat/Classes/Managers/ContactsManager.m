//
//  ContactsManager.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/12/2.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ContactsManager.h"

@implementation ContactsManager

+ (NSString *)getUserName:(NIMUser *)user{

    if (user.alias) {
        return user.alias;
    }
    if (user.userInfo) {
        return user.userInfo.nickName;
    }
    return user.userId;
}

+ (NSString *)getAvatarUrl:(NIMUser *)user{

    if (user.userInfo) {
        if (user.userInfo.avatarUrl) {
            return user.userInfo.avatarUrl;
        }
    }
    return @"";
}

+ (NIMUserGender)getGender:(NIMUser *)user{

    if (user.userInfo) {
        if (user.userInfo) {
            return user.userInfo.gender;
        }
    }
    return NIMUserGenderUnknown;
}

@end
