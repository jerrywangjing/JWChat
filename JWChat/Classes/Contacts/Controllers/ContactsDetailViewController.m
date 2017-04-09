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

@interface ContactsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak,nonatomic)UITableView * tableView;
@end

@implementation ContactsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";
    
    //setup tableView
    [self setupTableView];
}


-(void)setupTableView{

    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = IMBgColor;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:tableView];
    
    // tableFooter View
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    headView.backgroundColor = [UIColor clearColor];
    UIButton * sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sendMsgBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_nor"] forState:UIControlStateNormal];
    [sendMsgBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_hlt"] forState:UIControlStateHighlighted];
    [sendMsgBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    sendMsgBtn.layer.cornerRadius = 3;
    sendMsgBtn.layer.masksToBounds = YES;
    [sendMsgBtn addTarget:self action:@selector(sendMsgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:sendMsgBtn];
    tableView.tableFooterView = headView;
    // 布局
    [sendMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headView);
    }];
    
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
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

    if (indexPath.section == 0) {
        ContactsDetailTableViewCell * cell = [ContactsDetailTableViewCell contactsCellWithTableView:tableView];
        cell.cellData = self.contactModel;
        // border view
        UIView * topBorder = [UIView cellTopBorderView];
        [cell.contentView addSubview:topBorder];
        UIView * bottomBorder = [UIView cellBottomBorderView:90];
        [cell.contentView addSubview:bottomBorder];
        
        return cell;
    }
    static NSString * cellId = @"detailCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"设置备注";
    
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
@end
