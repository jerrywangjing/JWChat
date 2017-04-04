///Users/jerry/Downloads/OMCS.Server.zip
//  VoiceMessageBody.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "VoiceMessageBody.h"

@implementation VoiceMessageBody

-(instancetype)initWithLocalPath:(NSString *)localPath duration:(int)duration{

    if (self = [super initWithMessageBodyType:MessageBodyTypeVoice]) {
        self.duration = duration;
        self.voiceLocalPath = localPath;
    }
    
    return self;
}


@end
