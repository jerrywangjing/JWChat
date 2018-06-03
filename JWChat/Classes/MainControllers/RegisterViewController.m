//
//  RegisterViewController.m
//  JWChat
//
//  Created by JerryWang on 2017/5/25.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginManager.h"
#import "NTESDemoRegisterTask.h"
#import "NSString+WJExtension.h"
#import "NTESDemoService.h"

@interface RegisterViewController ()

@property (nonatomic,strong) UITextField * accountField;
@property (nonatomic,strong) UITextField * passwordField;
@property (nonatomic,strong) UITextField * nickNameField;
@property (nonatomic,strong) UIButton * registerBtn;
@end

@implementation RegisterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // init code
    }
    return self;
}

- (void)loadView{

    [super loadView];
    [self setupSubviews];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setupSubviews{

    // close btn
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // account
    UIView * accountView = [UIView new];
    _accountField = [self creatTextInputFieldWith:@"账号" placeholder:@"限20位字母或数字" containerView:accountView];
    // nickName
    UIView * nickNameView = [UIView new];
    _nickNameField = [self creatTextInputFieldWith:@"昵称" placeholder:@"限10位汉字、字母或数字" containerView:nickNameView];
    // password
    UIView * passwordView = [UIView new];
    _passwordField = [self creatTextInputFieldWith:@"密码" placeholder:@"6~20位字母或数字" containerView:passwordView];
    _passwordField.secureTextEntry = YES;
    // register btn
    UIButton * registerbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn = registerbtn;
    [registerbtn setBackgroundImage:[UIImage imageNamed:@"loginBtn_nor"] forState:UIControlStateNormal];
    [registerbtn setBackgroundImage:[UIImage imageNamed:@"loginBtn_hlt"] forState:UIControlStateHighlighted];
    [registerbtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerbtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerbtn.enabled = NO;
    
    // logoBtn
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"已有账号？直接登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:WJRGBColor(70, 87, 131) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginBtn addTarget:self action:@selector(logonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeBtn];
    [self.view addSubview:accountView];
    [self.view addSubview:nickNameView];
    [self.view addSubview:passwordView];
    [self.view addSubview:registerbtn];
    [self.view addSubview:loginBtn];
    
    // layout
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(25);
    }];
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    [nickNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nickNameView.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    [registerbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.mas_equalTo(40);
    }];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerbtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - actions

- (void)textFieldDidChange:(NSNotification *)noti{

    if (self.accountField.text.length > 0 && self.passwordField.text.length > 0 && self.nickNameField.text.length > 0) {
        self.registerBtn.enabled = YES;
    }else{
    
        self.registerBtn.enabled = NO;
    }
}
- (void)registerBtnClick:(UIButton *)btn{
    
    // 注册
    
    NTESRegisterData *data = [[NTESRegisterData alloc] init];
    data.account = _accountField.text;
    data.nickname= _nickNameField.text;
    data.token = [NSString Md5StringWithString:_passwordField.text];
    if (![self check]) {
        return;
    }
    [MBProgressHUD showHUD];
    
    [[NTESDemoService sharedService] registerUser:data
                                       completion:^(NSError *error, NSString *errorMsg) {
                                           [MBProgressHUD hideHUD];
                                           if (!error) {
                                               [MBProgressHUD showLabelWithText:@"注册成功"];
                                               if (self.completion) {
                                                   self.completion(_accountField.text, _passwordField.text);
                                               }
                                               [self dismissViewControllerAnimated:YES completion:nil];
                                           }
                                           
                                           else
                                           {
                                               [MBProgressHUD showLabelWithText:@"注册失败"];
                                               NSLog(@"error:%@",error.localizedDescription);
                                           }
                                           
                                       }];

}

- (void)logonBtnClick:(UIButton *)btn{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}
- (void)closeBtnClick:(UIButton *)btn{

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - private

- (UITextField *)creatTextInputFieldWith:(NSString *)title placeholder:(NSString *)placeholder containerView:(UIView *) containerView{
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 50)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = title;
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(250+15), 10, 250, 30)];
    textField.placeholder = placeholder;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:16];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeyNext;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, 50-0.5, SCREEN_WIDTH-40, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:textField];
    [containerView addSubview:line];
    
    return textField;
}

#pragma mark - private

- (BOOL)check{
    
    if (!self.checkAccount) {
        [MBProgressHUD showLabelWithText:@"账号长度有误"];
        return NO;
    }
    if (!self.checkPassword) {
        [MBProgressHUD showLabelWithText:@"密码长度有误"];
        return NO;
    }
    if (!self.checkNickname) {
        [MBProgressHUD showLabelWithText:@"昵称长度有误"];
        return NO;
    }
    return YES;
}

- (BOOL)checkAccount{
    NSString *account = [_accountField text];
    return account.length > 0 && account.length <= 20;
}

- (BOOL)checkPassword{
    NSString *checkPassword = [_passwordField text];
    return checkPassword.length >= 6 && checkPassword.length <= 20;
}

- (BOOL)checkNickname{
    NSString *nickname= [_nickNameField text];
    return nickname.length > 0 && nickname.length <= 10;
}

@end
