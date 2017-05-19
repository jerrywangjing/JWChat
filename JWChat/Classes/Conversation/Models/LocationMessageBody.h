//
//  LocationMessageBody.h
//  JWChat
//
//  Created by jerry on 2017/5/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationMessageBody : MessageBody

/// 地址
@property (nonatomic,copy) NSString * address;
/// 道路名称
@property (nonatomic,copy) NSString * roadName;
/// 位置截图地址
@property (nonatomic,copy) NSString * screenshotPath;
/// 纬度
@property (nonatomic, assign) double latitude;
/// 经度
@property (nonatomic, assign) double longitude;


- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude bodyType:(MessageBodyType)type;
@end
