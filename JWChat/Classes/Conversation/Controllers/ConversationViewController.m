//
//  ConversationViewController.m
//  JWChat
//
//  Created by jerry on 17/4/1.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "ConversationViewController.h"
#import "ContactsListViewController.h"
#import "ConvarsationListTableViewCell.h"
#import "ConversationModel.h"
#import "Conversation.h"
#import "ChatRoomViewController.h"
#import "ZYPinYinSearch.h"
#import "DBManager.h"
#import "MessageModel.h"
#import "EMCDDeviceManager.h"
#import "ContactsModel.h"
#import "AddContactsViewController.h"
#import "SubmitRecordViewController.h"
#define ConversationCellH 60

static NSInteger unreadCount = 0; //未读消息数
static NSString * lastTime; // 用于设置是否隐藏cell时间
static const CGFloat kDefaultPlaySoundInterval = 3.0; // 2次响铃的最小间隔时间
BOOL canClick = NO; // 连接状态视图是否可以点击

@interface ConversationViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate,ActivityViewTitleDelegate,NIMChatManagerDelegate,NIMLoginManagerDelegate>

@property (nonatomic,strong) NSMutableArray * dataArr; // 存放conversationModel 对象
@property (nonatomic,weak) UITableView * tableView;
@property (nonatomic,strong) UISearchController * searchController;
@property (nonatomic,strong) NSMutableArray * searchResultData;
@property (nonatomic,copy) NSString * latestMsgId;  //存放新消息的发送者
@property (nonatomic,strong) NSDate *lastPlaySoundDate;  // 上次播放响铃的时间

@property (nonatomic,weak) ActivityViewTitle * activityViewTitle; // 动态标题视图

@end

#pragma mark - 状态视图实现
@implementation ActivityViewTitle

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView = activityView;
        
        UILabel * title = [[UILabel alloc] init];
        _titleLabel = title;
        
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
        title.textColor = [UIColor whiteColor];
        [self addSubview:title];
        [self addSubview:_activityView];
        // 布局
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointMake(0, 0)); // 注意：由于label是self的子控件所以它的中心点是（0，0）
        }];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_titleLabel.mas_left).offset(-5);
            make.top.equalTo(_titleLabel.mas_top);
        }];
        
        // 添加点击事件
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloginClick)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

// 重新登录点击方法
-(void)reloginClick{
    
    if ([self.delegate respondsToSelector:@selector(didClickRelogin:)]) {
        [self.delegate didClickRelogin:self];
    }
}

@end

@implementation ConversationViewController

#pragma mark - getter

-(ActivityViewTitle *)activityViewTitle{
    
    if (!_activityViewTitle) {
        ActivityViewTitle * view = [[ActivityViewTitle alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _activityViewTitle = view;
        _activityViewTitle.delegate = self;
        self.navigationItem.titleView = view;
    }
    return _activityViewTitle;
}

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr  = [NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableArray *)searchResultData{
    
    if (!_searchResultData) {
        _searchResultData = [NSMutableArray array];
    }
    return _searchResultData;
}
-(UISearchController *)searchController{
    
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;//在搜索时是否需要关闭蒙版,好处在于可以直接点击搜索到的结果
        _searchController.delegate = self;
        //修改searchBar属性
        _searchController.searchBar.barTintColor = IMBgColor;
        _searchController.searchBar.tintColor = ThemeColor;
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.searchBar.backgroundImage = [[UIImage alloc] init];
        [_searchController.searchBar sizeToFit];
        //self.definesPresentationContext = YES;// 设置此属性可以修复搜索框消失的问题
    }
    return _searchController;
}

#pragma mark - init 

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

-(void)loadView {
    
    [super loadView];
    
    [self setupSubviews];
      
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = IMBgColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addBtn_bg"] style:UIBarButtonItemStylePlain target:self action:@selector(addBtnClick:)];
    
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    NSString * cache = NSHomeDirectory();
    NSLog(@"沙盒：%@",cache);
    [self testMethod];
}

- (void)dealloc{

    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    // 更新会话数据
    [self refreshTableView:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

-(void)testMethod{
    
    
}

- (void)setupSubviews{
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    _tableView.tableHeaderView = self.searchController.searchBar;
    _tableView.tableFooterView = [[UIView alloc] init]; // 去掉多余分割线(cell 没有数据时)
    [self.view addSubview:_tableView];
    
    // 解决下拉刷新出现黑边的问题
    for (UIView * view in self.tableView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
    // 添加下拉刷新
//    MJRefreshNormalHeader * refresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView:)];
//    refresh.lastUpdatedTimeLabel.hidden = YES;
//    refresh.stateLabel.hidden = NO;
//    
//    _tableView.mj_header = refresh;

}

#pragma mark - barButtonItem actions
- (void)addBtnClick:(UIButton *)btn{

    //AddContactsViewController * addVc = [[AddContactsViewController alloc] init];
    SubmitRecordViewController * submit = [SubmitRecordViewController new];
//    itemsVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:submit animated:YES];
}
// 刷新表格
-(void)refreshTableView:(UIRefreshControl *)refresh{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.dataArr = [[DBManager shareManager] getAllConversationsFromDB];
        for (int i = 0; i<self.dataArr.count; i++) {
            ConversationModel * model = self.dataArr[i];
            if ([model.conversation.conversationId isEqualToString:self.latestMsgId]) {
                [self.dataArr exchangeObjectAtIndex:i withObjectAtIndex:0];
                break;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)jumpToContactsVc:(UIButton *)btn{
    
    //[btn clearBadge];
    
    // 联系人列表
    ContactsListViewController * contactsListVc = [[ContactsListViewController alloc] init];
    contactsListVc.deleteUser = ^(NIMUser * deleteContact){
        // 回调删除会话记录及聊天表
        BOOL success = [[DBManager shareManager] deleteConversationRecordWithConversationId:deleteContact.userId];
        if (success) {
            BOOL success = [[DBManager shareManager] deleteFullTable:deleteContact.userId];
            if (success) {
                NSLog(@"删除联系人%@成功",deleteContact.userId);
            }
        }else{
            
            NSLog(@"删除联系人%@失败",deleteContact.userId);
        }
    };
    
    [self.navigationController pushViewController:contactsListVc animated:YES];
}

#pragma mark - tableView data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!self.searchController.active) {
        return self.dataArr.count;
    }else{
        
        return self.searchResultData.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConvarsationListTableViewCell * cell = [ConvarsationListTableViewCell convarsationListCellWithTableview:tableView];
    // 给cellData 赋值
    
    ConversationModel * model = self.searchController.active ? self.searchResultData[indexPath.row] : self.dataArr[indexPath.row];;
    
    cell.conversationData = model;
    
    if (indexPath.row == 0) {
        cell.isTop = YES;
    }
    if (indexPath.row == self.dataArr.count-1) {
        cell.isBottom = YES;
    }
    if (model.conversation.unreadMessagesCount > 0 && ![model.contact.noBothered isEqualToString:@"1"]) {
        
        [self showRedDotNoticeWithCell:cell addCount:model.conversation.unreadMessagesCount];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ConversationCellH;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 删除数据记录
        
        ConversationModel * deleteModel = self.dataArr[indexPath.row];
        
        BOOL success = [[DBManager shareManager] deleteConversationRecordWithConversationId:deleteModel.conversationId];
        [[DBManager shareManager] deleteFullTable:deleteModel.conversation.conversationId];
        
        // 删除UI
        if (success) {
            [self.dataArr removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            
            NSLog(@"会话记录删除失败");
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 设置消息为已读
    self.tabBarItem.badgeValue = nil;
    self.navigationItem.backBarButtonItem = nil;
    unreadCount = 0;
    ConvarsationListTableViewCell * currentCell = [tableView cellForRowAtIndexPath:indexPath];
    [currentCell.avatarImageView.subviews.firstObject removeFromSuperview]; // 移除小红点
    
    // 跳转到聊天页面
    ChatRoomViewController * chatRoom = [[ChatRoomViewController alloc] init];
    chatRoom.hidesBottomBarWhenPushed = YES;
    ConversationModel * model = self.searchController.active ? self.searchResultData[indexPath.row] : self.dataArr[indexPath.row];
    model.conversation.unreadMessagesCount = 0;
    [[DBManager shareManager] updateConversationWithConversationModel:model];
    chatRoom.conversationModel = model;
    chatRoom.user = model.user;
    
    if (self.searchController.active) {
        self.searchController.active = NO; // 退出搜索功能
    }
    
    [self.navigationController pushViewController:chatRoom animated:YES];
    
}

#pragma mark - SearchResultsUpdating delegate

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    // 获取搜索结果数据
//    NSMutableArray *  contactsArr = [NSMutableArray array];
//    for (ConversationModel  * model  in self.dataArr) {
//        NIMUserInfo * userInfo = model.user.userInfo;
//        [contactsArr addObject:user];
//    }
    
    NSArray * resultArr = [ZYPinYinSearch searchWithOriginalArray: self.dataArr andSearchText:searchController.searchBar.text andSearchByPropertyName:@"conversationId"];
    
    if (self.searchController.searchBar.text.length == 0) {
        
        [self.searchResultData removeAllObjects];
        [self.searchResultData addObjectsFromArray:self.dataArr];
        
    }else{
        
        [self.searchResultData removeAllObjects];
        [self.searchResultData addObjectsFromArray:resultArr];
    }
    
    [self.tableView reloadData];
}

#pragma mark - searchController delegate

- (void)didDismissSearchController:(UISearchController *)searchController{
    
    // 解决下拉刷新出现白色区域的问题
    for (UIView * view in self.tableView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    [self.view endEditing:YES];
}


// 连接状态改变的回调

- (void)updateTitleWithLinkState:(NSString *)state showIndicator:(BOOL)show{
    
    self.activityViewTitle.titleLabel.text = state;
    if (show) {
        [self.activityViewTitle.activityView startAnimating];
    }else{
        
        [self.activityViewTitle.activityView stopAnimating];
    }
}

#pragma mark - activityView delegate

-(void)didClickRelogin:(UIActivityIndicatorView *)activityView{
    // 重新登录
    if (canClick) {
        //初始化引擎
    }
}

#pragma mark - 接收到新消息

-(void)onRecvMessages:(NSArray<NIMMessage *> *)messages{

    for (NIMMessage * msg in messages) {
        
        Message * recvMsg = nil;
        
        switch (msg.messageType) {
            case NIMMessageTypeText:{
                
                recvMsg = [WJMessageHelper receivedTextMessage:msg.text from:msg.from];
            }
                break;
            case NIMMessageTypeImage:{
            
                NIMImageObject * image = (NIMImageObject *)msg.messageObject;
                ImageMessageBody * imageBody = [[ImageMessageBody alloc] initWithData:nil localPath:nil];
                imageBody.thumbUrl = image.thumbUrl;
                imageBody.url = image.url;
                //recvMsg = [WJMessageHelper receivedImageMessageWithData:nil localPath:image.thumbUrl from:image.message.from];
            }
                break;
                
            default:
                break;
        }
        
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:msg.timestamp];
        recvMsg.timeStr = [date defaultFormattedDate];
        recvMsg.timestamp = [date defaultFormattedDate];
        recvMsg.direction = MessageDirectionReceive;
        recvMsg.isHideTime = [lastTime isEqualToString:recvMsg.timeStr]? YES:NO;
        lastTime = recvMsg.timeStr;
        
        [self noticeAndSaveNewMessage:recvMsg fromUserId:msg.from];
    }
}

#pragma mark - loginManager delegate

- (void)onLogin:(NIMLoginStep)step{
    
}
#pragma mark - private

// 消息提醒及消息缓存
-(void)noticeAndSaveNewMessage:(Message *)receivedMsg fromUserId:(NSString *)fromUserId{
    
    // 更新会话到数据库
    Conversation * cov = [[Conversation alloc] initWithLatestMessage:receivedMsg];
    
    cov.unreadMessagesCount = [[DBManager shareManager] queryUnreadCountFormTable:fromUserId];
    cov.conversationId = fromUserId;
    
    NIMUser * fromUser = [[NIMSDK sharedSDK].userManager userInfo:fromUserId];
    
    ConversationModel * covModel = [[ConversationModel alloc] initWithConversation:cov];
    covModel.user = fromUser;
    
    [[DBManager shareManager] creatOrUpdateConversationWith:covModel];
    
    // 更新消息到数据库
    MessageModel * msgModel = [MessageModel modelWithMessage:receivedMsg];
    
    [[DBManager shareManager] creatTableOrUpdateMsg:fromUserId messageModel:msgModel];
    self.latestMsgId = fromUserId;
    
    
    // 新消息提醒
    // TODO: 根据参数from 拿到当前消息发的发送者，去数据库查询是否需要消息免打扰，判断是否显示红点及声音提示
    
    
    if (![self.navigationController.topViewController isKindOfClass:[ChatRoomViewController class]]) {
        // 红点提醒
        unreadCount += 1;
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",unreadCount];
        
        // 声音和震动提醒
        if ([[NIMSDK sharedSDK].userManager notifyForNewMsg:fromUserId]) {
            
            
            if (![WJUserDefault boolForKey:MsgNoticeKey]) {
                [self playSoundAndVibration];
            }
        }
    }
   
    // 刷新UI
    [self refreshTableView:nil];
    
}

// 设置消息提醒小红点
-(void) showRedDotNoticeWithCell:(ConvarsationListTableViewCell* )cell addCount:(NSInteger)count{
    
    // 当cell 中没有提示红点的时候才创建
    if (![cell.avatarImageView.subviews.firstObject isKindOfClass:[UIImageView class]]) {
        UIImageView * redDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot"]];
        
        if (count > 0) {
            
            [cell.avatarImageView addSubview:redDot];
            [redDot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.avatarImageView.mas_right);
                make.top.equalTo(cell.avatarImageView).offset(-3);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
            
            UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
            countLabel.textColor = [UIColor whiteColor];
            countLabel.font = [UIFont systemFontOfSize:12];
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel.text = [NSString stringWithFormat:@"%ld",count];
            [redDot addSubview:countLabel];
            
        }
        
    }else{
        
        UIImageView * countImg = (UIImageView *)cell.avatarImageView.subviews.firstObject;
        UILabel * label = (UILabel *)countImg.subviews.firstObject;
        label.text = [NSString stringWithFormat:@"%ld",count];
        
    }
}

// 播放铃声
- (void)playSoundAndVibration{
    
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showAlertViewWithMsg:(NSString *)msg{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
