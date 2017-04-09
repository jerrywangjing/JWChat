//
//  ModifyUserCommentViewController.m
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/11/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ModifyUserCommentViewController.h"
#import "ContactsModel.h"

@interface ModifyUserCommentViewController ()<UITextFieldDelegate>

@property (nonatomic,weak)UITextField * field;
@end

@implementation ModifyUserCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改备注";
    self.view.backgroundColor = IMBgColor;
    
    UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick)];
    self.navigationItem.rightBarButtonItem = done;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // sutup subViews
    [self setupSubviews];
}

-(void)setupSubviews{

    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarH+15, SCREEN_WIDTH, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIView * topBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topBorderView.backgroundColor = [UIColor lightGrayColor];
    UIView * bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 44-0.5, SCREEN_WIDTH, 0.5)];
    bottomBorderView.backgroundColor = [UIColor lightGrayColor];
    
    [bgView addSubview:topBorderView];
    [bgView addSubview:bottomBorderView];
    [self.view addSubview:bgView];
    
    UILabel * title = [[UILabel alloc] init];
    title.text = @"备注名：";
    title.font = [UIFont systemFontOfSize:15];
    UITextField * field = [[UITextField alloc] init];
    _field = field;
    field.text = self.user.userComment ? self.user.userComment:self.user.userName;
    field.font = [UIFont systemFontOfSize:14];
    field.textColor = [UIColor darkGrayColor];
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.delegate = self;
    field.returnKeyType = UIReturnKeyDone;
    
    [bgView addSubview: title];
    [bgView addSubview:field];
    // 布局
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right);
        make.centerY.equalTo(bgView.mas_centerY);
        make.right.equalTo(bgView.mas_right);
    }];
}

-(void)doneBtnClick{

    if (self.field.isFirstResponder) {
        [self.field resignFirstResponder];
    }
    
    [ContactsManager changeMyBaseInfoWithName:@"测试001-修改" orgId:@"#0" signatureStr:@"001签名-修改" andCurrentUser:self.user];
    
    // 插入备注到数据库
    
    BOOL  success = [[DBManager shareManager] updateContactsInfoWithUserId:self.user.userId ColumuName:@"userComment" value:self.field.text];
    if (success) {
        
        self.modifyCallback(self.field.text);
        
        // 提交到服务器
        [ContactsManager changeFriendCommentName:self.field.text andUserId:_user.userId];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
    
        [MBProgressHUD showLabel:@"修改失败" toView:self.view];
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

    if (textField.text.length > 0) {
        if (!self.navigationItem.rightBarButtonItem.isEnabled) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

@end
