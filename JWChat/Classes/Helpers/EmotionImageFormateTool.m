//
//  EmotionImageFormateTool.m
//  XunYiTongV2.0
//
//  Created by JerryWang on 2017/1/13.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import "EmotionImageFormateTool.h"

#define  EmojiWH 20 // 表情的大小

@implementation EmotionImageFormateTool

+ (NSMutableAttributedString *)replacedEmotionStrWithStr:(NSString *)string strFont:(UIFont *)font textColor:(UIColor *)textColor{

    // 创建原始属性字符串
    NSAttributedString * origAtt = [self creatAttStringWithStr:string font:font color:textColor];
    // 正则匹配出表情的位置
    NSArray * chechResults = [self matchEmotionsWithString:string];
    //拿出匹配到的表情图片
    NSArray * emojiImageArr = [self getEmojiImagesWithMatchResult:chechResults addString:string];
    // 执行替换返回富文本

    NSMutableAttributedString * mutableAtt = [[NSMutableAttributedString alloc] initWithAttributedString:origAtt];
    NSMutableAttributedString * resultAtt = [self replaceTextWithOrigAttStr:mutableAtt emojiImgArr:emojiImageArr];
    
    return resultAtt;
}

+ (NSMutableAttributedString *)creatAttStringWithStr:(NSString *)str font:(UIFont *)font color:(UIColor *)color{
    
    // 设置文本参数
    
    NSMutableParagraphStyle * paraStyle = [[NSMutableParagraphStyle alloc]  init];
    [paraStyle setLineSpacing:4.0f]; // 设置行间距
    
    NSMutableDictionary * attDic = [NSMutableDictionary dictionary];
    attDic[NSForegroundColorAttributeName] = color;
    attDic[NSFontAttributeName] = font;
    attDic[NSParagraphStyleAttributeName] = paraStyle;
    
   return [[NSMutableAttributedString alloc] initWithString:str attributes:attDic];
    
}

// 正则匹配表情
+ (NSArray *)matchEmotionsWithString:(NSString *)str{

    // @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"  含义：[]中至少有一个字母或数字或汉字的字符串
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    
    NSRegularExpression * regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    return [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
}

+ (NSArray *)getEmojiImagesWithMatchResult:(NSArray *)matchRlts addString:(NSString *)str{

    NSMutableArray * tempArr = [NSMutableArray array];
    // 加载表情对照表
    NSString * path = [[NSBundle mainBundle] pathForResource:@"LiuqsEmoji.plist" ofType:nil];
    NSDictionary * emojiImageDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // 注意：如果多个表情的话，必须从后往前替换这样range 才不会错乱,应该 range 中的location 是从前往后数的。
    for (int i = (int)matchRlts.count - 1; i >= 0; i--){
        
        NSMutableDictionary * attDic = [NSMutableDictionary dictionary];
        // 创建附件
        LiuqsTextAttachment * attach = [[LiuqsTextAttachment alloc] init];
        // 根据字体的大小类匹配表情的大小
        attach.emojiSize = CGSizeMake(EmojiWH, EmojiWH);
        
        NSTextCheckingResult *match = [matchRlts objectAtIndex:i];
        NSString * emojiName = [str substringWithRange:match.range];
        NSString * imageName = emojiImageDic[emojiName];
        
        if (emojiName.length > 0) {
            
            attach.image = [UIImage imageNamed:imageName];
        }
        // 将表情位置和表情富文本存放到字典中
        
        NSAttributedString * attStr = [NSAttributedString attributedStringWithAttachment:attach];
        
        [attDic setObject:attStr forKey:@"image"];
        [attDic setObject:[NSValue valueWithRange:match.range] forKey:@"range"];
        [tempArr addObject:attDic];
    }
    return tempArr;
}

// 执行替换返回富文本
+ (NSMutableAttributedString *)replaceTextWithOrigAttStr:(NSMutableAttributedString *)origAttStr emojiImgArr:(NSArray *)imageArr{
    
    for (NSDictionary * dic in imageArr) {
        NSValue * value = dic[@"range"];
        NSRange range = value.rangeValue;
        NSAttributedString * attStr = dic[@"image"];
        
        [origAttStr replaceCharactersInRange:range withAttributedString:attStr];
    }
    
    return origAttStr;
}

@end
