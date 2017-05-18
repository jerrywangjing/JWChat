//
//  UIImageView+Base64ImageCache.h
//  XYTPatients
//
//  Created by jerry on 2017/5/18.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Base64ImageCache)


/**
 加载base64图片

 @param base64 base64编码字符串
 */

- (void)setImageWithBase64:(NSString *)base64;

/**
 加载base64图片

 @param base64 base64编码字符串
 @param placeholder 占位图（用于为加载成功时使用）
 */
- (void)setImageWithBase64:(NSString *)base64 placeholderImage:(UIImage *)placeholder;

@end
