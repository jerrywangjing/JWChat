//
//  ContactsSelectViewController.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/11/4.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ContactsSelectViewController.h"
#import "ZYPinYinSearch.h"
#import "DBManager.h"
#import "MessageModel.h"
#import "ConversationModel.h"
#import "Conversation.h"

@interface ContactsSelectViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,weak) UITableView * tableView;
@property (nonatomic,strong) UISearchController * searchVc;
@property (nonatomic,strong) NSMutableArray * dataSource;  // 数据源
@property (nonatomic,strong) NSMutableArray * searchResultData; // 搜索结果数据源

@property (nonatomic,copy) NSString * toUser; //选中联系人

@end

@implementation ContactsSelectViewController

#pragma mark - getter 

-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource  = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)searchResultData{
    
    if (!_searchResultData) {
        _searchResultData = [NSMutableArray array];
    }
    return _searchResultData;
}


-(UITableView *)tableView{

    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

-(UISearchController *)searchVc{

    if (!_searchVc) {
        _searchVc = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchVc.searchResultsUpdater = self;
        _searchVc.dimsBackgroundDuringPresentation = NO;
        _searchVc.searchBar.barTintColor = IMBgColor;
        _searchVc.searchBar.placeholder = @"搜索";
        _searchVc.searchBar.backgroundImage = [[UIImage alloc] init];
        [_searchVc.searchBar sizeToFit];
        
    }
    return _searchVc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择联系人";
    self.view.backgroundColor = IMBgColor;
    UIBarButtonItem * close = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick:)];
    self.navigationItem.leftBarButtonItem = close;
    
    //加载联系人数据
    [self getAllContacts];
    // 初始化View
    self.tableView.tableHeaderView = self.searchVc.searchBar;
}

-(void)getAllContacts{

    //TODO：从服务器获取联系人
}

-(void)closeBtnClick:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    // 获取搜索结果数据
    NSArray * resultArr = [ZYPinYinSearch searchWithOriginalArray: self.dataSource andSearchText:searchController.searchBar.text andSearchByPropertyName:@"name"];
    
    if (searchController.searchBar.text.length == 0) {
        
        [self.searchResultData removeAllObjects];
        [self.searchResultData addObjectsFromArray:self.dataSource];
        
    }else{
        
        [self.searchResultData removeAllObjects];
        [self.searchResultData addObjectsFromArray:resultArr];
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableVie delegate/dataSource 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.searchVc.active) {
        return self.searchResultData.count;
    }else{
    
        return self.dataSource.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * ID = @"cellid";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    // 给cell 赋值
    
    if (self.searchVc.active) {
        cell.textLabel.text = self.searchResultData[indexPath.row];
        
    }else{
    
        cell.textLabel.text = self.dataSource[indexPath.row];
    }
    cell.imageView.image = [UIImage imageNamed:@"man"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //self.searchVc.active = NO;
    _toUser = self.searchVc.active ? self.searchResultData[indexPath.row] : self.dataSource[indexPath.row];
    NSString * alertMsg = [NSString stringWithFormat:@"发送给：%@?",_toUser];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message: alertMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    [alert show];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return  50;
}

#pragma mark - alertView delegate 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) { // 发送按钮
        
        // 包装消息
        Message * msg = self.message;
        msg.timestamp = [NSDate currentFormattedDate];
        msg.timeStr = [NSDate currentFormattedDate]; // 注意这里的时间是当前发送时间
        
        //调用消息发送接口，同事存储数据库
       
        [self transferMessageToServer:msg];
        MessageModel * msgModel = [MessageModel modelWithMessage:msg];
        BOOL success = [[DBManager shareManager] creatTableOrUpdateMsg:_toUser messageModel:msgModel];
        
        if (success) {
            
            if ([self updateConversationWithMessage:msg]) {
                
                [MBProgressHUD showSuccessWithText:@"发送完成"];
            }
            
        }else{
        
            [MBProgressHUD showErrorWithText:@"发送失败"];
        }
        
        [self.searchVc setActive:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(BOOL)updateConversationWithMessage:(Message *)message{
    
    Conversation * cver = [[Conversation alloc] initWithLatestMessage:message];
    ConversationModel * cverModel = [[ConversationModel alloc] initWithConversation:cver];
    BOOL success = [[DBManager shareManager] creatOrUpdateConversationWith:cverModel];
    return success;
}

-(void)transferMessageToServer:(Message *)message{

    switch (message.body.type) {
        case MessageBodyTypeText:
            [self sendTextMessageToServer:message];
            break;
        case MessageBodyTypeImage:
            //
            break;
        case MessageBodyTypeFile:
            //
            break;
            
        default:
            break;
    }
}

-(void)sendTextMessageToServer:(Message *)message{
    
    // TODO：发送消息到服务器
}


@end
