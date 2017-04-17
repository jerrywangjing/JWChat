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

typedef NS_ENUM(NSUInteger, UserType) {
    UserTypeIsMe,
    UserTypeIsMyFriend,
    UserTypeUnKnownUser,
};

@interface ContactsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
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
    
    self.user = [[NIMSDK sharedSDK].userManager userInfo:currentUserId];
    
}

- (void)setupTableView{

    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = IMBgColor;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
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
        
        [addOrdeleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_nor"] forState:UIControlStateNormal];
        [addOrdeleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_hlt"] forState:UIControlStateHighlighted];
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
    
    if (self.currentUserType != UserTypeIsMe) {
        tableView.tableFooterView = headView;
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
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 90;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ContactsDetailTableViewCell * detailCell = [ContactsDetailTableViewCell contactsCellWithTableView:tableView];
    
    static NSString * cellId = @"detailCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        
        detailCell.user = self.user;
        
        // border view
        UIView * topBorder = [UIView cellTopBorderView];
        [cell.contentView addSubview:topBorder];
        UIView * bottomBorder = [UIView cellBottomBorderView:90];
        [cell.contentView addSubview:bottomBorder];
        
        return detailCell;
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"设置备注";
    }
    
    if (indexPath.section == 2) {
        cell.textLabel.text = @"消息提醒";
        
        UISwitch * notifySwich = [[UISwitch alloc] init];
        notifySwich.on = self.needNotify;
        [notifySwich addTarget:self action:@selector(nofifySwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = notifySwich;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 3) {
        cell.textLabel.text = @"黑名单";
        
        UISwitch * blactListSwitch = [[UISwitch alloc] init];
        blactListSwitch.on = self.inBlactList;
        [blactListSwitch addTarget:self action:@selector(blackListSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.accessoryView = blactListSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // border view
    UIView * topBorder = [UIView cellTopBorderView];
    [cell.contentView addSubview:topBorder];
    UIView * bottomBorder = [UIView cellBottomBorderView:44];
    [cell.contentView addSubview:bottomBorder];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        ModifyUserCommentViewController * modifyVc = [[ModifyUserCommentViewController alloc] init];
        modifyVc.user = self.contactModel;
        modifyVc.modifyCallback = ^(NSString * comment){
            self.contactModel.userComment = comment;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:modifyVc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


#pragma mark - actions

-(void)sendMsgBtnClick:(UIButton *)btn{
    
    if ([self.previousVc isKindOfClass:[ChatRoomViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    //跳转到聊天界面
    
    UIViewController  * rootVieweController = [UIApplication sharedApplication].keyWindow.rootViewController;

    if ([rootVieweController.presentedViewController isKindOfClass:[UITabBarController class]]) {
        MainTabBarController * tabBarVc = (MainTabBarController *)rootVieweController.presentedViewController;
        tabBarVc.selectedIndex = 0;
        
        for (UINavigationController * vc in tabBarVc.viewControllers) {
            if ([vc.visibleViewController isKindOfClass:[ConversationViewController class]]) {
                ConversationViewController * converVc = (ConversationViewController *)vc.visibleViewController;
                
                ChatRoomViewController * chatRoom = [[ChatRoomViewController alloc] init];
                chatRoom.hidesBottomBarWhenPushed  = YES;
                chatRoom.contact = self.contactModel;
                
                [converVc.navigationController pushViewController:chatRoom animated:YES];
                
            }
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES]; // 一定在跳转到聊天页面后pop，不然会被提前销毁
 
}

- (void)addOrDeleteBtnClick:(UIButton *)btn{

    
}
- (void)nofifySwitchChanged:(UISwitch *)switchBtn{

    if (switchBtn.on) {
        NSLog(@"需要消息提醒");
    }else{
    
        NSLog(@"关闭消息提醒");
    }
}

- (void)blackListSwitchChanged:(UISwitch *)switchBtn{

    if (switchBtn.on) {
        NSLog(@"在黑名单中");
    }else{
    
        NSLog(@"不在黑名单中");
    }
}
@end
