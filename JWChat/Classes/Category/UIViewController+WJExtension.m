//
//  UIViewController+WJExtension.m
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/11/26.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "UIViewController+WJExtension.h"

@implementation UIViewController (WJExtension)


+ (UIViewController*)getCurrentViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self getCurrentViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self getCurrentViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self getCurrentViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
@end
