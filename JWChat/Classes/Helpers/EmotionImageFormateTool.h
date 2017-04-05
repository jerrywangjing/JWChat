//
//  EmotionImageFormateTool.h
//  XunYiTongV2.0
//
//  Created by JerryWang on 2017/1/13.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmotionImageFormateTool : NSObject

// 将含有表情的字符串转换为富文本字符串
+ (NSMutableAttributedString *)replacedEmotionStrWithStr:(NSString *)string strFont:(UIFont *)font textColor:(UIColor *)textColor;
// 返回带图片的富文本字符串


@end
