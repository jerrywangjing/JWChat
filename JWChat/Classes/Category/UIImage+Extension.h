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
/// UIImage圆角裁剪
- (UIImage * )makeRoundedCornerWithRadius:(float)radius;

/// 获取base64编码头像
- (UIImage *)getImageWithBase64:(NSString *)base64;

/**
 @param scale 切角比例，取值0-1
 @return 圆角图片
 */
- (UIImage * )makeRoundedCornerWithScale:(CGFloat)scale;
/// image -> base64 字符串
+ (NSString *) image2DataURL: (UIImage *) image;
@end
