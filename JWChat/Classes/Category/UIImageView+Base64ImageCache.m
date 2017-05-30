//
//  UIImageView+Base64ImageCache.m
//  XYTPatients
//
//  Created by jerry on 2017/5/18.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import "UIImageView+Base64ImageCache.h"
#import <SDImageCache.h>

@implementation UIImageView (Base64ImageCache)

- (void)setImageWithBase64:(NSString *)base64{

    return [self setImageWithBase64:base64 placeholderImage:nil];
}

- (void)setImageWithBase64:(NSString *)base64 placeholderImage:(UIImage *)placeholder{

    self.image = placeholder;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([base64 isEqual:[NSNull null]]) {
            return;
        }
        if (!base64 || [base64 isEqualToString:@""]) {
            return;
        }
        
        //取base64字符串后32个字符作为缓存的key
        NSString * cacheKey = base64.length > 32 ? [base64 substringFromIndex:base64.length-32] : base64;
        SDImageCache * cacheManager = [SDImageCache sharedImageCache];
        
        // 从内存、磁盘获取缓存，如未获取到则重新加载
        UIImage * image = [cacheManager imageFromMemoryCacheForKey:cacheKey];
        
        if (!image) {
            image = [cacheManager imageFromDiskCacheForKey:cacheKey];
        }
        if (!image) {
            NSData * imgData = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
            image = [UIImage imageWithData:imgData];
            [cacheManager storeImage:image forKey:cacheKey];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新图片
            self.image = image;
        });
    });
    
}

@end
