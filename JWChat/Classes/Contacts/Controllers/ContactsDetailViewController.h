//
//  ContactsDetailViewController.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsDetailViewController : UIViewController

@property (nonatomic,weak) UIViewController * previousVc; // 导航栈中上一个控制器

- (instancetype)initWithUserId:(NSString *)userId;

@end
