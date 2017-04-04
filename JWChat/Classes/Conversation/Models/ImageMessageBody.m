//
//  ImageMessageBody.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ImageMessageBody.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ImageMessageBody

-(instancetype)initWithData:(NSData *)aData localPath:(NSString *)localPath{

    if (self = [super initWithMessageBodyType:MessageBodyTypeImage]) {

        NSString * fullPath = nil;
        if (localPath) {
            fullPath = [NSHomeDirectory() stringByAppendingString:localPath];
        }
        
        _origImage = [UIImage imageWithData:aData] == nil ? [UIImage imageWithContentsOfFile:fullPath] : [UIImage imageWithData:aData];
        _imageLocalPath = localPath;
        _imageName = localPath.lastPathComponent;
        _thumbnailImage = [self getThumbnailImage:_origImage];
        _size = _origImage.size;

    }
    return self;
}

// 获取压缩后的缩略图
-(UIImage *)getThumbnailImage:(UIImage *)origImage{

    UIImage * thumbnailImage;
    
    CGSize size = origImage.size;
    
    thumbnailImage = size.width * size.height > 200 * 200 ? [UIImage scaleImage:origImage toScale:sqrt((200 * 200) / (size.width * size.height))] : origImage;
    
    return  thumbnailImage;
    
}




@end
