//
//  UIImage+Extension.h
//  QQ界面
//
//  Created by JerryWang on 16/1/25.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
///图片局部拉伸（防止四角变形）
+ (instancetype)resizeImage:(NSString *)imgName;
///创建纯色图片
+ (UIImage *)createImageWithColor:(UIColor*)color;
///压缩图片分类
+ (UIImage *)imageCompressForSourceImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth;
/// 等比缩放图片
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
/// 给图片切圆角
+(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
/// 获取头像
+ (UIImage* )getAvatarImageWithString:(NSString *)str;
@end
