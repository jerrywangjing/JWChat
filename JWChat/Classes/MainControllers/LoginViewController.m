//
//  LoginViewController.m
//  JWChat
//
//  Created by JerryWang on 2017/3/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"
#import <NIMSDK/NIMSDK.h>


static NSString * const kAccount = @"account";
static NSString * const kPassword = @"password";

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
    // 是否已登录过
    if ([WJUserDefault valueForKey:kAccount] && [WJUserDefault valueForKey:kPassword]) {
        
        self.accountText.text = [WJUserDefault valueForKey:kAccount];
        self.passwordText.text = [WJUserDefault valueForKey:kPassword];
    }
//    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSLog(@"沙盒：%@",path);
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
    _avatarView.image = [UIImage imageNamed:@"avatarBoy"];
    [self.view addSubview:_avatarView];
    
    _accountLabel = [[UILabel alloc] init];
    _accountLabel.font = [UIFont boldSystemFontOfSize:16];
    _accountLabel.textColor = [UIColor blackColor];
    _accountLabel.textAlignment = NSTextAlignmentCenter;
    _accountLabel.text = @"+86 15108496988";
    [self.view addSubview:_accountLabel];
    

    _accountContainerView = [[UIView alloc] init];
    _accountText = [self creatTextInputFieldWith:@"账号" placeholder:@"请填写账号" containerView: _accountContainerView];
    _accountText.delegate = self;
    
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
    textField.returnKeyType = UIReturnKeyNext;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, 50-0.5, SCREEN_WIDTH-20, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:textField];
    [containerView addSubview:line];

    return textField;
    
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
    
    [DataManager loginWithUsername:self.accountText.text password:self.passwordText.text success:^(NSDictionary *responseDic) {

        NSString *result = responseDic[@"result"];
        NSString *msg = responseDic[@"msg"];
        NSString *token = responseDic[@"NIMToken"];
        
        if ([result isEqualToString:@"1"]) {
            
            if (token) {
                //初始化NIM引擎
                
<<<<<<< HEAD
                [[NIMSDK sharedSDK].loginManager login:self.accountText.text token:token completion:^(NSError * _Nullable error) {
                    
                    if (!error) {
                        
                        //保存登录数据
                        
                        //处理业务逻辑
                        
                        //更新UI
                        MainTabBarController * tabBarVc = [[MainTabBarController alloc] init];
                        
                        [self presentViewController:tabBarVc animated:NO completion:^{
                            [WJUserDefault setObject:self.accountText.text forKey:kAccount];
                            [WJUserDefault setObject:self.passwordText.text forKey:kPassword];
                            [WJUserDefault synchronize];
                            [self removeFromParentViewController];
                        }];
                        
                    }else{
                        NSLog(@"NIM引擎登录失败：error:%@",error.localizedDescription);
                        [MBProgressHUD showLabelWithText:@"登录失败"];
                    }
                    
=======
                
                //直接跳转
                MainTabBarController * tabBarVc = [[MainTabBarController alloc] init];
                
                [self presentViewController:tabBarVc animated:NO completion:^{
                    [WJUserDefault setObject:self.accountText.text forKey:kAccount];
                    [WJUserDefault setObject:self.passwordText.text forKey:kPassword];
                    [WJUserDefault synchronize];
                    [self removeFromParentViewController];
>>>>>>> 6c8c3453cde2ce38c83ff8b2cc8fc1ed6bb1b700
                }];

            }
            
        }else{
        
            [MBProgressHUD showLabelWithText:msg];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showLabelWithText:@"登录失败"];
    }];
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


