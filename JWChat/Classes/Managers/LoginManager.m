//
//  LoginManager.m
//  JWChat
//
//  Created by jerry on 2017/4/17.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager

+(instancetype)shareManager{

    static LoginManager * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LoginManager alloc] init];
    });
    
    return instance;
}



@end
