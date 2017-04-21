//
//  ApplyAndNoticesViewController.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ApplyAndNoticesViewController.h"
#import "AddContactsViewController.h"
#import "ApplyNoticeTableViewCell.h"
#import "ContactsModel.h"

#define cellHeight 60

@interface ApplyAndNoticesViewController ()<UITableViewDelegate,UITableViewDataSource,ApplyNoticeTableViewCellDelegate>

@property (nonatomic,weak) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataSource; // 新联系人数据源

@end

@implementation ApplyAndNoticesViewController

#pragma mark - getter

-(NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma  mark - view didLoad
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新朋友";
    UIBarButtonItem * addBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(pushToAddVc)];
    self.navigationItem.rightBarButtonItem = addBtn;
    // setup tableview
    [self setupTableView];
    // 从数据库加载申请数据
    self.dataSource = [[DBManager shareManager] getUsersWithState:ContactsStateNoVerify];
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if (self.dataSource.count > 0) {
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
    }else{
        
        self.tableView.tableHeaderView.hidden = NO;
    }
}

#pragma mark - init

-(void)pushToAddVc{

    AddContactsViewController * addVc = [[AddContactsViewController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}
-(void)setupTableView{

    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = IMBgColor;
    _tableView.allowsSelection = NO;
    _tableView.tableFooterView = [[UIView alloc] init]; // 去掉多余的线条
    [self.view addSubview:_tableView];
 
    // 头部 提示语
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
    tipLabel.text = @"无新好友添加请求";
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:15];
    _tableView.tableHeaderView = tipLabel;
    _tableView.tableHeaderView.hidden = YES;

}

#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplyNoticeTableViewCell * cell = [ApplyNoticeTableViewCell applyNoticeCellWithTableView:tableView];
    cell.delegate = self;
    cell.cellData = self.dataSource[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return cellHeight;
}

#pragma mark - applyNoticeCell delegate

-(void)applyNoticeCell:(ApplyNoticeTableViewCell *)applyNoticeCell didSelectedAcceptBtn:(UIButton *)acceptBtn{
    
    // 插入申请人到本地数据库
    NSIndexPath * indexPath = [self.tableView indexPathForCell:applyNoticeCell];
    ContactsModel * applyUser = self.dataSource[indexPath.row];
    applyUser.state = ContactsStateIsFriend;
    BOOL success = [[DBManager shareManager] creatOrUpdateContactWith:applyUser];
    if (!success) {
        NSLog(@"插入新联系人%@失败",applyUser.userName);
    }
    
   // 给申请人同意消息

    NSError * error = nil;
    // TODO：通知服务器
    
    if (!error) {
        // 移除这条数据
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [MBProgressHUD showLabelWithText:@"已添加"];
    }else{
        NSLog(@"接受添加好友失败：%@",error);
        [MBProgressHUD showLabelWithText:@"处理失败"];
    }

}

-(void)applyNoticeCell:(ApplyNoticeTableViewCell *)applyNoticeCell didSelectedRefuseBtn:(UIButton *)refuseBtn{
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:applyNoticeCell];
    ContactsModel * applyUser = self.dataSource[indexPath.row];
    // 移除申请人记录
    BOOL success = [[DBManager shareManager] deleteContactsRecordWithUserId:applyUser.userId];
    if (!success) {
        NSLog(@"删除新联系人%@失败",applyUser.userName);
    }
     //给申请人拒绝消息
    
    NSError * error = nil;
    
    // TODO：通知服务器
    
    if (!error) {
        // 移除这条数据
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [MBProgressHUD showLabelWithText:@"已拒绝"];
    }else{
        NSLog(@"拒绝添加好友失败：%@",error);
        [MBProgressHUD showLabelWithText:@"处理失败"];
    }

}
@end
