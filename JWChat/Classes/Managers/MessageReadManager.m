//
//  MessageReadManager.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/24.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "MessageReadManager.h"
#import "MWPhotoBrowser.h"
#import "MessageFrame.h"
#import "EMCDDeviceManager.h"
#import "ConvarsationListTableViewCell.h"

#define IMAGE_MAX_SIZE_5k 5120*2880   // 5K 分辨率

static MessageReadManager * manager = nil;

@interface MessageReadManager ()<MWPhotoBrowserDelegate>

@property (strong, nonatomic) UIWindow *keyWindow;

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) UINavigationController *photoNavigationController;

@property (strong, nonatomic) UIAlertView *textAlertView;

@end

@implementation MessageReadManager


+(instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MessageReadManager alloc] init];
        
    });
    return manager;
}

#pragma mark - getter

- (UIWindow *)keyWindow
{
    if(_keyWindow == nil)
    {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    return _keyWindow;
}

- (NSMutableArray *)photos
{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.edgesForExtendedLayout = YES;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        _photoBrowser.delegate = self;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}

- (UINavigationController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        // 设置UIViewController 模态显示样式
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    
    return nil;
}

-(void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser{

    [[self topViewController] dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - public 

// 显示图片浏览器
-(void)showBrowserWithImages:(NSArray *)imageArray{
    
    if (imageArray && [imageArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (id object in imageArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                CGFloat imageSize = ((UIImage*)object).size.width * ((UIImage*)object).size.height;
                if (imageSize > IMAGE_MAX_SIZE_5k) {
                    photo = [MWPhoto photoWithImage:[UIImage scaleImage:object toScale:(IMAGE_MAX_SIZE_5k)/imageSize]];
                } else {
                    photo = [MWPhoto photoWithImage:object];
                }
            }
            else if ([object isKindOfClass:[NSURL class]])
            {
                photo = [MWPhoto photoWithURL:object];
            }
            else if ([object isKindOfClass:[NSString class]])
            {
                
            }
            [photoArray addObject:photo];
        }
        
        self.photos = photoArray;
    }
    
    [[self topViewController] presentViewController:self.photoNavigationController animated:YES completion:nil];
}


// 播放音频
-(BOOL)prepareMessageAudioModel:(MessageFrame *)messageModel updateViewCompletion:(void (^)(MessageFrame *, MessageFrame *))updateCompletion{

    BOOL isPrepare = NO;
    
    if(messageModel.aMessage.body.type == MessageBodyTypeVoice)
    {
        MessageFrame *prevAudioModel = self.audioMessageModel;
        MessageFrame *currentAudioModel = messageModel;
        self.audioMessageModel = messageModel;
        
        BOOL isPlaying = messageModel.isMediaPlaying;
        
        if (isPlaying) {
            messageModel.isMediaPlaying = NO;
            self.audioMessageModel = nil;
            currentAudioModel = nil;
            [[EMCDDeviceManager sharedInstance] stopPlaying];
        }
        else {
            messageModel.isMediaPlaying = YES;
            prevAudioModel.isMediaPlaying = NO;
            isPrepare = YES;
//            
//            if (!messageModel.isMediaPlayed) {
//                messageModel.isMediaPlayed = YES;
//                Message *chatMessage = messageModel.aMessage;
//                if (chatMessage.ext) {
//                    NSMutableDictionary *dict = [chatMessage.ext mutableCopy];
//                    if (![[dict objectForKey:@"isPlayed"] boolValue]) {
//                        [dict setObject:@YES forKey:@"isPlayed"];
//                        chatMessage.ext = dict;
//                        //[[EMClient sharedClient].chatManager updateMessage:chatMessage completion:nil];
//                        //TODO:更新消息到数据库
//                    }
//                } else {
//                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:chatMessage.ext];
//                    [dic setObject:@YES forKey:@"isPlayed"];
//                    chatMessage.ext = dic;
//                    //[[EMClient sharedClient].chatManager updateMessage:chatMessage completion:nil];
//                    //TODO:更新消息到数据库
//                }
//            }
        }
        
        if (updateCompletion) {
            updateCompletion(prevAudioModel, currentAudioModel);
        }
    }
    return isPrepare;

}

-(MessageFrame *)stopMessageAudioModel{

    MessageFrame *model = nil;
    if (self.audioMessageModel.aMessage.body.type == MessageBodyTypeVoice) {
        if (self.audioMessageModel.isMediaPlaying) {
            model = self.audioMessageModel;
        }
        self.audioMessageModel.isMediaPlaying = NO;
        self.audioMessageModel = nil;
    }
    
    return model;
}

// 缓存所选择的附件到沙盒
- (NSString *)saveMsgAttachWithData:(NSData *)data attachType:(MessageBodyType)type  andAttachName:(NSString *)fileName{
    
    NSString * path = nil;
    NSString * relativePath = nil;
    switch (type) {
        case MessageBodyTypeImage:
            path = [NSHomeDirectory() stringByAppendingString:kImageRelativePath];
            relativePath = [kImageRelativePath stringByAppendingPathComponent:fileName];
            break;
        case MessageBodyTypeVoice:
            path = [NSHomeDirectory() stringByAppendingString:kVoiceRelativePath];
            relativePath = [kVoiceRelativePath stringByAppendingPathComponent:fileName];
            break;
        case MessageBodyTypeLocation:
            path = [NSHomeDirectory() stringByAppendingString:kLocationRelativePath];
            relativePath = [kLocationRelativePath stringByAppendingPathComponent:fileName];
        default:
            break;
    }
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * fullPath = [path stringByAppendingPathComponent:fileName];
    
    BOOL success = [data writeToFile:fullPath atomically:YES]; // 写入沙盒
    if (!success) {
        NSLog(@"图片沙盒缓存失败");
    }
    return relativePath;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - private


- (UIViewController*)topViewController
{
    return [UIViewController getCurrentViewControllerWithRootViewController:self.keyWindow.rootViewController];
}


@end
