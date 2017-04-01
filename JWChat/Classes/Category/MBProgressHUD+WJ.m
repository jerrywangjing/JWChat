//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+WJ.h"
#import "UIImage+GIF.h"

#define Opacity 0.6 // 透明度

@implementation MBProgressHUD (WJ)




#pragma mark 显示信息@property (nonatomic,copy) NSString * name;
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置自定义视图
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.0]; // 延迟1秒后隐藏
}

#pragma mark 显示错误信息

+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

#pragma mark -- 只显示文字提示
+(void)showLabel:(NSString *)title{

    [self show:title icon:nil view:nil];
}
+(void)showLabel:(NSString *)title toView:(UIView *)view{

    [self show:title icon:nil view:view];
}

#pragma mark - 显示等待动画

+ (void)showHUDWithAnimated:(BOOL)animated{

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window animated:YES];
}

+ (void)hideAddedHUD{

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    if ([MBProgressHUD HUDForView:window]) {
        [MBProgressHUD hideHUDForView:window animated:YES];
    }
}
@end
