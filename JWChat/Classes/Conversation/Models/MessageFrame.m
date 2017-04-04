//
//  MessageFrame.m
//  ESDemo
//
//  Created by jerry on 16/9/9.
//  Copyright © 2016年 Zhang, Lawrence. All rights reserved.
//

#import "MessageFrame.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSString+WJExtension.h"

CGFloat margin = 10;

@implementation MessageFrame

-(void)setAMessage:(Message *)aMessage{

    _isMediaPlayed = NO;
    _isMediaPlaying = NO;
    
    _aMessage = aMessage;
    
    // 计算时间frame
    // 获取屏幕的宽度
    UIScreen * screen = [UIScreen mainScreen];
    
    // 理解：这里的bounds为整个屏幕的边界点(整个屏幕分辨率)
    
    CGSize timeSize = [aMessage.timeStr sizeWithMaxSize:CGSizeMake(SCREEN_WIDTH, 40) fontSize:14];

    //判断不隐藏的时候才显示时间的frame
    if (!aMessage.isHideTime) {
        _timeFrame = CGRectIntegral(CGRectMake(SCREEN_WIDTH/2 - timeSize.width/2, 10, timeSize.width, timeSize.height));
    }
    
    // 头像frame
    CGFloat iconWH = 40;
    CGFloat iconY = CGRectGetMaxY(_timeFrame) + margin;
    CGFloat iconX;
    
    if (aMessage.direction == MessageDirectionSend) {
        iconX = screen.bounds.size.width - iconWH - margin;
    }else{
        
        iconX = margin;
    }
    _iconFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
    // 设置聊天内容frame

    @synchronized (self) { // 写操作
        [self setContentCellFrameWithMessage:aMessage];
    }
    
    // 计算行高
    CGFloat iconMaxY = CGRectGetMaxY(_iconFrame);
    CGFloat textMaxY = CGRectGetMaxY(_contentFrame);
    
    _rowHeight = MAX(iconMaxY, textMaxY) + margin;
    
}

-(void)setContentCellFrameWithMessage:(Message *)message{

    switch (message.body.type) {
        case MessageBodyTypeText:
            [self setTextContenCellFrame:message];
            break;
        case MessageBodyTypeImage:{
            [self setImageContentCellFrame:message];
        }
            break;
        case MessageBodyTypeVoice:
            [self setVoiceContentCellFrame:message];
            break;
        case MessageBodyTypeFile:
            [self setFileContentCellFrame:message];
            break;
            
        default:
            break;
    }
}
-(void)setTextContenCellFrame:(Message *)message{

    TextMessageBody * textBody = (TextMessageBody *)message.body;
    
    // 转字符串为富文本字符串

    NSAttributedString * attributText = [EmotionImageFormateTool replacedEmotionStrWithStr:textBody.text strFont:[UIFont systemFontOfSize:FontSize] textColor:[UIColor blackColor]];
    // 通过文本内容技术其cell 宽高
    CGSize textSize = [attributText boundingRectWithSize:CGSizeMake(220, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGSize buttonSize = CGSizeMake(textSize.width + 30 , textSize.height + 30 );
    
    CGFloat textY = _iconFrame.origin.y;
    CGFloat textX;
    if (message.direction == MessageDirectionSend) {
        
        textX = _iconFrame.origin.x - margin/2 - buttonSize.width;
    }else{
        
        textX = CGRectGetMaxX(_iconFrame) +margin/2;
    }
    _contentFrame = CGRectMake(textX, textY, buttonSize.width,buttonSize.height);
}


-(void)setImageContentCellFrame:(Message *)message{
    
    ImageMessageBody * body = (ImageMessageBody *)message.body;
    UIImage * origImage = body.origImage;
        
        CGSize size = origImage.size;
        
        CGFloat scaleWH = 80;
        UIImage * thumbnailImage = size.width * size.height > scaleWH * scaleWH ? [UIImage scaleImage:origImage toScale:sqrt((scaleWH * scaleWH) / (size.width * size.height))] : origImage;
        
        CGSize imageContentSize = thumbnailImage.size;
        
        imageContentSize = CGSizeMake(imageContentSize.width + 30 , imageContentSize.height + 35 );
        
        CGFloat textY = _iconFrame.origin.y;
        CGFloat textX;
        if (message.direction == MessageDirectionSend) {
            
            textX = _iconFrame.origin.x - margin/2 - imageContentSize.width;
        }else{
            
            textX = CGRectGetMaxX(_iconFrame) +margin/2;
        }
        _contentFrame = CGRectMake(textX, textY, imageContentSize.width,imageContentSize.height);
    
}


-(void)setVoiceContentCellFrame:(Message *)message{

    int duration = ((VoiceMessageBody *)message.body).duration;
    
    CGFloat voiceViewSizeWidth;
    if (duration > 0 && duration <= 10) {
        voiceViewSizeWidth = duration * 10 + 50;
    }else{
    
        voiceViewSizeWidth = SCREEN_WIDTH/2;
    }
    CGSize voiceViewSize = CGSizeMake(voiceViewSizeWidth , 50);
    CGFloat textY = _iconFrame.origin.y;
    CGFloat textX;

    if (message.direction == MessageDirectionSend) {
        
        textX = _iconFrame.origin.x - margin/2 - voiceViewSize.width;
    }else{
        
        textX = CGRectGetMaxX(_iconFrame) +margin/2;
    }
    _contentFrame = CGRectMake(textX, textY, voiceViewSize.width,voiceViewSize.height);

}

-(void)setFileContentCellFrame:(Message *)message{

    CGSize fileContentSize = CGSizeMake(SCREEN_WIDTH*2/3, 80);
    
    CGFloat textY = _iconFrame.origin.y;
    CGFloat textX = 0;
    
    if (message.direction == MessageDirectionSend) {
        
        textX = _iconFrame.origin.x - margin/2 - fileContentSize.width;
    }else{
        
        textX = CGRectGetMaxX(_iconFrame) +margin/2;
    }
    _contentFrame = CGRectMake(textX, textY, fileContentSize.width,fileContentSize.height);
    
}
#pragma mark - pravite 


@end
