//
//  FilessageBody.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//WJ: 框架接口

#import "MessageBody.h"

/*
 *  附件下载状态
 */
typedef enum{
    DownloadStatusDownloading   = 0,  /*正在下载*/
    DownloadStatusSuccessed,          /*下载成功*/
    DownloadStatusFailed,             /*下载失败*/
    DownloadStatusPending,            /*准备下载*/
}DownloadStatus;


@class FileSelectModel;
@interface FileMessageBody : MessageBody

/// 文件唯一标示
@property (nonatomic,copy) NSString * fileId;
/*!
 * 附件的显示名
 */
@property (nonatomic, copy) NSString *displayName;

/*!
 *  附件的本地路径(必须)
 */
@property (nonatomic, copy) NSString *localPath;


/*!
 *  附件的大小, 以M为单位
 */
@property (nonatomic,copy) NSString * fileSize;

/*!
 *  附件的下载状态
 */
@property (nonatomic) DownloadStatus downloadStatus;
/*!
 *  附件在服务器上的路径
 */
@property (nonatomic, copy) NSString *rotePath;

/*!
 *  附件的密钥, 下载附件时需要密匙做校验
 */
@property (nonatomic, copy) NSString *secretKey;

/*!
 *  初始化文件消息体
 */
- (instancetype)initWithfileModel:(FileSelectModel *)model;

/*!
 *  初始化文件消息体
 */

@end
