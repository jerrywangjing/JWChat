//
//  MBProgressHUD+WJ.m
//  BaseProject
//
//  Created by JerryWang on 2017/5/29.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "MBProgressHUD+WJ.h"

static const NSInteger tipHideTime = 2;

@implementation MBProgressHUD (WJ)

+ (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow mode:(MBProgressHUDMode)mode;
{
    UIView  *view = isWindow? [UIApplication sharedApplication].keyWindow :[self getCurrentUIVC].view;
    MBProgressHUD * hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    }else{
        [hud showAnimated:YES];
    }
    hud.mode = mode;
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}
#pragma mark-------------------- show Tip----------------------------

+ (void)showTipHUD:(NSString *)tip{

    [self showTipMessage:tip isWindow:NO timer: tipHideTime];
}

+ (void)showTipHUDOnWindow:(NSString *)tip{

    [self showTipMessage:tip isWindow:YES timer:tipHideTime];
}

+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow mode:MBProgressHUDModeText];
    
    [hud hideAnimated:YES afterDelay:aTimer];
}

#pragma mark-------------------- show Activity----------------------------

+ (void)showActivityHUD{

    [self showActivityHUD:nil];
}

+ (void)showActivityHUD:(NSString *)message{

    [self showActivityMessage:message isWindow:NO timer:0];
}
+ (void)showActivityHUDOnWindow:(NSString *)message{

    [self showActivityMessage:message isWindow:YES timer:0];
}

+ (void)showActivityMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow mode:MBProgressHUDModeIndeterminate];
}


#pragma mark-------------------- show Image----------------------------

+ (void)showSuccessHUD:(NSString *)Message
{
    [self showCustomHUD:@"MBHUD_Success" message:Message];
}
+ (void)showErrorHUD:(NSString *)Message
{
    [self showCustomHUD:@"MBHUD_Error" message:Message];
}
+ (void)showInfoHUD:(NSString *)Message
{
    [self showCustomHUD:@"MBHUD_Info" message:Message];
}
+ (void)showWarnHUD:(NSString *)Message
{
    [self showCustomHUD:@"MBHUD_Warn" message:Message];
}

#pragma mark --------------------- show custom view----------------------------


+ (void)showCustomHUD:(NSString *)imageName message:(NSString *)message{

    [self showCustomIcon:imageName message:message isWindow:NO];
}

+ (void)showCustomHUDOnWindow:(NSString *)imageName message:(NSString *)message{

    [self showCustomIcon:imageName message:message isWindow:YES];
}

+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow
{
    UIView  *view = isWindow? [UIApplication sharedApplication].keyWindow :[self getCurrentUIVC].view;
    MBProgressHUD * hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    }else{
        [hud showAnimated:YES];
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:tipHideTime];
}

#pragma mark - hide view

+ (void)hideHUD
{
    UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
    
    [self hideHUD];
    [self hideHUDForView:winView animated:YES];
    [self hideHUDForView:[self getCurrentUIVC].view animated:YES];
}

#pragma mark ————— 顶部tip —————

//+ (void)showTopTipMessage:(NSString *)msg {
//    CGFloat padding = 10;
//    
//    YYLabel *label = [YYLabel new];
//    label.text = msg;
//    label.font = [UIFont systemFontOfSize:16];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.730];
//    label.width = SCREEN_WIDTH;
//    label.textContainerInset = UIEdgeInsetsMake(padding, padding, padding, padding);
//    label.height = [msg heightForFont:label.font width:label.width] + 2 * padding;
//    
//    label.bottom = (IOS7_LATER ? 64 : 0);
//    [[kAppDelegate getCurrentUIVC].view addSubview:label];
//    [UIView animateWithDuration:0.3 animations:^{
//        label.top = (IOS7_LATER ? 64 : 0);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            label.bottom = (IOS7_LATER ? 64 : 0);
//        } completion:^(BOOL finished) {
//            [label removeFromSuperview];
//        }];
//    }];
//}

#pragma mark - private

+ (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+ (UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}


@end
