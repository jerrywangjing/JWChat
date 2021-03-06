//
//  ContactsDetailViewController.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ContactsDetailViewController.h"
#import "ContactsModel.h"
#import "ContactsDetailTableViewCell.h"
#import "ChatRoomViewController.h"
#import "ModifyUserCommentViewController.h"
#import "ConversationViewController.h"
#import "MainTabBarController.h"
#import "UserInfoTableViewCell.h"
#import "ProfileCellModel.h"

typedef NS_ENUM(NSUInteger, UserType) {
    UserTypeIsMe,
    UserTypeIsMyFriend,
    UserTypeUnKnownUser,
};

@interface ContactsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,strong) NIMUser *user;
@property (nonatomic,assign) UserType currentUserType;
@property (nonatomic,assign,) BOOL needNotify;
@property (nonatomic,assign) BOOL inBlactList;

@end

@implementation ContactsDetailViewController

-(instancetype)initWithUserId:(NSString *)userId{

    if (self = [super initWithNibName:nil bundle:nil]) {
        _userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详细资料";
    
    //configData
    [self configData];
    
    //setup tableView
    [self setupTableView];
    
}

- (void)configData{

    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    BOOL isMyFriend = [[NIMSDK sharedSDK].userManager isMyFriend:self.userId];

    if ([self.userId isEqualToString:currentUserId]) {
        self.currentUserType = UserTypeIsMe;
        
    } else if (isMyFriend){
    
        self.currentUserType = UserTypeIsMyFriend;
    }else{
    
        self.currentUserType = UserTypeUnKnownUser;
    }

    
    if ([[NIMSDK sharedSDK].userManager isUserInBlackList:self.userId]) {
        self.inBlactList = YES;
    }
    if ([[NIMSDK sharedSDK].userManager notifyForNewMsg:self.userId]) {
        self.needNotify = YES;
    }
    
    _user = [[NIMSDK sharedSDK].userManager userInfo:self.userId];
    
    self.dataSource = _dataSource = @[
                                      @{
                                          HeaderTitle : @"",
                                          RowContent  : @[
                                                  @{
                                                      ImageUrl : [ContactsManager getAvatarUrl:_user],
                                                      Title : [ContactsManager getUserName:_user],
                                                      SubTitle : _user.userId,
                                                      @"gender" : @([ContactsManager getGender:_user]),
                                                      
                                                      },
                                                  ],
                                          FooterTitle :@"",
                                          
                                          },
                                      @{
                                          HeaderTitle : @"",
                                          RowContent : @[
                                                  @{
                                                      
                                                      Title : @"设置备注",
                                                      SubTitle : @"",
                                                      }
                                                  ],
                                          FooterTitle : @"",
                                          
                                          },
                                      
                                      @{
                                          HeaderTitle : @"",
                                          RowContent : @[
                                                  
                                                  @{
                                                      Title : @"消息提醒",
                                                      SubTitle : @"",
                                                      
                                                      },
                                                  ],
                                          FooterTitle : @""
                                          
                                          },
                                      @{
                                          HeaderTitle : @"",
                                          RowContent : @[
                                                  
                                                  @{
                                                      Title : @"黑名单",
                                                      SubTitle : @"",
                                                      
                                                      },
                                               
                                                  ],
                                          FooterTitle : @""
                                          
                                          },
                                      
                                      ];

    
}

- (void)setupTableView{

    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = IMBgColor;
    //tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:tableView];
    
    // tableFooter View
    
    // send msg btn
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIButton * sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sendMsgBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_nor"] forState:UIControlStateNormal];
    [sendMsgBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_hlt"] forState:UIControlStateHighlighted];
    [sendMsgBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    sendMsgBtn.layer.cornerRadius = 3;
    sendMsgBtn.layer.masksToBounds = YES;
    [sendMsgBtn addTarget:self action:@selector(sendMsgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // addUser or deleteUser btn
    
    UIButton * addOrdeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (self.currentUserType == UserTypeIsMyFriend) {
        
        [addOrdeleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn_nor"] forState:UIControlStateNormal];
        [addOrdeleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn_hlt"] forState:UIControlStateHighlighted];
        [addOrdeleteBtn setTitle:@"删除好友" forState:UIControlStateNormal];
        [addOrdeleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    if (self.currentUserType == UserTypeUnKnownUser) {
        
        [addOrdeleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_nor"] forState:UIControlStateNormal];
        [addOrdeleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_hlt"] forState:UIControlStateHighlighted];
        [addOrdeleteBtn setTitle:@"添加好友" forState:UIControlStateNormal];
        [addOrdeleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    
    addOrdeleteBtn.layer.cornerRadius = 3;
    addOrdeleteBtn.layer.masksToBounds = YES;
    
    [addOrdeleteBtn addTarget:self action:@selector(addOrDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:sendMsgBtn];
    [headView addSubview:addOrdeleteBtn];
    tableView.tableFooterView = headView;
    
    // 修改按钮显示逻辑
    if (self.currentUserType == UserTypeIsMe) {
        headView.hidden = YES;
    }
    if (self.currentUserType == UserTypeUnKnownUser) {
        sendMsgBtn.hidden = YES;
    }
    
    // 布局
    [sendMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.topMargin.mas_equalTo(20);
    }];
    
    [addOrdeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.top.equalTo(sendMsgBtn.mas_bottom).offset(15);
    }];
    
}


#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (self.currentUserType == UserTypeIsMe) {
        return 1;
    }
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSArray * rowCount = self.dataSource[section][RowContent];
    return rowCount.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 100;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UserInfoTableViewCell * detailCell = [UserInfoTableViewCell userInfoCellWithTableView:tableView];
    
    static NSString * cellId = @"detailCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray * dataArr = self.dataSource[indexPath.section][RowContent];
    
    if (indexPath.section == 0) {
        
        ProfileCellModel * model = [ProfileCellModel cellModelWithDic:dataArr.firstObject];
        detailCell.model = model;
        detailCell.showArrowView = NO;
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return detailCell;
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = dataArr.firstObject[Title];
    }
    
    if (indexPath.section == 2) {
        cell.textLabel.text = dataArr.firstObject[Title];;
        
        UISwitch * notifySwich = [[UISwitch alloc] init];
        notifySwich.on = self.needNotify;
        [notifySwich addTarget:self action:@selector(nofifySwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = notifySwich;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 3) {
        cell.textLabel.text = dataArr.firstObject[Title];;
        
        UISwitch * blactListSwitch = [[UISwitch alloc] init];
        blactListSwitch.on = self.inBlactList;
        [blactListSwitch addTarget:self action:@selector(blackListSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.accessoryView = blactListSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        ModifyUserCommentViewController * modifyVc = [[ModifyUserCommentViewController alloc] init];
        modifyVc.user = self.user;
        modifyVc.modifyCallback = ^(NSString * comment){
            self.user.alias = comment;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:modifyVc animated:YES];
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)refreshData{

    [self configData];
    [self.tableView reloadData];

}
#pragma mark - actions

-(void)sendMsgBtnClick:(UIButton *)btn{
    
    if ([self.previousVc isKindOfClass:[ChatRoomViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    //跳转到聊天界面
    
    UIViewController  * rootVieweController = [UIApplication sharedApplication].keyWindow.rootViewController;

    if ([rootVieweController isKindOfClass:[UITabBarController class]]) {
        MainTabBarController * tabBarVc = (MainTabBarController *)rootVieweController;
        tabBarVc.selectedIndex = 0;
        
        for (UINavigationController * vc in tabBarVc.viewControllers) {
            if ([vc.visibleViewController isKindOfClass:[ConversationViewController class]]) {
                ConversationViewController * converVc = (ConversationViewController *)vc.visibleViewController;
                
                ChatRoomViewController * chatRoom = [[ChatRoomViewController alloc] init];
                chatRoom.hidesBottomBarWhenPushed  = YES;
                chatRoom.user = self.user;
                
                [converVc.navigationController pushViewController:chatRoom animated:YES];
                
            }
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES]; // 一定在跳转到聊天页面后pop，不然会被提前销毁
 
}

- (void)addOrDeleteBtnClick:(UIButton *)btn{

    if (self.currentUserType == UserTypeUnKnownUser) {
        // 添加好友
        
        NIMUserRequest * userRequest = [[NIMUserRequest alloc] init];
        userRequest.userId = self.userId;
        userRequest.operation = NIMUserOperationAdd;
        [MBProgressHUD showHUD];
        [[NIMSDK sharedSDK].userManager requestFriend:userRequest completion:^(NSError * _Nullable error) {
            [MBProgressHUD hideHUD];
            if (!error) {
                [MBProgressHUD showLabelWithText:@"添加成功"];
                
                [self refreshData];
            }else{
            
                [MBProgressHUD showLabelWithText:@"添加失败"];
            }
        }];
        
    }else{
        
        __weak typeof(self) weakSelf = self;
        // 删除好友
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确认删除好友%@吗？",self.user.userInfo.nickName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            // 删除本地数据库联系人记录
            BOOL success = [[DBManager shareManager] deleteContactsRecordWithUserId:weakSelf.userId];
            if (!success) {
                NSLog(@"本地联系人删除失败");
            }

            // 通知服务器解除好友关系
            [[NIMSDK sharedSDK].userManager deleteFriend:weakSelf.userId completion:^(NSError * _Nullable error) {
                if (!error) {
                    [MBProgressHUD showLabelWithText:@"删除成功"];
                    [self refreshData];
                }else{
                
                    [MBProgressHUD showLabelWithText:@"删除失败"];
                }
            }];

        }];
        
        [alertVc addAction:cancel];
        [alertVc addAction:confirm];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    
}
- (void)nofifySwitchChanged:(UISwitch *)switchBtn{

    [[NIMSDK sharedSDK].userManager updateNotifyState:switchBtn.on forUser:self.userId completion:^(NSError * _Nullable error) {
        if (error) {
            [MBProgressHUD showLabelWithText:@"操作失败"];
            [self refreshData];
            NSLog(@"修改失败Error：%@",error);
        }
    }];
}

- (void)blackListSwitchChanged:(UISwitch *)switchBtn{

    if (switchBtn.on) {
        NSLog(@"加入黑名单");
    }else{
    
        NSLog(@"移除黑名单");
    }
}

@end
