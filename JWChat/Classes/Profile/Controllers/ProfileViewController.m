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
#import "ProfileCellModel.h"
#import "EditUserInfoViewController.h"

static const CGFloat HeaderHeight = 15;

@interface ProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

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

-(void)loadView {
    
    [super loadView];
    
    [self setupSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
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
                                            ImageUrl : user.userInfo.avatarUrl ? user.userInfo.avatarUrl : @"",
                                            Title : user.userInfo.nickName,
                                            SubTitle : user.userId,
                                            
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
    
    if (indexPath.section == 1) {
        baseCell.model = [ProfileCellModel cellModelWithDic:dataArr.firstObject];
        return baseCell;
    }
    
    if (indexPath.section == 2) {
        baseCell.model = [ProfileCellModel cellModelWithDic:dataArr.firstObject];
        return baseCell;
    }
    
    if (indexPath.section == 3) {
        baseCell.model = [ProfileCellModel cellModelWithDic:dataArr[indexPath.row]];
        return baseCell;
    }
    
    return [UITableViewCell new];
    
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
        }
        if (indexPath.row == 1) {
            // 关于页面
        }
    }
    
}


@end
