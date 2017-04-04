//
//  MessageFrame.h
//  ESDemo
//
//  Created by jerry on 16/9/9.
//  Copyright © 2016年 Zhang, Lawrence. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface MessageFrame : NSObject

@property (nonatomic,assign,readonly) CGRect timeFrame;
@property (nonatomic,assign,readonly) CGRect iconFrame;
@property (nonatomic,assign,readonly) CGRect contentFrame;

@property (nonatomic,assign) BOOL isMediaPlaying;
@property (nonatomic,assign) BOOL isMediaPlayed;

// 行高
@property (nonatomic,assign,readonly) CGFloat rowHeight;
/// 消息对象
@property (nonatomic,strong) Message * aMessage;
@end
