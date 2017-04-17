//
//  ChatInformationViewController.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/11/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ChatInformationViewController.h"
#import "ContactsModel.h"
#import "ContactTableViewCell.h"

#define HeaderHeight 15

@interface ChatInformationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak,nonatomic) UITableView * tableView;
@property (strong,nonatomic) NSArray * dataSource;

@end

@implementation ChatInformationViewController

#pragma mark - setter


#pragma mark - getter
-(NSArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // setup tableView
    [self setupTableView];
    // init data
    self.dataSource = @[@"消息免打扰",@"清空诊断记录"];
}

#pragma mark - init

-(void) setupTableView{
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.backgroundColor = IMBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 50;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ContactTableViewCell * cell = [ContactTableViewCell contactsCellWithTableView:tableView];

        //cell.userModel = _contactsModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // border view
        UIView * topBorder = [UIView cellTopBorderView];
        [cell.contentView addSubview:topBorder];
        UIView * bottomBorder = [UIView cellBottomBorderView:50];
        [cell.contentView addSubview:bottomBorder];
        
        return cell;
    }
    
    static NSString * cellId = @"chatInfoCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        if (indexPath.row == 0) { // 消息免打扰
            UISwitch * btn = [[UISwitch alloc] init];
            btn.onTintColor = ThemeColor;
            btn.on = [WJUserDefault boolForKey:MsgNoticeKey] == YES ? YES :NO;
            [btn addTarget:self action:@selector(openMsgNotice:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = btn;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // border view
            UIView * topBorder = [UIView cellTopBorderView];
            [cell.contentView addSubview:topBorder];
        }else if(indexPath.row == 1){
        
            UIView * bottomBorder = [UIView cellBottomBorderView:44];
            [cell.contentView addSubview:bottomBorder];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HeaderHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 处理点击事件
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            // 清空诊断记录
            [self clearConversationRecordWithConversationModel:self.conversationModel];
        }
    }
}

// 清空会话记录
-(void)clearConversationRecordWithConversationModel:(ConversationModel *)model{

    // 删除数据记录

    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:nil message:@"清空所有聊天记录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        BOOL successTab = [[DBManager shareManager] deleteFullTable:model.conversation.conversationId];

        if (successTab) {
            [MBProgressHUD showLabel:@"删除完成" toView:self.tableView];
            
        }else{
        
            [MBProgressHUD showLabel:@"删除失败" toView:self.tableView];
        }
        
        // 回调block 刷新聊天消息
        if (self.clearChatMessageBlock) {
            self.clearChatMessageBlock(successTab);
        }
    }];
    
    [alertVc addAction:cancel];
    [alertVc addAction:confirm];
    [self presentViewController:alertVc animated:YES completion:nil];
}


// 处理 消息免打扰事件

-(void)openMsgNotice:(UISwitch *)btn{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (btn.on) {
        NSLog(@"开启免打扰..");
        [defaults setBool:YES forKey:MsgNoticeKey];
        BOOL  success = [[DBManager shareManager] updateContactsInfoWithUserId:self.contactsModel.userId ColumuName:@"noBothered" value:@"1"];// "1" 表示开启
        if (!success) {
            NSLog(@"消息免打扰开启失败");
        }
        
    }else{
    
        NSLog(@"关闭免打扰");
        [defaults setBool:NO forKey:MsgNoticeKey];
        BOOL  success = [[DBManager shareManager] updateContactsInfoWithUserId:self.contactsModel.userId ColumuName:@"noBothered" value:@"0"];// "1" 表示开启
        if (!success) {
            NSLog(@"消息免打扰关闭失败");
        }
    }
    
}



@end
