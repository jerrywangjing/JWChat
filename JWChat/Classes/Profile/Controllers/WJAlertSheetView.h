//
//  WJAlertSheetView.h
//  JWChat
//
//  Created by JerryWang on 2017/4/26.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJAlertSheetView : UIView

/**
 WJAlertView

 @param tips 弹出框中的提示语
 @param items 按钮,注意：取消按钮的index = 0，其他的item index值从1开始算起
 @param completion 点击完成回调
 */

+ (void)showAlertSheetViewWithTips:(NSString *)tips
                             items:(NSArray<NSString *> *)items
                        completion:(void (^)(NSInteger index))completion;
@end
