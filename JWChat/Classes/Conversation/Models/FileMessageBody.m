//
//  FileMessageBody.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "FileMessageBody.h"

@implementation FileMessageBody

-(instancetype)initWithData:(NSData *)aData displayName:(NSString *)aDisplayName{

    if (self = [super initWithMessageBodyType:MessageBodyTypeFile]) {
        _displayName = aDisplayName;
    }
    return self;
}

@end
