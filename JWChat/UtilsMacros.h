//
//  UtilsMacros.h
//  JWChat
//
//  Created by jerry on 2017/6/2.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h


//屏幕相关

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define NavBarH 64
#define TabBarH 44
#define WIDTH_RATE (SCREEN_WIDTH/375)   // 屏幕宽度系数（以4.7英寸为基准）
#define HEIGHT_RATE (SCREEN_HEIGHT/667)

#define iOS7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)


#endif /* UtilsMacros_h */
