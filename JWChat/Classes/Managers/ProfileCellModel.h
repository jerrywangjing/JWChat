//
//  ProfileCellModel.h
//  JWChat
//
//  Created by jerry on 2017/4/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileCellModel : NSObject

@property (nonatomic,copy) NSString * imageUrl;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subTitle;
@property (nonatomic,strong) NSNumber * gender;

+ (instancetype)cellModelWithDic:(NSDictionary *)dic;

@end
