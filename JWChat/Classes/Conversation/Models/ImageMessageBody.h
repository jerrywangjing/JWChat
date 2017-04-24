//
//  ImageMessageBody.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//  WJ: 框架接口

/*!
 *  图片消息体，SDK发送消息前会根据compressRatio压缩通过-(instancetype)initWithData:displayName:或
 *  -(instancetype)initWithData:thumbnailData:创建的消息体的图片
 */


#import "FileMessageBody.h"

@interface ImageMessageBody : FileMessageBody

/// 图片附件的尺寸
@property (nonatomic) CGSize size;

///设置发送图片消息时的压缩率，1.0时不压缩，默认值是0.6，如果设置了小于等于0的值，则使用默认值
@property (nonatomic) CGFloat compressionRatio; // 暂未使用

/// 原始图片数据
@property (nonatomic,strong) UIImage * origImage;

///缩略图的显示名

@property (nonatomic,copy) NSString *imageName;

///原图本地路径

@property (nonatomic,copy) NSString *imageLocalPath;

/// 缩略图
@property (nonatomic,copy) UIImage * thumbnailImage;

/// 缩略图远程路径
@property (nonatomic,copy) NSString *thumbUrl;
/// 图片远程路径
@property (nonatomic,copy) NSString *url;

- (instancetype)initWithData:(NSData *)aData
                   localPath:(NSString *)localPath;

//----------------------------------------------------------
///*!
// *  缩略图在服务器的路径
// */
//@property (nonatomic, copy) NSString *thumbnailRemotePath;
//
///*!
// *  缩略图的密钥, 下载缩略图时需要密匙做校验
// */
//@property (nonatomic, copy) NSString *thumbnailSecretKey;
//
///*!
// *  缩略图的尺寸
// */
//@property (nonatomic) CGSize thumbnailSize;
//
///*!
// *  缩略图文件的大小, 以字节为单位
// */
//@property (nonatomic) long long thumbnailFileLength;
//
///*!
// *  缩略图下载状态
// */
////@property (nonatomic)EMDownloadStatus thumbnailDownloadStatus;

/*!
 *  \~chinese
 *  初始化图片消息体
 *
 *  @param aData          图片数据
 *  @param aThumbnailData 缩略图数据
 *
 *  @result 图片消息体实例
 */



@end
