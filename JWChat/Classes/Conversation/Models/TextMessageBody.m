//
//  TextMessageBody.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "TextMessageBody.h"

@implementation TextMessageBody

-(instancetype)initWithText:(NSString *)aText{
    if (self = [super initWithMessageBodyType:MessageBodyTypeText]) {
        
        self.text = aText;
    }
    return self;
}
@end
