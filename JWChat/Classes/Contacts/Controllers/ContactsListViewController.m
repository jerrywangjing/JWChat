//
//  SearchContactsController.m
//  contactsAndSearchBar
//
//  Created by jerry on 16/6/28.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ContactsListViewController.h"
#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import "ContactTableViewCell.h"
#import "ChatRoomViewController.h"
#import "ApplyAndNoticesViewController.h"
#import "AddContactsViewController.h"
#import "ContactsDetailViewController.h"
#import "ContactsModel.h"

#define CELL_HEIGHT 50
#define SearchBarH 44
BOOL hasApply = NO; // 是否有申请信息

@interface ContactsListViewController ()<UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UISearchControllerDelegate,NIMUserManagerDelegate,NIMSystemNotificationManagerDelegate,NIMLoginManagerDelegate>

@property (nonatomic,weak) UITableView * tableView;
@property (nonatomic,strong) UISearchController * searchController;
@property (nonatomic,strong) NSArray * origUserList; // 排序前的数据源
@property (nonatomic,strong) NSMutableDictionary * sectionUserList;// 排序后的分组数据源
@property (nonatomic,strong) NSMutableArray * searchResultData; // 搜索结果数据源
@property (nonatomic,strong) NSMutableArray * indexData; // 索引数据源

@end

@implementation ContactsListViewController

#pragma mark - getter

-(NSMutableArray *)searchResultData{
    
    if (!_searchResultData) {
        _searchResultData = [NSMutableArray array];
    }
    return _searchResultData;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self updateFriendsInfo];
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] userManager] removeDelegate:self];
    
    self.searchController = nil;
    self.tableView = nil;
    
//    NSLog(@"销毁了%s",__func__);
}

#pragma mark - view did load

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * add = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_nor"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAddVc)];

    self.navigationItem.rightBarButtonItem = add;
    
    // setup tableView
    [self setupTableView];
    
    // 联系人上下线代理

    // 初始化数据
    [self prepareData];
    
    // 设置代理
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[[NIMSDK sharedSDK] userManager] addDelegate:self];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 检查有没有新的联系人请求，有的话就给出红点提示
    BOOL hasNewApply = [[DBManager shareManager] isExistsRecordInTable:DBContactsListName withColumnName:@"state" andColumnValue:ContactsStateNoVerify];
    if (hasNewApply) {
        hasApply = YES;
    }else{
    
        hasApply = NO;
    }
    [self.tableView reloadData];
}

-(void)setupTableView{

    UITableView * tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView = tab;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = IMBgColor;
    [self.view addSubview:_tableView];
    _tableView.sectionIndexColor = [UIColor darkGrayColor];
    _tableView.tableHeaderView = self.searchController.searchBar;
    _tableView.tableFooterView = [[UIView alloc] init]; // 去掉多余的间隔线(没有数据时)
    UIColor * indexBgColor = [UIColor clearColor];
    _tableView.sectionIndexBackgroundColor = indexBgColor;
    
    // 头部 提示语
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CELL_HEIGHT)];
    tipLabel.text = @"暂无联系人";
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:15];
    _tableView.tableFooterView = tipLabel;
    _tableView.tableFooterView.hidden = YES;
    
//    // 下拉刷新
//    MJRefreshNormalHeader * refresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView:)];
//    refresh.lastUpdatedTimeLabel.hidden = YES;
//    _tableView.mj_header = refresh;
    
    // 解决下拉刷新出现黑边的问题
    for (UIView * view in self.tableView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
}

-(void)jumpToAddVc{

    AddContactsViewController * addVc = [[AddContactsViewController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}

-(void)backBtnClick{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

//-(void)refreshTableView:(UIRefreshControl *)refresh{
//
//    if (refresh.isRefreshing) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self initOrUpdateContactsData];
//            [refresh endRefreshing];
//        });
//    }
//}

#pragma mark init_method

-(void)initOrUpdateContactsData{
    
    
    
//    [ContactsManager getAllFriendsFromServer:^(NSArray *remoteFriends,BOOL succeed) {
//        
//        // 从服务器获取联系人信息，并插入数据库
//        
//        if (succeed) {
//            if (remoteFriends.count > 0) {
//                
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    
//                    for ( ContactsModel * remoteFriend in remoteFriends) {
//                        
//                        // 放到子线程处理，优化加载
//                        BOOL existed = [[DBManager shareManager] isExistsRecordInTable:DBContactsListName withColumnName:@"userId" andColumnValue:remoteFriend.userId];
//                        if (existed) {
//                            ContactsModel * localFriend = [[DBManager shareManager] getUserWithUserId:remoteFriend.userId];
//                            
//                            if (remoteFriend.version.integerValue > localFriend.version.integerValue) {
//                                // 更新好友资料
//                                [ContactsManager getUserInfoFromServerWithUserId:remoteFriend.userId completeHandler:^(NSDictionary *infoDic) {
//                                    
//                                    ContactsModel * model = [ContactsModel contactWithDic:infoDic];
//                                    model.state = ContactsStateIsFriend;
//                                    NSLog(@"%@更新了资料",model.userId);
//                                    // 存储到数据库
//                                    [[DBManager shareManager] creatOrUpdateContactWith:model];
//                                    [self updateTableViewData];
//                                }];
//                            }else{ //不需要更正资料时
//                                
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [self updateTableViewData];
//                                });
//                            }
//                            
//                        }else{
//                            
//                            // 插入新联系人记录
//                            [ContactsManager getUserInfoFromServerWithUserId:remoteFriend.userId completeHandler:^(NSDictionary *infoDic) {
//                                
//                                ContactsModel * model = [ContactsModel contactWithDic:infoDic];
//                                model.state = ContactsStateIsFriend;
//                                NSLog(@"插入了新好友：%@",model.userId);
//                                // 存储到数据库
//                                [[DBManager shareManager] creatOrUpdateContactWith:model];
//                                [self updateTableViewData];
//                            }];
//                            
//                        }
//                        
//                    }
//                    
//                });
//                
//            }else{
//                
//                // 服务器加载失败,从本地数据库加载
//                NSLog(@"从本地数据库加载了联系人列表");
//                [self updateTableViewData];
//                
//            }
//        }else{ // 网络请求失败
//        
//            [MBProgressHUD hideHUDForView:self.tableView];
//            [MBProgressHUD showLabel:@"网络请求失败，稍后再试"];
//        }
//        
//    }];
}

-(void)updateTableViewData{

    NSArray * contactsList = [[DBManager shareManager] getAllContactsFromDB];
    self.sectionUserList = [self sortSourceData:contactsList];
    // 刷新UI
    [self.tableView reloadData];
    [MBProgressHUD hideHUDFromView:self.tableView];

}

// 联系人排序
-(NSMutableDictionary *)sortSourceData:(NSArray *)userList{

    // 排序后数据
    NSMutableDictionary * sortUsersDic = [HCSortString sortAndGroupForArray:userList PropertyName:@"userId"];
    
    _indexData = [HCSortString sortForStringAry:sortUsersDic.allKeys];

    return sortUsersDic;
}


//创建搜索控制器
-(UISearchController *)searchController{

    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = NO;//在搜索时是否需要关闭蒙版,好处在于可以直接点击搜索到的结果
        //修改searchBar属性
        _searchController.searchBar.barTintColor = IMBgColor;
        _searchController.searchBar.tintColor = ThemeColor;
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.searchBar.backgroundImage = [[UIImage alloc] init];
        self.definesPresentationContext = YES;// 设置此属性可以修复搜索框消失的问题

    }
    return _searchController;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (!self.searchController.active) {
        
        if (_indexData.count > 0) {
            _tableView.tableFooterView.hidden = YES;
            return _indexData.count + 1;
        }else{
            _tableView.tableFooterView.hidden = NO;
            return 1;
        }
    }else { // 如果是搜索结果列表时
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.searchController.active) {
        
        if (section == 0) {
            return 1;
        }else{
            NSArray * arr = [_sectionUserList objectForKey:_indexData[section-1]];
            return arr.count;
        }
    }else{  // 如果是搜索结果列表时
    
        return self.searchResultData.count;
    }
}
// 每个section头部视图标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    
    if (!self.searchController.active) {
        if (section != 0) {
            return _indexData[section];
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (!self.searchController.active) {
        if (section == 0) {
            return 0;
        }
        return 20;
    }
    return 0 ;
}
// 右部索引列表
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{

    if (!self.searchController.active) {
        return _indexData;
    }else {// 如果是搜索结果列表时
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.searchController.active) { // 未进行搜索的情况

        if (indexPath.section == 0) {
            
            static NSString * cellId = @"applyCell";
            
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.imageView.image = [UIImage imageNamed:@"new_friend"];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            cell.textLabel.text = @"申请与通知";
            cell.separatorInset = UIEdgeInsetsMake(0, 0,SCREEN_WIDTH,CELL_HEIGHT-0.5);//去掉系统默认底部细线
            
            if (hasApply) {
                [self showRedDotNoticeWithCell:cell addCount:0];
            }else{
                [cell.imageView.subviews.firstObject removeFromSuperview]; // 移除小红点
            }
            return cell;
            
        }else{
        
            ContactTableViewCell *cell = [ContactTableViewCell contactsCellWithTableView:tableView];
            
            NSArray * sectionModels = [_sectionUserList objectForKey:_indexData[indexPath.section-1]];

            NIMUser * user = sectionModels[indexPath.row];
            cell.user = user;
            
            return cell;
        }
        
        
    }else{  // 如果是搜索结果列表时
        
        ContactTableViewCell *cell = [ContactTableViewCell contactsCellWithTableView:tableView];
        
        NIMUser * user = self.searchResultData[indexPath.row];
        cell.user = user;
        return cell;
    }
}

// 右侧索引列表标题点击后会调用此方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    return index;
}

// 删除联系人
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSMutableArray * sectionUsers = self.sectionUserList[self.indexData[indexPath.section-1]];
        NIMUser * deleteUser = sectionUsers[indexPath.row];
        
        //给出提示
        
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确认删除好友%@吗？",deleteUser.userInfo.nickName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            // 删除内存中数据源
            [sectionUsers removeObject:deleteUser];
            if (sectionUsers.count == 0) {
                NSString * key = self.indexData[indexPath.section-1];
                [self.sectionUserList removeObjectForKey:key];
                [self.indexData removeObjectAtIndex:indexPath.section-1];
            }
            // 删除本地数据库联系人记录
            BOOL success = [[DBManager shareManager] deleteContactsRecordWithUserId:deleteUser.userId];
            if (!success) {
                NSLog(@"本地联系人删除失败%@",deleteUser.userId);
            }
            // 删除与此人的会话记录

            //self.deleteUser(deleteUser);
            // 通知服务器解除好友关系
//            [ContactsManager deleteContact:deleteUser.userId completion:^(NSString *aUsername, NSError *aError) {
//                if (aError) {
//                    NSLog(@"删除%@失败",aUsername);
//                }
//                NSLog(@"告知服务器已删除好友%@",aUsername);
//            }];
             // 更新UI
            [self.tableView reloadData];
        }];
        [alertVc addAction:cancel];
        [alertVc addAction:confirm]; 
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return nil;
    }
    UIView * header = [[UIView alloc] init];
    header.backgroundColor = IMBgColor;
    UILabel * index = [[UILabel alloc] init];
    index.frame = CGRectMake(10, 0, 20, 20);
    index.textColor = [UIColor darkGrayColor];
    index.text = self.indexData[section-1];
    index.font = [UIFont systemFontOfSize:16];
    [header addSubview:index];
    return  header;
}
#pragma mark - Table View Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return  CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.searchController.active) {//未使用搜索情况
        if (indexPath.section == 0) {

            ApplyAndNoticesViewController * newApply = [[ApplyAndNoticesViewController alloc] init];
            [self.navigationController pushViewController:newApply animated:YES];
            
        }else{
        
            // 获取当前用户id
            NSArray *sectionUsers = [_sectionUserList objectForKey:_indexData[indexPath.section-1]];
            NIMUser * user = sectionUsers[indexPath.row];
            [self pushToContactsDetailVc:user];
        }
    }else{
        
        [self pushToContactsDetailVc:self.searchResultData[indexPath.row]];
    }
}

// 跳转到会话列表
-(void)pushToContactsDetailVc:(NIMUser *)user{
    // 跳转会话列表之前让搜索控制器关闭
    self.searchController.active = NO;
    // 跳转到联系人详情页
    
    ContactsDetailViewController * detailVc = [[ContactsDetailViewController alloc] initWithUserId:user.userId];
//    detailVc.contactModel = user;
    detailVc.previousVc = self;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - UISearchDelegate

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    // 获取全部数据
    NSArray * allDataArr = [HCSortString getAllValuesFromDict:self.sectionUserList];
    // 获取搜索结果数据
    NSArray * resultArr = [ZYPinYinSearch searchWithOriginalArray: allDataArr andSearchText:searchController.searchBar.text andSearchByPropertyName:@"userId"];
    
    if (self.searchController.searchBar.text.length == 0) {

        [self.searchResultData removeAllObjects];
        [self.searchResultData addObjectsFromArray:allDataArr];
        
    }else{
 
        [self.searchResultData removeAllObjects];
        [self.searchResultData addObjectsFromArray:resultArr];
    }
    
    [self.tableView reloadData];
}

#pragma mark - searchController delegate

-(void)didDismissSearchController:(UISearchController *)searchController{

    // 解决下拉刷新出现黑边的问题
    for (UIView * view in self.tableView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
}

#pragma  mark - 回调方法

#pragma mark - NIMContactDataCellDelegate
- (void)onPressAvatar:(NSString *)memberId{
//    [self enterPersonalCard:memberId];
}

#pragma mark - NTESContactUtilCellDelegate
- (void)onPressUtilImage:(NSString *)content{
    //[self.view makeToast:[NSString stringWithFormat:@"点我干嘛 我是<%@>",content] duration:2.0 position:CSToastPositionCenter];
}

#pragma mark - NIMContactSelectDelegate
- (void)didFinishedSelect:(NSArray *)selectedContacts{
    
}

#pragma mark - NIMSDK Delegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    [self refresh];
}

- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK) {
        if (self.isViewLoaded) {//没有加载view的话viewDidLoad里会走一遍prepareData
            [self refresh];
        }
    }
}

- (void)onUserInfoChanged:(NIMUser *)user
{
    [self refresh];
}

- (void)onFriendChanged:(NIMUser *)user{
    [self refresh];
}

- (void)onBlackListChanged
{
    [self refresh];
}

- (void)onMuteListChanged
{
    [self refresh];
}

- (void)refresh
{
    [self prepareData];
    [self.tableView reloadData];
}

- (void)prepareData{

    NSArray * userList = [[NIMSDK sharedSDK].userManager myFriends];
    self.sectionUserList = [self sortSourceData:userList];

}
// 联系人上线回调
-(void)addUserForOnline:(NSString *)userID{

    // 联系人上下线状态显示思路：通过userId 在联系人模型数据源中拿到对应联系人模型，修改模型属性（即改变状态）已达到状态显示，最后reload tableView 刷新。
    // 通过修改头像为半透明状，和是否在线文字即可。
    
    [[DBManager shareManager] updateContactsInfoWithUserId:userID ColumuName:@"online" value:@"1"];

    [self updateTableViewData];
}

// 联系人下线回调
-(void)removeUserForOffline:(NSString *)userID{

    [[DBManager shareManager] updateContactsInfoWithUserId:userID ColumuName:@"online" value:@"0"];
    [self updateTableViewData];
}

-(void)receivedNewApply{
    // 设置红点提示
    hasApply = YES;
    [self.tableView reloadData];
}

-(void)receivedDeletedFromUser:(NSString *)userId{
    //TODO: 需要删除数据源
    [self updateTableViewData];
}
-(void)receivedAddedFromUser:(NSString *)userId{

    [self initOrUpdateContactsData];
}

#pragma mark private 

// 设置消息提醒小红点
-(void) showRedDotNoticeWithCell:(UITableViewCell* )cell addCount:(NSInteger)count{
    
    // 当cell 中没有提示红点的时候才创建
    if (![cell.imageView.subviews.firstObject isKindOfClass:[UIImageView class]]) {
        UIImageView * redDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot"]];
        [cell.imageView addSubview:redDot];
        [redDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.imageView.mas_right);
            make.top.equalTo(cell.imageView).offset(-3);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
}

- (void)updateFriendsInfo{

    NSArray * friends = [[NIMSDK sharedSDK].userManager myFriends];
    NSArray * friendIds = [NSArray array];
    
    NSMutableArray * tempArr = [NSMutableArray array];
    for (NIMUser * user in friends) {
        NSString * userId = user.userId;
        [tempArr addObject:userId];
    }
    friendIds = tempArr;
    
    [[NIMSDK sharedSDK].userManager fetchUserInfos:friendIds completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        if (error) {
            NSLog(@"更新好友资料失败:Error(%@)",error.localizedDescription);
        }
    }];
}
@end
