//
//  DataManager.h
//  JWChat
//
//  Created by JerryWang on 2017/4/1.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LoginState){

    LoginStateSuccess,
    LoginStateFailure,
};

@interface DataManager : NSObject

+ (void)loginWithUsername:(NSString *)username password:(NSString *) password success:(void (^) (LoginState responseType))success failure:(void (^) (NSError *error))failure;


@end
