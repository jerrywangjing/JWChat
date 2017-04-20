//
//  ProfileViewController.m
//  JWChat
//
//  Created by jerry on 17/4/1.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "ProfileViewController.h"
#import "BaseTableViewCell.h"
#import "UserInfoTableViewCell.h"
#import "LogoutBtnCell.h"
#import "ProfileCellModel.h"
#import "EditUserInfoViewController.h"
#import "AboutViewController.h"

static const CGFloat HeaderHeight = 15;

@interface ProfileViewController ()<UITableViewDelegate,UITableViewDataSource,NIMUserManagerDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NIMUser * user;
@property (nonatomic,strong) NSArray * dataSource;

@end

@implementation ProfileViewController

#pragma mark - getter

-(NSArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

#pragma mark - init

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configData];
    }
    return self;
}

-(void)dealloc{

    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

-(void)loadView {
    
    [super loadView];
    
    [self setupSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)configData{
    
    NSString * userId = [[NIMSDK sharedSDK].loginManager currentAccount];
    NIMUser * user = [[NIMSDK sharedSDK].userManager userInfo:userId];
    _user = user;
    
    _dataSource = @[
                    @{
                        HeaderTitle : @"",
                        RowContent  : @[
                                        @{
                                            ImageUrl : [ContactsManager getAvatarUrl:user],
                                            Title : [ContactsManager getUserName:user],
                                            SubTitle : user.userId,
                                            @"gender" : @([ContactsManager getGender:user]),
                                            
                                         },
                                ],
                        FooterTitle :@"",
                        
                        },
                    @{
                        HeaderTitle : @"",
                        RowContent : @[
                                @{
                                    
                                    Title : @"消息提醒",
                                    SubTitle : [user notifyForNewMsg] ? @"已开启" : @"未开启"
                                    }
                                ],
                        FooterTitle : @"在iPhone的“设置-通知中心”功能，找到应用程序“JWChat”，可以更改新消息提醒设置",
                        
                        },
                    
                    @{
                        HeaderTitle : @"",
                        RowContent : @[
                                
                                @{
                                    Title : @"免打扰",
                                    SubTitle : @"未开启",
                                    
                                    },
                                ],
                        FooterTitle : @""
                        
                        },
                    @{
                        HeaderTitle : @"",
                        RowContent : @[
                                
                                @{
                                    Title : @"清空聊天记录",
                                    SubTitle : @"",
                                    
                                    },
                                @{
                                    
                                    Title : @"关于",
                                    SubTitle : @""
                                    }
                                ],
                        FooterTitle : @""
                        
                        },
                    @{
                        HeaderTitle : @"",
                        RowContent : @[
                                
                                @{
                                    Title : @"退出登录",
                                    SubTitle : @"",
                                    
                                    }
                                ]
                        
                        }
                    
                    ];
    
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
    return HeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 1) {
        return 50;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 100;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UserInfoTableViewCell * userInfoCell = [UserInfoTableViewCell userInfoCellWithTableView:tableView];
    BaseTableViewCell * baseCell = [BaseTableViewCell baseCellWithTableView:tableView];
    
    NSArray * dataArr = self.dataSource[indexPath.section][RowContent];
    
    if (indexPath.section == 0) {
        
        ProfileCellModel * model = [ProfileCellModel cellModelWithDic:dataArr.firstObject];
        userInfoCell.model = model;
        return userInfoCell;
    }

    if (indexPath.section == 4) { // 更新退出登录按钮的约束
        LogoutBtnCell * logoutCell = [LogoutBtnCell logoutcellWithTableView:tableView];
        logoutCell.model = [ProfileCellModel cellModelWithDic:dataArr.firstObject];
        return logoutCell;
    }
    
    baseCell.model = [ProfileCellModel cellModelWithDic:dataArr[indexPath.row]];
    
    return baseCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 跳转修改用户信心页面
        EditUserInfoViewController * editVc = [[EditUserInfoViewController alloc] initWithUser:self.user];
        [self.navigationController pushViewController: editVc animated:YES];
    }
    
    if (indexPath.section == 1) {
        // 消息提醒
    }
    
    if (indexPath.section == 2) {
        // 开启免打扰
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            // 清空聊天记录
            [self clearAllChatRecord];
        }
        if (indexPath.row == 1) {
            // 关于页面
            AboutViewController * about = [AboutViewController new];
            about.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:about animated:YES];
        }
    }
    
    if (indexPath.section == 4) {
        [self logout];
    }
    
}

#pragma mark - NIMUserDelegate

- (void)onUserInfoChanged:(NIMUser *)user{

    [self configData];
    [self.tableView reloadData];
}

#pragma mark - private

- (void)logout{

    [self showAlertViewWithTitle:@"退出当前账号？" message:nil style: UIAlertControllerStyleAlert completion:^(UIAlertAction *action) {
        if ([action.title isEqualToString:@"确定"]) {
            
            [MBProgressHUD showHUD];
            [[NIMSDK sharedSDK].loginManager logout:^(NSError * _Nullable error) {
                [MBProgressHUD hideHUD];
                if (!error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName: NTESNotificationLogout object: nil];
                }else{
                    
                    NSLog(@"注销失败");
                }
            }];
            
        }
    }];
}

- (void)clearAllChatRecord{

    [self showAlertViewWithTitle:nil message:@"确认清空所有聊天记录？" style:UIAlertControllerStyleAlert completion:^(UIAlertAction *action) {
        [MBProgressHUD showHUD];
        if ([action.title isEqualToString:@"确定"]) {
            BOOL success = [[DBManager shareManager] deleteAllMessageRecord];
            [MBProgressHUD hideHUD];
            if (!success) {
                [MBProgressHUD showLabelWithText:@"清除失败，请重试"];
            }else{
                [MBProgressHUD showLabelWithText:@"清除完成"];
            }
        }
    }];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)msg style:(UIAlertControllerStyle)style completion:(void(^)(UIAlertAction * action))completion{

    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        completion(action);
    }];
    [alertVc addAction:cancel];
    [alertVc addAction:confirm];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

@end
