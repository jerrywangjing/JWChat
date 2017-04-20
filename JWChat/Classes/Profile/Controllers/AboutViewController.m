//
//  AboutViewController.m
//  JWChat
//
//  Created by JerryWang on 2017/4/20.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic,weak) UIImageView * logo;
@property (nonatomic,weak) UILabel * version;
@property (nonatomic,weak) UILabel * copyright;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于";
    self.view.backgroundColor = WJRGBColor(228, 231, 236);
    [self setupLogo];
}

- (void)setupLogo{

    UIImageView * logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    _logo = logo;
    [self.view addSubview:logo];
    
    UILabel * version = [[UILabel alloc] init];
    version.text = @"版本号：1.0.0";
    version.font = [UIFont systemFontOfSize:13];
    version.textColor = [UIColor lightGrayColor];
    _version = version;
    [self.view addSubview:version];
    
    UILabel * copyright = [[UILabel alloc] init];
    _copyright = copyright;
    _copyright.text = @"Copyright ©2017 JWChat版权所有";
    _copyright.textColor = [UIColor lightGrayColor];
    _copyright.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_copyright];
}

-(void)viewWillLayoutSubviews{

    [super viewWillLayoutSubviews];
    
    [_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(200);
    }];
    
    [_version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_logo.mas_bottom).offset(10);
    }];
    
    [_copyright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
