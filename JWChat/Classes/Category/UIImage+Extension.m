//
//  UIImage+Extension.m
//  QQ界面
//
//  Created by JerryWang on 16/1/25.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


+(instancetype)resizeImage:(NSString *)imgName{

    UIImage *bgImage = [UIImage imageNamed:imgName];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2  topCapHeight:bgImage.size.height/2   ];
    return bgImage;
}

+ (UIImage *)createImageWithColor:(UIColor*)color {
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

// 图片压缩
+ (UIImage *) imageCompressForSourceImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth
{
    CGFloat scale = targetWidth/sourceImage.size.width;
    CGFloat targetHeight = scale * sourceImage.size.height; // 高度等比换算
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 图片等比缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    // 1. 开启指定大小的图片上下文
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    // 2. 将源图片绘制到给定的区域大小中
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    // 3. 从当前的图片上下文中获取到图片对象
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 4. 关闭图片上下文
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


// 圆角图片（贝塞尔方式）

- (UIImage * )makeRoundedCornerWithRadius:(float)radius{
    
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    // 防止圆角半径小于0，或者大于宽/高中较小值的一半。
    if (radius < 0)
        radius = 0;
    else if (radius > MIN(w/2, h/2))
        radius = MIN(w, h) / 2.;
    
    UIImage *image = nil;
    CGRect imageFrame = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:radius] addClip];
    [self drawInRect:imageFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 更加百分比来设置圆角,scale取值范围：0-1
- (UIImage * )makeRoundedCornerWithScale:(CGFloat)scale{
    
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    
    if (scale < 0 ) {
        scale = 0;
    }
    CGFloat radius = w/2 * scale;
    
    UIImage *image = nil;
    CGRect imageFrame = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, screenScale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:radius] addClip];
    [self drawInRect:imageFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage* )getAvatarImageWithString:(NSString *)str{
    
//    NSData * imgData = nil;
//    if (![str isKindOfClass:[NSNull class]] && str != nil) {
//        imgData = [[NSData alloc] initWithBase64EncodedString:str options:0];
//    }
//    
//    UIImage * avatarImg = imgData == nil?[UIImage imageNamed:@"avatar_man"]:[[UIImage alloc] initWithData:imgData];
    UIImage * avatarImg = [UIImage imageNamed:str];
    
    return avatarImg;
}
@end
