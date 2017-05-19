//
//  LocationMessageBody.m
//  JWChat
//
//  Created by jerry on 2017/5/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "LocationMessageBody.h"

@implementation LocationMessageBody

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude bodyType:(MessageBodyType)type{

    if (self = [super initWithMessageBodyType:type]) {

        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

@end
