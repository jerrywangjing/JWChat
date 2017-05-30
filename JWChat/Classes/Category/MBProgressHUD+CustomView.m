//
//  MBProgressHUD+CustomView.m
//  JWChat
//
//  Created by jerry on 17/4/1.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "MBProgressHUD+CustomView.h"

@implementation MBProgressHUD (CustomView)

#pragma mark - 等待指示器hud

+ (void)showHUD{

    [self showHUDWithTitle:nil];
}
+ (void)hideHUD{
    
    [self hideHUDFromView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 带文字的等待指示器hud

+ (void)showHUDWithTitle:(NSString *)title{

    [self showHUDWithTitle:title toView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showHUDWithTitle:(NSString *)title toView:(UIView *)view{

    if (!view) return;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.label.text = title;
    hud.mode = MBProgressHUDModeIndeterminate; // 默认指示器样式
    hud.animationType = MBProgressHUDAnimationZoomOut; // 动画样式
    
    hud.label.textColor = [UIColor whiteColor];  // 设置字体颜色
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7]; // hud背景颜色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor; // hud背景样式
//    hud.bezelView.alpha = 0.6;
      
    hud.userInteractionEnabled = NO; // 开启后可点击hud外的其他控件
    
//    hud.contentColor = [UIColor whiteColor]; // 可修改指示器和hud背景的颜色
//    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    // hud.bezelView // hud的背景视图
    // hud.backgroundView // hud的蒙版视图
    // hud.customView  // 自定义视图
}

+ (void)hideHUDFromView:(UIView *)view{
    
    if (!view) return;
    [MBProgressHUD hideHUDForView:view animated:YES];
}

#pragma mark - 文本hud

+ (void)showLabelWithText:(NSString *)text{

    [self showLabelWithText:text toView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showLabelWithText:(NSString *)text toView:(UIView *)view{

    if (!view) return;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;

    hud.animationType = MBProgressHUDAnimationFade;
    [hud hideAnimated:YES afterDelay:1.0f];
}

#pragma mark - 进度指示hud

+ (void)showProgressHUD:(void (^)(CGFloat value))progress{

    [self showProgressHUDToView:[UIApplication sharedApplication].keyWindow progress:^(CGFloat value) {
        progress(value);
    }];
}
+ (void)showProgressHUDToView:(UIView *)view progress:(void (^)(CGFloat value))progress{
    if (!view) return;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    progress(hud.progress);

}

#pragma mark - 自定义指示器hud


+ (void)showSuccessWithText:(NSString *)text{

    [self showCustomHUDWithImage:@"success.png" text:text];
}

+ (void)showErrorWithText:(NSString *)text{

    [self showCustomHUDWithImage:@"error" text:text];
}

+ (void)showCustomHUDWithImage:(NSString *)image text:(NSString *)text{

    UIView * view = [UIApplication sharedApplication].keyWindow;
    UIImageView * indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    
    [self showHUDToView:view indicatorView:indicatorView title:text];
}

+ (void)showHUDToView:(UIView *)view indicatorView:(UIView *)indicatorView title:(NSString *)title{

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo: view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.customView = indicatorView;
    hud.label.text = title;
    
    [hud hideAnimated:YES afterDelay:1.0f];
}
@end
