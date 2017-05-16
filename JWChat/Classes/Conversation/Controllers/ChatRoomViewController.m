//
//  ChatRoomViewController.m
//  ESDemo
//
//  Created by jerry on 16/9/12.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "MessageTableViewCell.h"
#import "MessageFrame.h"
#import "ContactsListViewController.h"
#import "EmojiKeyboardView.h"
#import "AddOtherFuncKeyboard.h"
#import "ContactsDetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "RecordView.h"
#import "MessageModel.h"
#import "ConversationModel.h"
#import "Conversation.h"
#import "ContactsSelectViewController.h"
#import "ContactsDetailViewController.h"
#import "ContactsModel.h"
#import "ChatInformationViewController.h"
#import <TZImagePickerController.h>
#import "ChatToolBar.h"
#import "InputView.h"
#import "ArtboardViewController.h"
#import "MainNavController.h"
#import "MapViewController.h"

#define CachesDirectory NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define FILE_PATH [CachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",self.conversationId]]
#define emojiBoardH 225
#define addBoardH emojiBoardH
#define KeyboardTimeInterval 0.25
#define ToolbarHeight 50
#define  TransformSize (1024 * 100) // 每次发送100k 数据

static NSInteger LastOffset = 0; //记录上次消息加载数
static NSString * lastTime = nil; // 用于设置是否隐藏cell时间

@interface ChatRoomViewController ()<UITableViewDataSource,UITableViewDelegate,EmojiKeyboardViewDelegate,AddOtherFuncKeyboardDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MessageTableViewCellDelegate,TZImagePickerControllerDelegate,ChatToolBarDelegate,NIMChatManagerDelegate>

@property (nonatomic,strong) NSMutableArray *messageFrames; // 消息数据源
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,weak) UIButton * recordBtn;
@property (nonatomic,weak) RecordView * recordView;
@property (nonatomic,strong) ChatToolBar * toolBar;
@property (nonatomic,weak) UIButton * emojiBtn;
@property (nonatomic,weak) UIButton * addBtn;
@property (nonatomic,weak) UIButton * voiceBtn;
@property (nonatomic,assign) BOOL isPlayingAudio;

@property (strong,nonatomic) EmojiKeyboardView * emojiKeyboard;
@property (strong,nonatomic) AddOtherFuncKeyboard * addKeyboard;
@property (assign,nonatomic) BOOL switchingKeyboard;
@property (nonatomic,strong) Message * activeMessage; // 当前点击/长按时的消息对象
@property (nonatomic,strong) NSIndexPath * menuIndexPath; // 选中的menu 在tableView中的位置

@property (assign,nonatomic) BOOL showEmojiKeyboardBtn; // 切换键盘
@property (assign,nonatomic) BOOL showAddKeyboardBtn;
@property (assign,nonatomic) BOOL showVoiceKeyboardBtn;


@end

@implementation ChatRoomViewController
#pragma mark - setter 

-(void)setUser:(NIMUser *)user{

    _user = user;
    self.conversationId = user.userId;
}
#pragma mark - getter 

-(NSArray *)messageFrames{
    
    if (_messageFrames == nil) {
        _messageFrames = [[NSMutableArray alloc] init];
    }
    return _messageFrames;
}

// 录音视图
-(RecordView *)recordView{

    if (!_recordView) {
        CGFloat viewHW = 130;
        RecordView * view = [[RecordView alloc] initWithFrame:CGRectMake(0,0, viewHW, viewHW)];
        view.center = self.tableView.center;
        _recordView = view;
        
        [self.view addSubview:_recordView];
        [self.view bringSubviewToFront:_recordView];
        
    }
    return _recordView;
}

// 计算tableViewContentView偏移值
-(CGFloat)getTableViewContentOffsetWithBoardHeight:(CGFloat)height{

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.messageFrames.count-1 inSection:0];
    CGRect lastCellFrame = [self.tableView rectForRowAtIndexPath:indexPath];
    CGFloat offset = CGRectGetMaxY(lastCellFrame);
    NSLog(@"lastceFrame-%@",NSStringFromCGRect(lastCellFrame));
   
    CGFloat toolbarY = self.toolBar.y - height;
    NSLog(@"toobarY -%.f",toolbarY);
    if (offset > toolbarY) {
        return offset - toolbarY;
    }
    return  0;
}

-(void)setShowEmojiKeyboardBtn:(BOOL)showEmojiKeyboardBtn{
    
    _showEmojiKeyboardBtn = showEmojiKeyboardBtn;

    if (showEmojiKeyboardBtn) {
        [self.emojiBtn setImage:[UIImage imageNamed:@"keyboard_hlt"] forState:UIControlStateNormal];

        [UIView animateWithDuration:KeyboardTimeInterval animations:^{
            [self scrollToBottom];
            self.emojiKeyboard.transform = CGAffineTransformMakeTranslation(0, -emojiBoardH);
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, -emojiBoardH);
            
            CGFloat offset = [self getTableContentOffset];
            
            if (offset > 0) {

                if (offset <= emojiBoardH) {
                    self.tableView.transform = CGAffineTransformMakeTranslation(0, -offset);
                }else{
                
                    self.tableView.transform = CGAffineTransformMakeTranslation(0, -emojiBoardH);
                }
            }
        }];
        
    }else{
    
        [self.emojiBtn setImage:[UIImage imageNamed:@"face_hlt"] forState:UIControlStateNormal];
        [UIView animateWithDuration:KeyboardTimeInterval animations:^{
            
            self.emojiKeyboard.transform = CGAffineTransformIdentity;
        }];

    }
}
-(void)setShowAddKeyboardBtn:(BOOL)showAddKeyboardBtn{
    
    _showAddKeyboardBtn = showAddKeyboardBtn;
    
    if (showAddKeyboardBtn) {

        [UIView animateWithDuration:KeyboardTimeInterval animations:^{
            [self scrollToBottom];
            self.addKeyboard.transform = CGAffineTransformMakeTranslation(0, -addBoardH);
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, -addBoardH);
            CGFloat offset = [self getTableContentOffset];
            
            if (offset > 0) {
                
                if (offset <= addBoardH) {
                    self.tableView.transform = CGAffineTransformMakeTranslation(0, -offset);
                }else{
                    
                    self.tableView.transform = CGAffineTransformMakeTranslation(0, -addBoardH);
                }
            }
        }];
    }else{

        [UIView animateWithDuration:KeyboardTimeInterval animations:^{
            
            self.addKeyboard.transform = CGAffineTransformIdentity;
        }];
    }
}

-(void)setShowVoiceKeyboardBtn:(BOOL)showVoiceKeyboardBtn{

    _showVoiceKeyboardBtn = showVoiceKeyboardBtn;

    if (showVoiceKeyboardBtn) {
        [self.voiceBtn setImage:[UIImage imageNamed:@"keyboard_hlt"] forState:UIControlStateNormal];
        self.recordBtn.hidden = NO;
        self.toolBar.inputView.hidden = YES;
        
        if (self.showEmojiKeyboardBtn || self.showAddKeyboardBtn || self.toolBar.inputView.isFirstResponder) {

            self.showEmojiKeyboardBtn = NO;
            self.showAddKeyboardBtn = NO;
            [self.toolBar.inputView resignFirstResponder];
            [UIView animateWithDuration:KeyboardTimeInterval animations:^{
                
                self.tableView.transform = CGAffineTransformIdentity;
                self.toolBar.transform = CGAffineTransformIdentity;
                self.addKeyboard.transform = CGAffineTransformIdentity;
                self.emojiKeyboard.transform = CGAffineTransformIdentity;
                
            }];
        }
    }else{
    
        [self.voiceBtn setImage:[UIImage imageNamed:@"voice_hlt"] forState:UIControlStateNormal];
        self.recordBtn.hidden = YES;
        self.toolBar.inputView.hidden = NO;
        
    }
}

-(void)dealloc{
    
    LastOffset = 0; // 设置消息加载偏移值为初始值 0
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

#pragma mark - ViewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title  = self.user.userInfo.nickName;
    self.view.backgroundColor = IMBgColor;
    [self.view bringSubviewToFront:self.toolBar]; // 让toolbar 在最前面
    UIBarButtonItem * chatInfo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_info_nor"] style:UIBarButtonItemStylePlain target:self action:@selector(chatInfoBtnClick)];
    self.navigationItem.rightBarButtonItem = chatInfo;
    
    // setup tableView
    [self setupTableView];
    
    //setup  toolbar
    [self setupToolbar];
    
    // 添加录音按钮
    [self setupRecordBtn];
    
    // 初始化聊天数据
    [self updateMessagesFromDBWithCompletion:^{
        //让聊天界面滚动到底部
        NSUInteger rows = [self.tableView numberOfRowsInSection:0];
        NSIndexPath * path = [NSIndexPath indexPathForRow:rows-1 inSection:0];//注意：由于行数是从0开始的，所以最后一行是总行数减一个。
        if (rows>0) {
            [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
    
    // 异步加载表情、更多键盘
    [self setupEmojiAndMoreKeyboardView];
    
    // 添加聊天管理代理
    
    [[NIMSDK sharedSDK].chatManager addDelegate:self];

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    // 移除键盘弹出监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

}
-(void)chatInfoBtnClick{
    
    ChatInformationViewController * chatInfoVc = [[ChatInformationViewController alloc] init];
    chatInfoVc.user = self.user;
    chatInfoVc.conversationModel = self.conversationModel;
    
    [chatInfoVc setClearChatMessageBlock:^(BOOL success) {
        if (success) {
            // 清除内存中的数据
            if (self.messageFrames.count > 0) {
                [self.messageFrames removeAllObjects];
                [self.tableView reloadData];
            }
            // 更新会话列表
            Message * message = [WJMessageHelper sendTextMessage:nil to:self.conversationId messageExt:nil];
            message.timestamp = [NSDate currentFormattedDate];
            
            Conversation * cover = [[Conversation alloc] initWithLatestMessage:message];
            ConversationModel * coverModel = [[ConversationModel alloc] initWithConversation:cover];
            coverModel.user = self.user;
            [[DBManager shareManager] creatOrUpdateConversationWith:coverModel];
        }
    }];
    
    [self.navigationController pushViewController:chatInfoVc animated:YES];
}

-(void)setupEmojiAndMoreKeyboardView{

    // 初始化表情键盘

    _emojiKeyboard = [[EmojiKeyboardView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, emojiBoardH * HEIGHT_RATE)];
    _emojiKeyboard.inputView = self.toolBar.inputView;
    _emojiKeyboard.delegate = self;
    WJWeakSelf(weakSelf);
    _emojiKeyboard.completionBlock = ^{
        
        [weakSelf.view addSubview:weakSelf.emojiKeyboard];
    };
    
    // 初始化更多键盘

    _addKeyboard = [[AddOtherFuncKeyboard alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, addBoardH)];
    _addKeyboard.delegate = self;
    [self.view addSubview:_addKeyboard];

}
- (void)setupTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-ToolbarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉分割线
    _tableView.allowsSelection = NO;//不能选中
    _tableView.backgroundColor = IMBgColor;

    UIRefreshControl * refresh = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [refresh addTarget:self action:@selector(refreshToLoadMessages:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refresh];
    
    [self.view addSubview:_tableView];

}

- (void)setupToolbar{

    _toolBar = [[ChatToolBar alloc] init];
    _toolBar.delegate = self;
    [self.view addSubview:_toolBar];
    
    [_toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ToolbarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

// 加载刷新消息

-(void)refreshToLoadMessages:(UIRefreshControl *)refresh{

    if (refresh.refreshing) {
        // 追加新消息的数组最前面
        [self updateMessagesFromDBWithCompletion:^{
            
            [refresh endRefreshing];
        }];
    }
}
// 加载/更新消息
-(void)updateMessagesFromDBWithCompletion:(void (^)(void))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        // 从数据库加载消息
        NSArray * dataArr = [[DBManager shareManager] getMessagesFromTable:self.conversationId lastOffsetValues:LastOffset withLastOffsetHandler:^(NSInteger lastOffset) {
            LastOffset = lastOffset;
        }];

        NSMutableArray * tempArr = [NSMutableArray array];
        
        for (MessageModel * model in dataArr) {
            
            MessageFrame * msgF = [[MessageFrame alloc] init];
            Message * msg = [MessageModel messageWithMessageModel:model convesationId:self.conversationId];
            msgF.aMessage = msg;
            
            if (!model.isRead && ![model.type isEqualToString:@"voice"]) {
               BOOL success = [[DBManager shareManager] messageHasReadFromTable:self.conversationId withMessagesId:@[@(msg.messageId)]];
                if (!success) {
                    NSLog(@"更新已读状态失败");
                }
            }
            [tempArr addObject:msgF];
        }

        if (self.messageFrames.count > 0) { // 添加新消息
            
            NSRange range = NSMakeRange(0, tempArr.count);
            // 创建索引集（存储唯一的，有序的，无符号整数）
            NSIndexSet * set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.messageFrames insertObjects:tempArr atIndexes:set];
        }else{ // 首次消息加载
        
            [self.messageFrames addObjectsFromArray:tempArr];
            
        }
        
        //更新会话记录
         MessageFrame * msg = self.messageFrames.lastObject;
        Conversation * cov = [[Conversation alloc] initWithLatestMessage:msg.aMessage];
        ConversationModel * model = [[ConversationModel alloc] initWithConversation:cov];
        [[DBManager shareManager] updateConversationWithConversationModel:model];

//     // 回调处理其他自定义事件）(同步)
//        [self.tableView reloadData];
//        if (completion) {
//            completion();
//        }
//
        dispatch_async(dispatch_get_main_queue(), ^{

            // 回调处理其他自定义事件）
            [self.tableView reloadData];
            if (completion) {
                completion();
            }
        });
    });
}


#pragma mark - tableView 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageFrames.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 1 创建cell(可重用)
    MessageTableViewCell * cell = [MessageTableViewCell messageCellWithTabelView:tableView andModel:self.messageFrames[indexPath.row]];
    
    cell.delegate = self;
    cell.user = self.user;
    cell.messageFrame = self.messageFrames[indexPath.row];
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return  YES;
}

#pragma mark - tableView 的代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.messageFrames[indexPath.row] rowHeight];
    // 由于这里self返回的是id类型没有点(.)语法，所以改成调用rowHeight的 getter方法来达到目的。
}

#pragma mark - scrollView delegate 

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 退出键盘

    if (self.toolBar.inputView.isFirstResponder) {
        [self.toolBar.inputView resignFirstResponder];
    }
    
    if (self.showAddKeyboardBtn) {
        [UIView animateWithDuration:KeyboardTimeInterval animations:^{
            self.addKeyboard.transform = CGAffineTransformIdentity;
        }];
    }
    if (self.showEmojiKeyboardBtn) {
        [UIView animateWithDuration:KeyboardTimeInterval animations:^{
            self.emojiKeyboard.transform = CGAffineTransformIdentity;
        }];
    }
    if (self.showVoiceKeyboardBtn) {
        [UIView animateWithDuration:KeyboardTimeInterval animations:^{
            self.addKeyboard.transform = CGAffineTransformIdentity;
        }];
    }
    
    [UIView animateWithDuration:(KeyboardTimeInterval) animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
        self.toolBar.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark - Send Message
// 发送消息

-(void)sendMessage:(Message *)message messageDirection:(MessageDirection)direction{
    
    MessageFrame *frame = [[MessageFrame alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        // 包装消息为消息模型，并添加到模型数组中
        message.direction = direction;
        message.timeStr = [NSDate currentFormattedDate];
        message.timestamp = [NSDate currentFormattedDate];
        if (direction == MessageDirectionReceive && message.body.type == MessageBodyTypeVoice){
            message.isRead = NO;
        }else{
            message.isRead = YES;
        }
        // 判断当前消息的时候和上一次消息的时间是否一致
        MessageFrame *lastMsgFrame = [self.messageFrames lastObject];
        Message * lastMsg = lastMsgFrame.aMessage;
        if ([message.timeStr isEqualToString:lastMsg.timeStr]) {
            message.isHideTime = YES;
        }
        
        
        // 缓存消息到沙盒sqlite 数据库
        
        MessageModel * msgModel = [MessageModel modelWithMessage:message];
        BOOL success = [[DBManager shareManager] creatTableOrUpdateMsg:self.conversationId messageModel:msgModel];
        if (!success) {
            NSLog(@"消息缓存数据库失败");
        }
        // 创建并插入会话到数据库（调用框架接口）
        
        Conversation * cover = [[Conversation alloc] initWithLatestMessage:message];
        ConversationModel * coverModel = [[ConversationModel alloc] initWithConversation:cover];
        coverModel.user = self.user;
        [[DBManager shareManager] creatOrUpdateConversationWith:coverModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 添加新消息到消息模型数组
            frame.aMessage = message;
            [self.messageFrames addObject:frame];
            [self.tableView reloadData];
            
            // 更新UI
            [self scrollToBottom];
            CGFloat offset = [self getTableContentOffset];
            
            if (offset > 0 && (offset + self.toolBar.y + self.toolBar.height) <= SCREEN_HEIGHT){
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView.transform = CGAffineTransformMakeTranslation(0, -[self getTableContentOffset]);
                }];
            }
            
            // 发送消息到服务器
            [self sendMessageToServerWithMessage:message];
        });
        
    });
    
}

#pragma mark - 发送消息到服务器

-(void)sendMessageToServerWithMessage:(Message *)message{

    NIMMessage * sendMsg = [[NIMMessage alloc] init];
    NIMSession * msgSession = [NIMSession session:message.conversationId type:NIMSessionTypeP2P];
    
    // 转换对象为数据发送
    switch (message.body.type) {
        case MessageBodyTypeText:{
            
            TextMessageBody * body = (TextMessageBody *)message.body;
            sendMsg.text = body.text;
            
        }
            break;
        case MessageBodyTypeImage:{  // 发送图片消息
        
            ImageMessageBody * body = (ImageMessageBody *)message.body;
            
            NIMImageObject * image = [[NIMImageObject alloc] initWithImage:body.origImage];
            sendMsg.messageObject = image;
            
        }
            break;
        case MessageBodyTypeVoice:{ // 发送语音消息
        
            VoiceMessageBody * body  = (VoiceMessageBody *)message.body;
            
            NIMAudioObject * voice = [[NIMAudioObject alloc] initWithSourcePath:body.voiceLocalPath];
            sendMsg.messageObject = voice;
            
        }
            break;
        default:
            break;
    }
    
    NSError * error = nil;
    
    [[NIMSDK sharedSDK].chatManager sendMessage:sendMsg toSession:msgSession error:&error];
    
}

#pragma mark - NIM消息发送回调

// 即将要发送消息
-(void)willSendMessage:(NIMMessage *)message{

    NSLog(@"将要发送消息");
    MessageFrame * msgF = self.messageFrames.lastObject;
    Message * msg = msgF.aMessage;
    
    msg.status = MessageStatusDelivering;
    
    [self.tableView reloadData];
    
}

// 消息发送进度
-(void)sendMessage:(NIMMessage *)message progress:(float)progress{

    int value = progress * 100;
    NSLog(@"已发送：%d%%",value);
    
}
// 消息已发送完成的回调
-(void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error{

    if (!error) {
        NSLog(@"消息发送成功");
        MessageFrame * msgF = self.messageFrames.lastObject;
        Message * msg = msgF.aMessage;
        
        msg.status = MessageStatusSuccessed;
        [self.tableView reloadData];
        
    }else{
    
        NSLog(@"消息发送失败Error:%@",error);
    }
}

// 接收到了消息
-(void)onRecvMessages:(NSArray<NIMMessage *> *)messages{

    for (NIMMessage *msg in messages) {
        
        Message * recvMsg = nil;

        switch (msg.messageType) {
            case NIMMessageTypeText:
            {
                recvMsg = [WJMessageHelper receivedTextMessage:msg.text from:msg.from];
                NSDate * date = [NSDate dateWithTimeIntervalSince1970:msg.timestamp];
                recvMsg.timeStr = [date defaultFormattedDate];
                recvMsg.timestamp = [date defaultFormattedDate];
                recvMsg.direction = MessageDirectionReceive;
                recvMsg.isHideTime = [lastTime isEqualToString:recvMsg.timeStr]? YES:NO;
                lastTime = recvMsg.timeStr;
            }
                break;
                
            default:
                break;
        }
        
        [self sendMessage:recvMsg messageDirection:MessageDirectionReceive];
    }
}
// 收到了消息回执
-(void)onRecvMessageReceipt:(NIMMessageReceipt *)receipt{
    NSLog(@"收到消息回执:%@",receipt.session.sessionId);
}

#pragma mark - 发送文本消息

-(void)sendTextMessage:(NSString *)text withDirection:(MessageDirection)direction{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.toolBar.height = ToolbarHeight;
    }];
    
    if (text.length > 0) {
        // 包装消息对象
        NSDictionary * extMsg = [NSDictionary dictionary];
        Message * message = [WJMessageHelper sendTextMessage:text to:self.conversationId messageExt:extMsg];
        [self sendMessage:message messageDirection:MessageDirectionSend];
    }
}

#pragma mark - 发送图片消息

- (void)sendImageMessageWithData:(NSData *)imageData localPath:(NSString *)localPath{
    // 设置发送进度
        //发送消息
    Message * msg = [WJMessageHelper sendImageMessageWithImageData:imageData localPath:localPath to:self.conversationId messageExt:nil];
    [self sendMessage:msg messageDirection:MessageDirectionSend];
    
}

- (void)sendImageMessage:(UIImage *)image{

     // 设置发送进度
    //发送消息
    Message * msg = [WJMessageHelper sendImageMessageWithImage:image to:self.conversationId messageExt:nil];
    [self sendMessage:msg messageDirection:MessageDirectionSend];
}

#pragma  mark - 发送语音消息

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration
{
    Message *message = [WJMessageHelper sendVoiceMessageWithLocalPath:localPath duration:(int)duration to:self.conversationId messageExt:nil];
    [self sendMessage:message messageDirection:MessageDirectionSend];
}

#pragma mark - 接收到新消息回调
// 接收消息
-(void)receivedNewMessages:(NSArray *)messages{

    for (Message *msg in messages) {
        
        [self sendMessage:msg messageDirection:MessageDirectionReceive];
    }
}

#pragma mark - 键盘frame改变通知

- (void)keyboradWillChangeFrame:(NSNotification *)noti{
    
    //注意： 键盘弹出之前首先要考虑是否有其他键盘是第一响应者，如果有就需要先设置为NO后再弹出
    
    if (self.showEmojiKeyboardBtn) {
        self.showEmojiKeyboardBtn = NO;
    }
    if (self.showAddKeyboardBtn) {
        self.showAddKeyboardBtn = NO;
    }
    
    CGFloat duration = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect frame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //获取view需要向上偏移的y值
    CGFloat offsetY = frame.origin.y - self.view.frame.size.height;    // y值随着键盘的显示在变化
    //NSLog(@"键盘offsetY-%.f",offsetY);
    [self scrollToBottom];
    
    [UIView animateWithDuration:duration animations:^{
        
        if (offsetY != 0) { // 只有当键盘出来的时候才偏移，推出的时候不偏移
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, offsetY);
        }else{
            
            if (self.toolBar.inputView.isFirstResponder) {
                if (self.showVoiceKeyboardBtn) { // 如果点击的是语音按钮
                    self.toolBar.transform = CGAffineTransformMakeTranslation(0, offsetY);
                }else{
                    
                    self.toolBar.transform = CGAffineTransformMakeTranslation(0, frame.size.height - emojiBoardH);
                }
            }
        }
        
        CGFloat tableContentOffset = [self getTableContentOffset];
        
        if (tableContentOffset > 0 ) {
            // NOTE:当偏移量大于0 且小于键盘的高度时，偏移量是多少就让content 向上偏移多少，如果超过键盘高度就让content 固定偏移键盘的高度即可。
            if (tableContentOffset >= frame.size.height) {
                self.tableView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
            }else{
                
                self.tableView.transform = CGAffineTransformMakeTranslation(0, -tableContentOffset);
            }
        }
    }];
}

#pragma mark - toolbar delegate

-(void)chatToolBar:(ChatToolBar *)toolBar textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 0) {
        self.emojiKeyboard.sendBtn.enabled = YES;
    }else{
        self.emojiKeyboard.sendBtn.enabled = NO;
    }
}
-(void)chatToolBar:(ChatToolBar *)toolBar textViewDidBeginEditing:(UITextView *)textView{
    
}

// 点击send 触发
-(BOOL)chatToolBar:(ChatToolBar *)toolBar textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        //表情图片解析后的消息文本
        NSString *messageText = [[self.toolBar.inputView.textStorage getPlainString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        // 发送文本消息按钮点击事件
        
        [self sendTextMessage:messageText withDirection:MessageDirectionSend];
        textView.text = nil;
        return NO;
    }
    return YES;
}

// 表情按钮点击
-(void)chatToolBar:(ChatToolBar *)toolBar emojiBtnDidClick:(UIButton *)btn{
    _emojiBtn = btn;

    if (self.showVoiceKeyboardBtn) {
        self.showVoiceKeyboardBtn = NO;
    }
    if (self.showAddKeyboardBtn) {
        self.showAddKeyboardBtn = NO;
    }
    if (self.toolBar.inputView.isFirstResponder) {
        [self.toolBar.inputView resignFirstResponder];
    }
    if (self.showEmojiKeyboardBtn) {
        
        self.showEmojiKeyboardBtn = NO;
        [self.toolBar.inputView becomeFirstResponder];
        
    }else{
        
        self.showEmojiKeyboardBtn = YES; // 弹出表情键盘
        
    }
}

// 更多按钮点击

-(void)chatToolBar:(ChatToolBar *)toolBar addBtnDidClick:(UIButton *)btn{

    _addBtn = btn;
    
    if (self.showVoiceKeyboardBtn) {
        self.showVoiceKeyboardBtn = NO;
    }
    if (self.showEmojiKeyboardBtn) {
        self.showEmojiKeyboardBtn = NO;
    }
    if (self.toolBar.inputView.isFirstResponder) {
        [self.toolBar.inputView resignFirstResponder];
    }
    
    if (self.showAddKeyboardBtn) {
        
        self.showAddKeyboardBtn = NO;
        [self.toolBar.inputView becomeFirstResponder];
        
    }else{
        
        self.showAddKeyboardBtn = YES; // 弹出更多键盘
    }

}
// 语言按钮点击

-(void)chatToolBar:(ChatToolBar *)toolBar voiceBtnDidClick:(UIButton *)btn{

    _voiceBtn = btn;
    
    if (self.showVoiceKeyboardBtn) {
        
        self.showVoiceKeyboardBtn = NO;
        [self.toolBar.inputView becomeFirstResponder];
        
    }else{
        
        self.showVoiceKeyboardBtn = YES; // 弹出语音按钮
    }
}


#pragma mark - recordBtn touch actions

// 创建录音按钮
-(void)setupRecordBtn{
    
    UIButton * recordBtn = [[UIButton alloc] init];
    _recordBtn = recordBtn;
    [recordBtn setBackgroundImage:[UIImage imageNamed:@"word_input"] forState:UIControlStateNormal];
    [recordBtn setBackgroundImage:[UIImage imageNamed:@"voice_press_bg"] forState:UIControlStateHighlighted];
    [recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [recordBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    [recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recordBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
    recordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    recordBtn.hidden = YES;
    recordBtn.layer.cornerRadius = 5;
    recordBtn.layer.masksToBounds = YES;
    recordBtn.layer.borderColor = WJRGBColor(218, 218, 218).CGColor;
    recordBtn.layer.borderWidth = 0.5;
    
    [self.recordBtn addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.recordBtn addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [self.recordBtn addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];
    
    [self.toolBar addSubview:recordBtn];
    
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolBar);
        make.left.right.equalTo(self.toolBar.inputView);
        make.height.mas_equalTo(self.toolBar.inputView.mas_height);
    }];
    
}

// 当按下录音按钮时触发（开始录音）
- (void)recordButtonTouchDown
{
    // 1. 通知recordView 录音按钮按下了
    
    [self.recordView recordButtonTouchDown];
    // 2. 开始录音
    if ([self canRecord]) {
        
        int x = arc4random() % 100000; // 一个范围在100000 内的随机数
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];// 返回从1970/01/01到现在的间隔时间
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error)
         {
             if (error) {
                 NSLog(@"%@",NSEaseLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }
         }];
    }
}

// 在按钮范围外抬起手指（停止发送）
- (void)recordButtonTouchUpOutside
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    [self.recordView recordButtonTouchUpOutside];
    [self.recordView removeFromSuperview];

}
// 在按钮范围内抬起手指（完成发送）
- (void)recordButtonTouchUpInside
{
    self.recordBtn.enabled = NO;
    self.recordView.hidden = YES;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            
            [self sendVoiceMessageWithLocalPath:recordPath duration:aDuration];
            NSLog(@"录音时长-%ld，录音文件路径-%@",aDuration,recordPath);
            [self.recordView removeFromSuperview];
        }
        else {
            // TODO: 添加时间过短提示
            self.recordView.hidden = NO;
            [self.recordView recordTimeTooShort];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.recordView removeFromSuperview];
            });
        }
    }];
    
    [self.recordView recordButtonTouchUpInside];
    
    self.recordBtn.enabled = YES;
}

//手指移动到按钮范围外时触发（更换recordView 上的文字）
- (void)recordDragOutside
{
    [self.recordView recordButtonDragOutside];
}
// 手指移动到按钮范围内时触发
- (void)recordDragInside
{
    [self.recordView recordButtonDragInside];
}

#pragma mark - EmojiKeyboardDelegate 

-(void)emojiBtnDidClick:(UIButton *)btn{
    
    // 回调改变输入框的高度
    WJWeakSelf(weakSelf);
    self.toolBar.inputView.textHeightChangeBlock = ^(NSString * text,CGFloat textHeight){
        
        weakSelf.toolBar.height = textHeight + 10;
    };
    if (!self.emojiKeyboard.sendBtn.enabled) {
        self.emojiKeyboard.sendBtn.enabled = YES;
    }
}

-(void)sendBtnDicClick:(UIButton *)btn{
    
    //表情图片解析后的消息文本
    NSString *messageText = [[self.toolBar.inputView.textStorage getPlainString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self sendTextMessage:messageText withDirection:MessageDirectionSend];
    self.toolBar.inputView.text = nil;
    self.emojiKeyboard.sendBtn.enabled = NO;
    
}


#pragma mark - AddFuncKeyboardDelegate 

-(void)funcKeyboard:(UIView *)keyboard didBeginSendPhotosWithType:(AddKeyboardBtnType)btnType{

    switch (btnType) {
        case AddKeyboardBtnTypeSendPhoto:
            //发送照片
            [self openAlbum];
            break;
        case AddKeyboardBtnTypeTakePhoto:
            //拍摄照片
            [self openCamera];
            break;
        case AddKeyboardBtnTypeVideo:
             // 视频聊天
            [self openVideo];
            break;
        case AddKeyboardBtnTypeSendFile:
            [self sendFiles];
            break;
        case AddKeyboardBtnTypeLocation:
            [self sendLocation];
            break;
        case AddKeyboardBtnTypeWhiteBoard:
            [self openArtBoard];
            break;;
        default:
            break;
    }
}

-(void)openVideo{

// 进入视频通话
}
// send photos
-(void)openCamera{
    
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

-(void)openAlbum{
    
    
    //[self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    TZImagePickerController * pickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    [pickerVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> * photos, NSArray * assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> * infos) {
        
        for ( int i = 0; i<photos.count; i++) {
            
            NSData * imgData = UIImagePNGRepresentation(photos[i]);
            
            NSString * imageName = [NSString stringWithFormat:@"%.f%d",[[NSDate date] timeIntervalSince1970],i];
            
            NSString * relativePath = [[MessageReadManager shareManager] saveMsgAttachWithData:imgData attachType:MessageBodyTypeImage andAttachName:imageName];
            
            [self sendImageMessageWithData:imgData localPath:relativePath];
        }
    }];
    
    [self presentViewController:pickerVc animated:YES completion:nil];
    
}

-(void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        
        UIImagePickerController * ipc = [[UIImagePickerController alloc] init];
        ipc.delegate = self;
        ipc.sourceType = type;
        [self presentViewController:ipc animated:YES completion:nil];
    }else{
        
        NSLog(@"相机不可用");
        [MBProgressHUD showErrorWithText:@"相机不可用"];
    }
    
}

// send files
-(void)sendFiles{
    NSLog(@"发送文件");
}

- (void)sendLocation{

    NSLog(@"发送地理位置");
    
    MapViewController * mapVc = [[MapViewController alloc] init];
    
    MainNavController * nav = [[MainNavController alloc] initWithRootViewController:mapVc];
    
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)openArtBoard{
    
    ArtboardViewController * artboardVc = [[ArtboardViewController alloc] init];
    
    WJWeakSelf(weakSelf);
    artboardVc.completion = ^(UIImage *image) {
        
        NSData * imageData = UIImagePNGRepresentation(image);
        NSString * imageName = [NSString stringWithFormat:@"%@_%@",[NSDate date],self.conversationId];
        NSString * imagePath = [[MessageReadManager shareManager] saveMsgAttachWithData:imageData attachType:MessageBodyTypeImage andAttachName:imageName];
        
        [weakSelf sendImageMessageWithData:imageData localPath:imagePath];
        
    };
    
    [self presentViewController:artboardVc animated:YES completion:nil];
    
}


#pragma  mark - imagePickerVcDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) { // 视频文件
    
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        //NSURL *mp4 = [self _convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        //[self sendVideoMessageWithURL:mp4]; 发送视频消息
    }else{ // 图片文件
    
        NSURL *url = info[UIImagePickerControllerReferenceURL];

        if (url == nil) { // 注意：实时拍摄的图片没有 ReferenceURL 属性，只有 origImage 数据
            
            UIImage *orgImage = info[UIImagePickerControllerOriginalImage];//原始图片
            NSData * imageData = UIImageJPEGRepresentation(orgImage, 0.6);
            NSString * imageName = [NSString stringWithFormat:@"%@_%@",[NSDate date],self.conversationId];

            if (imageData.length > 10 * 1024 * 1024) { // 需小于10M
                [MBProgressHUD showErrorWithText:@"图片太大请重新选择"];
                return;
            }
            NSString * relativePath = [[MessageReadManager shareManager] saveMsgAttachWithData:imageData attachType:MessageBodyTypeImage andAttachName:imageName];
            
            [self sendImageMessageWithData:imageData localPath:relativePath];

        } else {
            
            NSString * imageName = [self getOriginalImageNameWithURL:url.absoluteString];
            if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0f) {
                PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset *asset , NSUInteger idx, BOOL *stop){
                    if (asset) {
                        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *data, NSString *uti, UIImageOrientation orientation, NSDictionary *dic){

                            if (data) {
                                
                                if (data.length > 10 * 1024 * 1024) { // 小于10m
                                    [MBProgressHUD showErrorWithText:@"图片太大请重新选择"];
                                    return;
                                }
                                NSString * relativePath = [[MessageReadManager shareManager] saveMsgAttachWithData:data attachType:MessageBodyTypeImage andAttachName:imageName];
                                // 注意：存向数据库的图片资源使用其名称（由于沙盒路径是动态的，存放相对路径）
                                [self sendImageMessageWithData:data localPath:relativePath];
                                
                            }
                        }];
                    }
                }];
            } else {
                ALAssetsLibrary *alasset = [[ALAssetsLibrary alloc] init];
                [alasset assetForURL:url resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
                        Byte* buffer = (Byte*)malloc((size_t)[assetRepresentation size]);
                        NSUInteger bufferSize = [assetRepresentation getBytes:buffer fromOffset:0.0 length:(NSUInteger)[assetRepresentation size] error:nil];
                        NSData* fileData = [NSData dataWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
                        if (fileData.length > 10 * 1024 * 1024) { // 小于10m
                            [MBProgressHUD showErrorWithText:@"图片太大请重新选择"];
                            return;
                        }
                        NSString * relativePath = [[MessageReadManager shareManager] saveMsgAttachWithData:fileData attachType:MessageBodyTypeImage andAttachName:imageName];
                        [self sendImageMessageWithData:fileData localPath:relativePath];

                    }
                } failureBlock:NULL];
            }
        }
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark  - cell 点击事件代理 tableView cell delegate

// 消息内容点击事件
-(void)messageCell:(id)messageCell SelectedWithModel:(MessageFrame *)model{

    MessageBody * body = model.aMessage.body;
    switch (body.type) {
        case MessageBodyTypeText:
            [self textMessageCellSelected:body cell:messageCell];
            break;
        case MessageBodyTypeImage:
            [self imageMessageCellSelected:body];
            break;
        case MessageBodyTypeVoice:
            [self voiceMessageCell:messageCell selected:model];
            break;
        case MessageBodyTypeFile:
            [self fileMessageCell:messageCell selected:model];
            break;
        default:
            break;
    }
}

// 头像点击事件
-(void)avatarViewSelcted:(MessageFrame *)model{
    // 跳转联系人详情页面

    NSString * userId;
    if (model.aMessage.direction == MessageDirectionSend) {
        userId = [[NIMSDK sharedSDK].loginManager currentAccount];
    }else{
    
        userId = self.user.userId;
    }
    
    ContactsDetailViewController * detailVc = [[ContactsDetailViewController alloc] initWithUserId:userId];

    detailVc.hidesBottomBarWhenPushed = YES;
    detailVc.previousVc = self;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

//消息内容长按事件

-(BOOL)canBecomeFirstResponder{ // 只有self可以成为第一响应者时才能弹出menuItem

    return YES;
}
// 筛选 menuItem
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    //NSLog(@"sender:%@,actions:%@",sender,NSStringFromSelector(action));
    //注意： 这里可以通过判断当前第一响应者来筛选保留哪些menuItem
    if (self.toolBar.inputView.isFirstResponder) {
        
        if (action == @selector(paste:)) {
            return YES;
        }
    }else{
        
        if (action == @selector(copyMenuItemClick) ||
            action == @selector(deleteMenuItemClick) ||
            action == @selector(transferMenuItemClick)) {
            return YES;
        }
    }
    
    return NO;
}
    
    
-(void)messageCell:(id)messageCell didLongPress:(UILongPressGestureRecognizer *)recognizer WithModel:(Message *)model{

    MessageBody * body = model.body;
    self.activeMessage = model;
    UIButton * contentCell = (UIButton *)messageCell;
    
    //WJ: 通过cell的长按手势位置来识别是按压是那个cell
    CGPoint location = [recognizer locationInView:self.tableView];
    _menuIndexPath = [self.tableView indexPathForRowAtPoint:location];

    if (![self becomeFirstResponder]) {
        NSLog(@"pop菜单显示失败");
        return;
    }
    
    UIMenuController * menuCtrl = [UIMenuController sharedMenuController];
    
    UIMenuItem * copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuItemClick)];
    UIMenuItem * delete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuItemClick)];
    UIMenuItem * transfer = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transferMenuItemClick)];
    
    [menuCtrl setTargetRect:contentCell.bounds inView:contentCell];
    
    switch (body.type) {
        case MessageBodyTypeText:
        {
            // 复制，删除,转发
            menuCtrl.menuItems = @[copy,delete,transfer];
            [menuCtrl setMenuVisible:YES animated:YES];
        }
            break;
        case MessageBodyTypeImage:
        {
            // 删除，转发
            menuCtrl.menuItems = @[delete,transfer];
            [menuCtrl setMenuVisible:YES animated:YES];
        }
            break;
        case MessageBodyTypeVoice:
        {
            // 删除
            menuCtrl.menuItems = @[delete];
            [menuCtrl setMenuVisible:YES animated:YES];
        }
            break;
        case MessageBodyTypeFile:
        {
            // 删除，转发
            menuCtrl.menuItems = @[delete,transfer];
            [menuCtrl setMenuVisible:YES animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - cell menuItem 点击事件

-(void)copyMenuItemClick{

    MessageBody * body = self.activeMessage.body;
    
    if (body.type == MessageBodyTypeText) {
        TextMessageBody * textBody = (TextMessageBody *)body;
        [UIPasteboard generalPasteboard].string = textBody.text;
    }
}

-(void)deleteMenuItemClick{
    
    // 删除处理原则：先删除数据库，远端返回删除成功后才删除内存中的数据源，再去执行deleteRow 刷新UI
    // 删除数据库消息并更新数据源
    BOOL success = [[DBManager shareManager] deleteMessageFromTable:self.activeMessage.conversationId withMessage:self.activeMessage];
    
    if (success) {
        
        // 删除内存数据
        [self.messageFrames removeObjectAtIndex:_menuIndexPath.row];//注意：先要移除数据源
        
        // 更新ui
        NSUInteger rows = [self.tableView numberOfRowsInSection:0];
        NSIndexPath * path = [NSIndexPath indexPathForRow:rows-1 inSection:0];//注意：由于行数是从0开始的，所以最后一行是总行数减一
        //[self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        _menuIndexPath = nil;
        // 更新会话数据
            // TODO:
        [self.tableView reloadData];
    }
}

-(void)transferMenuItemClick{

    // 跳转联系人选择页面，传给要转发的消息，点击联系人后，调用消息发送接口，同时存储数据库，然后给出提示发送完成，退出联系人选择界面。
    NSLog(@"消息转发");
    
}

#pragma mark - 聊天窗口中各个聊天消息的点击事件处理方法

// 文字消息点击
-(void)textMessageCellSelected:(MessageBody *)messageBody cell:(UITableViewCell *)cell{
    NSLog(@"点击了内容btn");
    MessageTableViewCell * currentCell = (MessageTableViewCell *)cell;
    TextMessageBody * textBody = (TextMessageBody *)messageBody;
    if ([textBody.text containsString:@"---------------------------\n点击查看>>"]) {
        currentCell.contentBtn.adjustsImageWhenHighlighted = YES;// 开启cell点击高亮效果
        NSLog(@"跳转到我的咨询者页面...");
    }
}

// 图片点击
- (void)imageMessageCellSelected:(MessageBody *)messageBody{

    BOOL imageDownloadSuccess = YES; // 这里需要判断接收的图片文件是否已经下载成功
    ImageMessageBody * imgBody  = (ImageMessageBody *)messageBody;
    
    if (imageDownloadSuccess) {

        if (imgBody.origImage) {
            [[MessageReadManager shareManager] showBrowserWithImages:@[imgBody.origImage]];
            
        }else{
        
            NSLog(@"读取%@图片失败-error:%@",imgBody.imageName,imgBody.imageLocalPath);
        }
    }else{
        //如果图片没下在成功，在这里调用聊天管理器单例的下载消息附件方法，下载后再次显示
    }
}

// 语音点击
-(void)voiceMessageCell:(id)cell selected:(MessageFrame *)model{

    BOOL voiceDownloadSuccess = YES;
    MessageTableViewCell * messageCell = (MessageTableViewCell *)cell;
    VoiceMessageBody * body = (VoiceMessageBody *)model.aMessage.body;
    if (voiceDownloadSuccess) {
        // 标记已读/更新UI
        if (!model.aMessage.isRead) {
            model.aMessage.isRead = YES;
            [self.tableView reloadData];
            BOOL success = [[DBManager shareManager] messageHasReadFromTable:self.conversationId withMessagesId:@[@(model.aMessage.messageId)]];
            if (success) {
                // 去掉红点
                [messageCell.redDot removeFromSuperview];
            }
        }
        
        __weak typeof(self) weakSelf = self;
        
        BOOL isPrepare = [[MessageReadManager shareManager] prepareMessageAudioModel:model updateViewCompletion:^(MessageFrame *prevAudioModel, MessageFrame *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            //NSLog(@"语言测试路径--%@",body.voiceLocalPath);
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:body.voiceLocalPath completion:^(NSError *error) {
                // 播放语言完成回调block
                [[MessageReadManager shareManager] stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(self) strongSelf = weakSelf;
                    [strongSelf.tableView reloadData];
                    strongSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}

// 文件点击
-(void)fileMessageCell:(id)cell selected:(MessageFrame *)model{

    NSLog(@"功能暂未使用");

}

#pragma mark - private helper // 私有的工具方法
//消息滚动到最底部
-(void)scrollToBottom{
    
    if (self.messageFrames.count > 0) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.messageFrames.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
// 获取tableView 偏移值
-(CGFloat)getTableContentOffset{
    
    NSInteger lastRow = self.messageFrames.count - 1;
    if (lastRow >= 0) {
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
        CGRect lastRowRect = [self.tableView rectForRowAtIndexPath:indexPath];
        CGFloat lastRowMaxY = CGRectGetMaxY(lastRowRect) + 64;
        //NSLog(@"lastRow:%.f,toobarY:%.f",lastRowMaxY,self.toolBar.y);
        if (lastRowMaxY  >= (self.toolBar.y)) {
            return lastRowMaxY - self.toolBar.y;
        }
    }
    
    return 0;
}

- (NSURL *)_convert2Mp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [self dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

//语音文件缓存目录
- (NSString*)dataPath
{
    NSString *dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dataPath]){
        [fm createDirectoryAtPath:dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    return dataPath;
}

//判断是否可以录音
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

// 获取图片的名字
- (NSString *)getOriginalImageNameWithURL: (NSString *)referenceURL{
    
    NSArray *splitArray = [referenceURL componentsSeparatedByString:@"?"];
    splitArray = [splitArray[1] componentsSeparatedByString:@"&"];
    NSMutableString *returnValue = [NSMutableString new];
    [returnValue appendString:[splitArray[0] componentsSeparatedByString:@"="][1]];
    [returnValue appendString:@"."];
    [returnValue appendString:[splitArray[1] componentsSeparatedByString:@"="][1]];
    return returnValue;
}


@end
