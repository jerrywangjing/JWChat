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
 @param items 将要显示的item 标题
 @param completion 点击后对应item的回调
 */
+ (void)showAlertSheetViewItems:(NSArray<NSString *> *)items completion:(void (^)(NSInteger index))completion;

@end
