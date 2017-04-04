//
//  UserProfileManager.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/27.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPARSE_HXUSER @"hxuser"
#define kPARSE_HXUSER_USERNAME @"username"
#define kPARSE_HXUSER_NICKNAME @"nickname"
#define kPARSE_HXUSER_AVATAR @"avatar"

@class UserProfileEntity;

@interface UserProfileManager : NSObject

+ (instancetype)sharedInstance;


/*
 *  上传个人头像
 */
- (void)uploadUserHeadImageProfileInBackground:(UIImage*)image
                                    completion:(void (^)(BOOL success, NSError *error))completion;

/*
 *  上传个人信息
 */
- (void)updateUserProfileInBackground:(NSDictionary*)param
                           completion:(void (^)(BOOL success, NSError *error))completion;

/*
 *  获取用户信息 by username
 */
- (void)loadUserProfileInBackground:(NSArray*)usernames
                       saveToLoacal:(BOOL)save
                         completion:(void (^)(BOOL success, NSError *error))completion;

/*
 *  获取本地用户信息
 */
- (UserProfileEntity*)getUserProfileByUsername:(NSString*)username;

/*
 *  获取当前用户信息
 */
- (UserProfileEntity*)getCurUserProfile;

/*
 *  根据username获取当前用户昵称
 */
- (NSString*)getNickNameWithUsername:(NSString*)username;

@end


@interface UserProfileEntity : NSObject  // 用户个人信息模型


@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *imageUrl;

@end