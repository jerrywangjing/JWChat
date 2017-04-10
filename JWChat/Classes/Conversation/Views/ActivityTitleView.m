//
//  ActivityTitleView.m
//  JWChat
//
//  Created by JerryWang on 2017/4/10.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "ActivityTitleView.h"

@implementation ActivityTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView = activityView;
        
        UILabel * title = [[UILabel alloc] init];
        _titleLabel = title;
        
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
        title.textColor = [UIColor whiteColor];
        [self addSubview:title];
        [self addSubview:_activityView];
        // 布局
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointMake(0, 0)); // 注意：由于label是self的子控件所以它的中心点是（0，0）
        }];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_titleLabel.mas_left).offset(-5);
            make.top.equalTo(_titleLabel.mas_top);
        }];
        
        // 添加点击事件
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloginClick)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}


// 重新登录点击方法
-(void)reloginClick{
    
    if ([self.delegate respondsToSelector:@selector(didClickRelogin:)]) {
        [self.delegate didClickRelogin:self];
    }
}

@end
