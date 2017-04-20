//
//  AddContactsViewController.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/11/22.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "AddContactsViewController.h"
#import "ContactTableViewCell.h"
#import "ContactsModel.h"
#import "ContactsDetailViewController.h"

#define  CellHeight 50

@interface AddContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic,weak)UITableView * tableView;
@property (nonatomic,strong)UISearchController * searchController;
@property (nonatomic,strong)NSArray * resultData;
@property (nonatomic,strong)NSMutableDictionary * btnStateDic;
@end

@implementation AddContactsViewController

-(NSArray *)resultData{

    if (!_resultData) {
        _resultData = [NSArray array];
    }
    return _resultData;
}
-(NSMutableDictionary *)btnStateDic{
    
    if (!_btnStateDic) {
        _btnStateDic = [NSMutableDictionary dictionary];
    }
    return _btnStateDic;
}

-(void)dealloc{
    
//    NSLog(@"销毁了%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加联系人";
    
    // setup tableView
    [self setupTableView];
}


-(void)setupTableView{

    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.backgroundColor = IMBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    // setup searchControl
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.barTintColor = IMBgColor;
    _searchController.searchBar.tintColor = ThemeColor;
    _searchController.searchBar.placeholder = @"请输入联系人账号";
    _searchController.searchBar.backgroundImage = [[UIImage alloc] init];
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    
    _tableView.tableHeaderView = _searchController.searchBar;
}

#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.resultData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ContactTableViewCell * cell = [ContactTableViewCell contactsCellWithTableView:tableView];
    cell.showAddBtn = YES;
    [cell setAddBtnState:[self.btnStateDic objectForKey:@(indexPath.row)] addTag:indexPath.row];
    
    WeakSelf(self);
    cell.addBtnDidClickBlock = ^(UIButton *btn){
    
        [weakself addContactBtnClick:btn andIndex:indexPath.row];
    };
    // 赋值
    NIMUser * user = self.resultData[indexPath.row];
    cell.user = user;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return CellHeight;
}

#pragma mark - search result update

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    // 从服务器获取此联系人
}
#pragma mark - search bar delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    NSString * userId = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 整理字符串
    
    self.searchController.active = NO;
    
    [MBProgressHUD showHUD];
    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        [MBProgressHUD hideHUD];
        
        if (users.count > 0) {
            ContactsDetailViewController * userDetailVc = [[ContactsDetailViewController alloc] initWithUserId:userId];
            [self.navigationController pushViewController:userDetailVc animated:YES];
        }else{
        
            [MBProgressHUD showLabelWithText:@"无相关联系人"];
        }
    }];
    
}


#pragma mark - addBtn click

-(void)addContactBtnClick:(UIButton *)btn andIndex:(NSInteger)index{

    
    ContactsModel * user = self.resultData[index];
    
    // 验证是否已经是自己的好友
    if ([[DBManager shareManager] isExistsRecordInTable:DBContactsListName withColumnName:@"userId" andColumnValue:user.userId]) {
        
        [MBProgressHUD showLabel:[NSString stringWithFormat:@"%@已是你的好友!",user.userName]];
        return;
    }
    
    // 弹出提示框 让输入添加备注

    WeakSelf(self);
    
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"好友验证" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 发送添加请求到服务器
        
        [MBProgressHUD showMessage:nil toView:weakself.tableView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:weakself.tableView];
            //验证信息
            NSString * verifyMsg = alertVc.textFields.firstObject.text;
            
            //发送请求到服务器
            
            user.verifyMsg = verifyMsg;
            
//            [ContactsManager applyAddContact:user.userId message:nil completion:^(NSString *aUsername, NSError *aError) {
//                
//                if (!aError) {
//                    // 给出提示
//                    [MBProgressHUD showLabel:@"发送成功" toView:weakself.tableView];
//                    
//                    //更新btn状态
//                    [weakself.btnStateDic setObject:@"已发送" forKey:@(btn.tag)];
//                    [weakself.tableView reloadData];
//                }
//            }];
            
        });
        
    }];

    [alertVc addAction:cancel];
    [alertVc addAction:confirm];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //回调
        textField.placeholder = @"请输入验证信息(选填)";
        textField.clearsOnBeginEditing = YES;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    [self presentViewController:alertVc animated:YES completion:nil];

}

@end
