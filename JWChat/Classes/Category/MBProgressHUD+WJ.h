//
//  MBProgressHUD+WJ.h
//  BaseProject
//
//  Created by JerryWang on 2017/5/29.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (WJ)

/**
 显示提示hud，默认显示在当前控制器view上，默认不可交互
 
 @param tip 提示语
 */
+ (void)showTipHUD:(NSString *)tip;
+ (void)showTipHUDOnWindow:(NSString *)tip;


/**
 显示动态等待hud，默认显示在当前控制器view上，默认不可交互
 */
+ (void)showActivityHUD;
+ (void)showActivityHUD:(NSString *)message;
+ (void)showActivityHUDOnWindow:(NSString *)message;


/**
 显示自定义状态提示hud

 @param Message 提示文字
 */
+ (void)showSuccessHUD:(NSString *)Message;
+ (void)showErrorHUD:(NSString *)Message;
+ (void)showInfoHUD:(NSString *)Message;
+ (void)showWarnHUD:(NSString *)Message;


/**
 显示自定义hud

 @param imageName 图片的name
 @param message 提示文字
 */
+ (void)showCustomHUD:(NSString *)imageName message:(NSString *)message;
+ (void)showCustomHUDOnWindow:(NSString *)imageName message:(NSString *)message;


/**
 隐藏所有hud
 */
+ (void)hideHUD;

@end
