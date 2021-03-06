//
//  LoginManager.h
//  JWChat
//
//  Created by jerry on 2017/4/17.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kAccount = @"account";
static NSString * const kPassword = @"password";
static NSString * const kToken = @"token";
static NSString * const kAvatarUrl = @"avatarUrl";


@interface LoginManager : NSObject

+ (instancetype)shareManager;

- (void)loginWithAccount:(NSString *)account password:(NSString *)password completionHandler:(void (^)())completion;

- (BOOL)isFirstLogin;

- (void)autoLogin;

- (void)logout;





@end
