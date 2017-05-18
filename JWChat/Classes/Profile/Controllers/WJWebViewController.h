//
//  WJWebViewController.h
//  XunYiTongV2.0
//
//  Created by jerry on 2017/5/18.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJWebViewController : UIViewController

/// URL地址
@property (nonatomic, copy) NSString *url;
/// 是否使用下拉刷新
@property (nonatomic, assign) BOOL canDownRefresh;

@end
