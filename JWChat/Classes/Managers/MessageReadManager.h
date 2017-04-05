//
//  MessageReadManager.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/24.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageBody.h"

@class MWPhotoBrowser,MessageFrame;

typedef void (^FinishBlock)(BOOL success);
typedef void (^PlayBlock)(BOOL playing, MessageFrame *messageModel);

@interface MessageReadManager : NSObject

@property (nonatomic,strong) MWPhotoBrowser * photoBrowser;
@property (strong, nonatomic) MessageFrame * audioMessageModel;
@property (nonatomic,copy) FinishBlock finishBlock;

+(instancetype)shareManager;

/// 显示图片
- (void)showBrowserWithImages:(NSArray *)imageArray;
/// 播放语言
- (BOOL)prepareMessageAudioModel:(MessageFrame *)messageModel
            updateViewCompletion:(void (^)(MessageFrame *prevAudioModel, MessageFrame *currentAudioModel))updateCompletion;

- (MessageFrame *)stopMessageAudioModel;

/// 缓存消息附件到本地沙盒（返回相对路径）
- (NSString *)saveMsgAttachWithData:(NSData *)data attachType:(MessageBodyType)type  andAttachName:(NSString *)fileName;

@end
