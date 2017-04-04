//
//  MessageBody.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "MessageBody.h"

@implementation MessageBody

-(instancetype)initWithMessageBodyType:(MessageBodyType)type{

    if (self = [super init]) {
        self.type = type;
    }
    return self;
}
@end
