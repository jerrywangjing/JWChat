//
//  ProfileCellModel.m
//  JWChat
//
//  Created by jerry on 2017/4/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "ProfileCellModel.h"

@implementation ProfileCellModel

+ (instancetype)cellModelWithDic:(NSDictionary *)dic{

    return [[ProfileCellModel alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
