//
//  ContactsManager.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/12/2.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsManager : NSObject

+ (NSString *)getUserName:(NIMUser *)user;
+ (NSString *)getNickName:(NIMUser *)user;
+ (NSString *)getAvatarUrl:(NIMUser *)user;
+ (NIMUserGender)getGender:(NIMUser *)user;
+ (NSString *)getBirthday:(NIMUser *)user;
+ (NSString *)getPhoneNumber:(NIMUser *)user;
+ (NSString *)getEmail:(NIMUser *)user;
+ (NSString *)getSign:(NIMUser *)user;

@end
