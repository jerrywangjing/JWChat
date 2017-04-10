//
//  ActivityTitleView.h
//  JWChat
//
//  Created by JerryWang on 2017/4/10.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityTitleViewDelegate <NSObject>

-(void)didClickRelogin:(UIView * )activityView;

@end


@interface ActivityTitleView : UIView

@property (nonatomic,weak)UIActivityIndicatorView * activityView;
@property (nonatomic,weak)UILabel * titleLabel;
@property (nonatomic,weak)id<ActivityTitleViewDelegate>delegate;

@end

