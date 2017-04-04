//
// Created by zorro on 15/3/7.
// Copyright (c) 2015 tutuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+EmojiExtension.h"
#import "LiuqsTextAttachment.h"

@implementation NSAttributedString (EmojiExtension)

//用来获取textview中的字符串（使用块遍历富文本，把其中的附件替换成文本，比如：你好呀[开心]）
- (NSString *)getPlainString {
    
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(LiuqsTextAttachment *value, NSRange range, BOOL *stop) {
                      if (value) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:value.emojiTag];
                          base += value.emojiTag.length - 1;
                      }
                  }];
    return plainString;
}

@end
