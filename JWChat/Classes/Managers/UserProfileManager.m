//
//  UserProfileManager.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/27.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "UserProfileManager.h"

static UserProfileManager * manager = nil;

@implementation UserProfileManager

+(instancetype)sharedInstance{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserProfileManager alloc] init];
    });
    return  manager;
}



@end
