//
//  MBProgressHUD+CustomView.h
//  JWChat
//
//  Created by jerry on 17/4/1.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (CustomView)

+ (void)showHUD;
+ (void)showHUDWithTitle:(NSString *)title;
+ (void)showHUDWithTitle:(NSString *)title toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDFromView:(UIView *)view;

+ (void)showLabelWithText:(NSString *)text;
+ (void)showLabelWithText:(NSString *)text toView:(UIView *)view;

+ (void)showProgressHUDToView:(UIView *)view progress:(void (^)(CGFloat value))progress;

+ (void)showErrorWithText:(NSString *)text;
+ (void)showSuccessWithText:(NSString *)text;

@end
