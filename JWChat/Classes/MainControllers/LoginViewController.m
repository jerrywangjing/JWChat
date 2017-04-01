//
//  LoginViewController.m
//  JWChat
//
//  Created by JerryWang on 2017/3/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic,strong) UIImageView * avatarView;
@property (nonatomic,strong) UIView * accountContainerView;
@property (nonatomic,strong) UIView * passwordContainerView;
@property (nonatomic,strong) UITextField * accountText;
@property (nonatomic,strong) UITextField * passwordText;
@property (nonatomic,strong) UILabel * accountLabel;
@property (nonatomic,strong) UIButton * loginIssueBtn;
@property (nonatomic,strong) UIButton * moreBtn;
@property (nonatomic,strong) UIButton * loginBtn;

@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // init default values
        
    }
    return self;
}


- (void)loadView{

    [super loadView];
    // init subViews
    [self configureSubviews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // init data source
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(80);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_avatarView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    
    [_accountContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    
    [_passwordContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountContainerView.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordContainerView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
    }];
    [_loginIssueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
}

#pragma  mark - configure subViews

- (void)configureSubviews{
    
    _avatarView  = [[UIImageView alloc] init];
    _avatarView.backgroundColor = [UIColor grayColor];
//    _avatarView.layer.cornerRadius = 5;
//    _avatarView.layer.masksToBounds = YES;
    _avatarView.image = [UIImage imageNamed:@"avatar"];
    [self.view addSubview:_avatarView];
    
    _accountLabel = [[UILabel alloc] init];
    _accountLabel.font = [UIFont boldSystemFontOfSize:16];
    _accountLabel.textColor = [UIColor blackColor];
    _accountLabel.textAlignment = NSTextAlignmentCenter;
    _accountLabel.text = @"+86 15108496988";
    [self.view addSubview:_accountLabel];
    

    _accountContainerView = [[UIView alloc] init];
    _accountText = [self creatTextInputFieldWith:@"账号" placeholder:@"请填写账号" containerView: _accountContainerView];
    
    _passwordContainerView = [[UIView alloc] init];
    _passwordText = [self creatTextInputFieldWith:@"密码" placeholder:@"请填写密码" containerView:_passwordContainerView];
    
    [self.view addSubview:_accountContainerView];
    [self.view addSubview:_passwordContainerView];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login_nor"] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login_hlt"] forState:UIControlStateHighlighted];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _loginBtn];
    
    _loginIssueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginIssueBtn setTitle:@"登录遇到问题?" forState:UIControlStateNormal];
    [_loginIssueBtn setTitleColor:WJRGBColor(70, 87, 131) forState:UIControlStateNormal];
    _loginIssueBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_loginIssueBtn addTarget:self action:@selector(loginIssusBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginIssueBtn];

    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_moreBtn setTitleColor:WJRGBColor(70, 87, 131) forState:UIControlStateNormal];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_moreBtn addTarget:self action:@selector(moreBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreBtn];
}

- (UITextField *)creatTextInputFieldWith:(NSString *)title placeholder:(NSString *)placeholder containerView:(UIView *) containerView{

    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 50)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = title;
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(250+15), 0, 250, 50)];
    textField.placeholder = placeholder;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:16];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, 50-0.5, SCREEN_WIDTH-20, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:textField];
    [containerView addSubview:line];

    return textField;
    
}

#pragma mark - actions

- (void)loginBtnDidClick:(UIButton *)btn{

    NSLog(@"登录");
}

- (void)loginIssusBtnDidClick:(UIButton *)btn{
    NSLog(@"问题按钮");
}

- (void)moreBtnDidClick:(UIButton *)btn{
    NSLog(@"更多");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end


