//
//  MainNavController.m
//  JWChat
//
//  Created by JerryWang on 2017/3/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "MainNavController.h"

@interface MainNavController ()

@end

@implementation MainNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationBar * navBar = [UINavigationBar appearance];

    navBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    navBar.barTintColor = WJRGBColor(41, 40, 44); // 导航栏背景色
    navBar.tintColor = [UIColor whiteColor];

    // 修改导航栏返回按钮图片
    UIImage *buttonNormal = [[UIImage imageNamed:@"icon_back_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navBar setBackIndicatorImage:buttonNormal];
    [navBar setBackIndicatorTransitionMaskImage:buttonNormal];
    
    // 去掉导航栏返回按钮文字
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

//push时隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

// 设置状态栏样式

-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
