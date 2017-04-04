//
//  UIViewController+WJExtension.h
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/11/26.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WJExtension)

/// 获取当前控制器
+ (UIViewController*)getCurrentViewControllerWithRootViewController:(UIViewController*)rootViewController;
/// 获取导航栏底部1px 黑线
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

@end
