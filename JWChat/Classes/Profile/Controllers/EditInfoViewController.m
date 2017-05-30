//
//  EditInfoViewController.m
//  JWChat
//
//  Created by jerry on 2017/4/21.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "EditInfoViewController.h"
#import "NTESBirthPickerView.h"

@interface EditInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,strong) UITextField * textField;
//@property (nonatomic,assign) NSInteger limitedLength;

@end

@implementation EditInfoViewController

#pragma mark - init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // set default values
        
    }
    return self;
}

- (void)loadView{

    [super loadView];
    
    [self setupSubviews];
}

- (void)dealloc{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavTitle];
    
    _dataSource = [self configData];
    
//    for (UITableViewCell *cell in self.tableView.visibleCells) {
//        for (UIView *subView in cell.subviews) {
//            if ([subView isKindOfClass:[UITextField class]]) {
//                [subView becomeFirstResponder];
//                break;
//            }
//        }
//    }

    
}

- (NSArray *)configData{

    if (_editType == EditInfoTypeNickName) {
        return @[
                    @{
                        HeaderTitle : @"",
                        RowContent : @[
                                
                                    @{
                                        Title : [ContactsManager getNickName:_user],
                                        },
                                ],
                        FooterTitle : @"好的昵称可以让你的朋友更容易记住你",
                        
                        }
                    ];
    }
    
    if (_editType == EditInfoTypeGender) {
        return @[
                 @{
                     HeaderTitle : @"",
                     RowContent : @[
                             
                             @{
                                 Title : @"男",
                                 SubTitle : [ContactsManager getGender:_user] == NIMUserGenderMale ? @1:@0,
                                 },
                             @{
                                 Title : @"女",
                                 SubTitle : [ContactsManager getGender:_user] == NIMUserGenderFemale ? @1:@0,
                                 },
                             @{
                                 Title : @"其他",
                                 SubTitle : [ContactsManager getGender:_user] == NIMUserGenderUnknown ? @1:@0,
                                 },
                             ],
                     FooterTitle : @"",
                     
                     }
                 ];
    }
    
    if (_editType == EditInfoTypeBirthday) {
        return @[
                 @{
                     HeaderTitle : @"",
                     RowContent : @[
                             
                             @{
                                 Title : @"生日",
                                 SubTitle : [ContactsManager getBirthday:_user],
                                 },
                             ],
                     FooterTitle : @"",
                     
                     }
                 ];
    }
    
    if (_editType == EditInfoTypePhoneNumber) {
        return @[
                 @{
                     HeaderTitle : @"",
                     RowContent : @[
                             
                             @{
                                 Title : [ContactsManager getPhoneNumber:_user],
                                 },
                             ],
                     FooterTitle : @"",
                     
                     }
                 ];
    }
    if (_editType == EditInfoTypeEmail) {
        return @[
                 @{
                     HeaderTitle : @"",
                     RowContent : @[
                             
                             @{
                                 Title : [ContactsManager getEmail:_user],
                                 },
                             ],
                     FooterTitle : @"",
                     
                     }
                 ];
    }
    if (_editType == EditInfoTypeSign) {
        return @[
                 @{
                     HeaderTitle : @"",
                     RowContent : @[
                             
                             @{
                                 Title : [ContactsManager getSign:_user],
                                 },
                             ],
                     FooterTitle : @"",
                     
                     }
                 ];
    }
    
    return @[];
}

- (void)setupNavTitle{

    switch (_editType) {
        case EditInfoTypeNickName:
            self.navigationItem.title = @"昵称";
            break;
        case EditInfoTypeGender:
            self.navigationItem.title = @"性别";
            break;
        case EditInfoTypeBirthday:
            self.navigationItem.title = @"选择出生日期";
            break;
        case EditInfoTypePhoneNumber:
            self.navigationItem.title = @"手机号码";
            break;
        case EditInfoTypeEmail:
            self.navigationItem.title = @"邮箱";
            break;
        case EditInfoTypeSign:
            self.navigationItem.title = @"签名";
            break;
            
        default:
            break;
    }
}

- (void)setupSubviews{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = IMBgColor;
    [self.view addSubview:_tableView];
    
}

- (void)viewWillLayoutSubviews{

    [super viewWillLayoutSubviews];
    
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * rowsArr = self.dataSource[section][RowContent];
    
    return rowsArr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.dataSource[section][HeaderTitle];
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    return self.dataSource[section][FooterTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.editType == EditInfoTypeNickName) {
        return 30;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_editType == EditInfoTypeBirthday) {
        
        UITableViewCell * birthCell = [self creatBirthCell:tableView indexPath:indexPath];
        return birthCell;
    }
    if (_editType == EditInfoTypeGender) {
        UITableViewCell * genderCell = [self creatGenderCell:tableView indexPath:indexPath];
        return genderCell;
    }
    
    UITableViewCell * textCell = [self creatTextFieldCell:tableView indexPath:indexPath];
    
    return textCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_editType == EditInfoTypeGender) {
        
        for (UIView * view in cell.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton * btn = (UIButton *)view;
                btn.selected = !btn.selected;
                
                [self updateUserGenderWithBtnTag:btn.tag];
                break;
            }
        }
    }
    
    if (_editType == EditInfoTypeBirthday) {
        
        for (UIView * view in cell.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel * label = (UILabel *)view;
                
                NTESBirthPickerView * birthPicker = [[NTESBirthPickerView alloc] init];
                [birthPicker showInView:self.tableView onCompletion:^(NSString *birth) {
                    NSLog(@"选择日期：%@",birth);
                    label.text = birth;
                    [self updateUserInfoWithTag:NIMUserInfoUpdateTagBirth value:birth];
                }];
                break;
            }
        }
    }
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (!textField.text.length) {
        [MBProgressHUD showLabelWithText:@"输入不能为空"];
        return NO;
    }
    
    NIMUserInfoUpdateTag tag = 0;
    
    switch (_editType) {
        case EditInfoTypeNickName:
            tag = NIMUserInfoUpdateTagNick;
            break;
        case EditInfoTypePhoneNumber:
            tag = NIMUserInfoUpdateTagMobile;
            break;
        case EditInfoTypeEmail:
            tag = NIMUserInfoUpdateTagEmail;
            break;
        case EditInfoTypeSign:
            tag = NIMUserInfoUpdateTagSign;
            break;
        default:
            break;
    }
    [self updateUserInfoWithTag:tag value:textField.text];
    
    return YES;
}


#pragma mark - private

- (UITableViewCell *)creatTextFieldCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{

    static NSString * textCellId = @"testCellId";
    
    UITableViewCell * textCell = [tableView dequeueReusableCellWithIdentifier:textCellId];
    if (!textCell) {
        
        textCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellId];
        
        UITextField * field = [[UITextField alloc] init];
        field.text = self.dataSource[indexPath.section][RowContent][indexPath.row][Title];
        field.textColor = [UIColor grayColor];
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.delegate = self;
        field.returnKeyType = UIReturnKeyDone;
        field.placeholder = @"请输入修改内容";
        [field becomeFirstResponder];
        
        [textCell.contentView addSubview:field];
        textCell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 布局
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(textCell);
            make.left.equalTo(textCell).offset(15);
            make.right.equalTo(textCell).offset(-15);
        }];
        
    }
    
    return textCell;
}

- (UITableViewCell *)creatBirthCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    static NSString * birthCellId = @"birthCellId";
    
    UITableViewCell * birthCell = [tableView dequeueReusableCellWithIdentifier:birthCellId];
    
    NSDictionary * data = self.dataSource[indexPath.section][RowContent][indexPath.row];
    
    if (!birthCell) {
        birthCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:birthCellId];
        
        UILabel * label = [[UILabel alloc] init];
        label.text = data[SubTitle];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentRight;
        label.size = CGSizeMake(SCREEN_WIDTH/2, birthCell.height);
        birthCell.accessoryView = label;
    }

    birthCell.textLabel.text = data[Title];
    
    return birthCell;
}

- (UITableViewCell *)creatGenderCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{

    static NSString * genderCellId = @"genderCellId";
    
    UITableViewCell * genderCell = [tableView dequeueReusableCellWithIdentifier:genderCellId];
    
    NSDictionary * data = self.dataSource[indexPath.section][RowContent][indexPath.row];
    
    if (!genderCell) {
        
        genderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:genderCellId];
        
        UIButton * checkbox = [UIButton buttonWithType:UIButtonTypeCustom];

        [checkbox setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_unselected"] forState:UIControlStateNormal];
        [checkbox setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:UIControlStateSelected];
        checkbox.size = checkbox.currentBackgroundImage.size;
        checkbox.selected = [data[SubTitle] isEqual: @1] ? YES : NO;
        checkbox.tag = indexPath.row;
        [checkbox addTarget:self action:@selector(checkboxDidClick:) forControlEvents:UIControlEventTouchUpInside];
        genderCell.accessoryView = checkbox;
    }
    genderCell.textLabel.text = data[Title];
    
    return genderCell;
}


- (void)checkboxDidClick:(UIButton *)btn{

    btn.selected = !btn.selected;
    [self updateUserGenderWithBtnTag:btn.tag];
}

- (void)updateUserInfoWithTag:(NIMUserInfoUpdateTag)tag value:(NSString *)value {
    
    // 提交修改
    WJWeakSelf(weakSelf);
    [MBProgressHUD showHUD];
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(tag) : value } completion:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUD];
        if (!error) {
            weakSelf.completion();
            [MBProgressHUD showTipHUD:@"设置成功"];
            
        }else{
            [MBProgressHUD showTipHUD:@"设置失败"];
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)updateUserGenderWithBtnTag:(NSInteger)tag{

    NIMUserGender gender = 0;
    switch (tag) {
        case 0:
            gender = NIMUserGenderMale;
            break;
        case 1:
            gender = NIMUserGenderFemale;
            break;
        case 2:
            gender = NIMUserGenderUnknown;
            break;
        default:
            break;
    }
    
    WJWeakSelf(weakSelf);
    [MBProgressHUD showHUD];
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagGender) : @(gender)} completion:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUD];
        if (!error) {
            weakSelf.completion();
            [MBProgressHUD showLabelWithText:@"设置成功"];
            
        }else{
            [MBProgressHUD showLabelWithText:@"设置失败，请重试"];
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

@end
