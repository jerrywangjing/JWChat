//
//  LoginViewController.m
//  JWChat
//
//  Created by JerryWang on 2017/3/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "LoginManager.h"
#import "RegisterViewController.h"
#import "ContactsManager.h"

@interface LoginViewController ()<UITextFieldDelegate>

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
//    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSLog(@"沙盒：%@",path);
    

    if (![[LoginManager shareManager] isFirstLogin]) {
        [[LoginManager shareManager] autoLogin];
        
        return;
    }
    
    // init data
    
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(80);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_accountContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarView.mas_bottom).offset(30);
        make.left.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    
    [_passwordContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountContainerView.mas_bottom).offset(15);
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
    // 添加阴影
    _avatarView.layer.shadowColor = [UIColor grayColor].CGColor;
    _avatarView.layer.shadowOffset = CGSizeMake(3, 3);
    _avatarView.layer.shadowOpacity = 0.8;

    [self.view addSubview:_avatarView];
    
    _accountContainerView = [[UIView alloc] init];
    _accountText = [self creatTextInputFieldWith:@"账号" placeholder:@"请填写账号" containerView: _accountContainerView];
    _accountText.delegate = self;
    _accountText.keyboardType = UIKeyboardTypeAlphabet;
    
    _passwordContainerView = [[UIView alloc] init];
    _passwordText = [self creatTextInputFieldWith:@"密码" placeholder:@"请填写密码" containerView:_passwordContainerView];
    _passwordText.delegate = self;
    _passwordText.secureTextEntry = YES;
    
    [self.view addSubview:_accountContainerView];
    [self.view addSubview:_passwordContainerView];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn_nor"] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn_hlt"] forState:UIControlStateHighlighted];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _loginBtn];
    
    _loginIssueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginIssueBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_loginIssueBtn setTitleColor:WJRGBColor(70, 87, 131) forState:UIControlStateNormal];
    _loginIssueBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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
    textField.returnKeyType = UIReturnKeyNext;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, 50-0.5, SCREEN_WIDTH-20, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:textField];
    [containerView addSubview:line];

    return textField;
    
}

#pragma mark - init data

- (void)initData{

    // 用户头像
    
    NSString * url = [WJUserDefault objectForKey:kAvatarUrl];
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"avatarBoy"]];
    
    _accountText.text = [WJUserDefault objectForKey: kAccount];
    
}

#pragma mark - testField delegate

- (void)textFieldDidChanged:(UITextField *)textField{

    if (_accountText.text.length > 0 && _passwordText.text.length > 0) {
        _accountText.returnKeyType = UIReturnKeyDone;
        _passwordText.returnKeyType = UIReturnKeyDone;
        

    }else{
    
        _accountText.returnKeyType = UIReturnKeyNext;
        _passwordText.returnKeyType = UIReturnKeyNext;

    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (_accountText.text.length > 0 && _passwordText.text.length > 0) {
        [self.view endEditing:YES];
        return NO;
    }else {
    
        if ([_accountText isFirstResponder]) {
            
            [_accountText resignFirstResponder];
            [_passwordText becomeFirstResponder];
            return  YES;
            
        }else{
            
            [_passwordText resignFirstResponder];
            [_accountText becomeFirstResponder];
            return YES;
        }
    }
    
}

#pragma mark - actions

- (void)loginBtnDidClick:(UIButton *)btn{

    [self.view endEditing:YES];
    
    if (!(self.accountText.text.length > 0)) {
        [MBProgressHUD showLabelWithText:@"账号不能为空"];
        return;
    }
    if (!(self.passwordText.text.length > 0)) {
        [MBProgressHUD showLabelWithText:@"密码不能为空"];
        return;
    }
    
    // 登录
    
    [[LoginManager shareManager] loginWithAccount:self.accountText.text password:self.passwordText.text completionHandler:^{
        
        //处理业务逻辑
        
        //更新UI
        
        MainTabBarController * tabBarVc = [[MainTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
        
    }];
}

- (void)loginIssusBtnDidClick:(UIButton *)btn{
   // 注册
    RegisterViewController * registerVc = [[RegisterViewController alloc] init];
    WJWeakSelf(weakSelf);
    registerVc.completion = ^(NSString *account, NSString *password) {
        weakSelf.accountText.text = account;
        weakSelf.passwordText.text = password;
    };
    [self presentViewController:registerVc animated:YES completion:nil];
}

- (void)moreBtnDidClick:(UIButton *)btn{
    NSLog(@"更多");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end


