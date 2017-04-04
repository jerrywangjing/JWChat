//
//  ConversationViewController.h
//  JWChat
//
//  Created by jerry on 17/4/1.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationViewController : UIViewController

// 网络/登录状态回调显示
- (void)updateTitleWithLinkState:(NSString *)state showIndicator:(BOOL)show;

@end


// 状态标题视图

@protocol ActivityViewTitleDelegate <NSObject>

-(void)didClickRelogin:(UIView * )activityView;

@end

@interface ActivityViewTitle : UIView

@property (nonatomic,weak)UIActivityIndicatorView * activityView;
@property (nonatomic,weak)UILabel * titleLabel;
@property (nonatomic,weak)id<ActivityViewTitleDelegate>delegate;

@end
