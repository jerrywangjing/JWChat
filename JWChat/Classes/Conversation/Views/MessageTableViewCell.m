//
//  MessageTableViewCell.m
//  ESDemo
//
//  Created by jerry on 16/9/9.
//  Copyright © 2016年 Zhang, Lawrence. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MessageFrame.h"
#import "UIImage+Extension.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ContactsModel.h"


NSString *const EaseMessageCellIdentifierRecvText = @"EaseMessageCellRecvText";
NSString *const EaseMessageCellIdentifierRecvLocation = @"EaseMessageCellRecvLocation";
NSString *const EaseMessageCellIdentifierRecvVoice = @"EaseMessageCellRecvVoice";
NSString *const EaseMessageCellIdentifierRecvVideo = @"EaseMessageCellRecvVideo";
NSString *const EaseMessageCellIdentifierRecvImage = @"EaseMessageCellRecvImage";
NSString *const EaseMessageCellIdentifierRecvFile = @"EaseMessageCellRecvFile";

NSString *const EaseMessageCellIdentifierSendText = @"EaseMessageCellSendText";
NSString *const EaseMessageCellIdentifierSendLocation = @"EaseMessageCellSendLocation";
NSString *const EaseMessageCellIdentifierSendVoice = @"EaseMessageCellSendVoice";
NSString *const EaseMessageCellIdentifierSendVideo = @"EaseMessageCellSendVideo";
NSString *const EaseMessageCellIdentifierSendImage = @"EaseMessageCellSendImage";
NSString *const EaseMessageCellIdentifierSendFile = @"EaseMessageCellSendFile";

@interface MessageTableViewCell()

@property (nonatomic,weak) UILabel * timeView;
@property (nonatomic,weak) UIImageView * iconView;
//@property (nonatomic,weak) UIButton * contentBtn; // 已移到外部接口

@property (nonatomic,weak) UIImageView * voiceView;
@property (nonatomic,weak) UILabel * secLabel;

@property (nonatomic,weak) UIImageView * fileType;
@property (nonatomic,weak) UILabel * fileName;
@property (nonatomic,weak) UILabel * fileSize;

@property (nonatomic,strong) NSArray * sendMessageVoiceAnimationImages;
@property (nonatomic,strong) NSArray * recvMessageVoiceAnimationImages;
//@property (nonatomic, strong) UIActivityIndicatorView *activity; // 发送网络状态显示
//
//@property (strong, nonatomic) UILabel *nameLabel; // 好友姓名/昵称
//
//@property (strong, nonatomic) UIButton *statusButton; // 消息发送状态指示
//
//@property (strong, nonatomic) UILabel *hasRead; // 是否已读
//
//@property (strong, nonatomic) EaseBubbleView *bubbleView; //不同消息类型的显示视图（语言、图片、文件）

@end

@implementation MessageTableViewCell

-(NSArray *)sendMessageVoiceAnimationImages{

    if (!_sendMessageVoiceAnimationImages) {
        _sendMessageVoiceAnimationImages = @[ [UIImage imageNamed:@"UIResource.bundle/chat_sender_audio_playing_000"], [UIImage imageNamed:@"UIResource.bundle/chat_sender_audio_playing_001"], [UIImage imageNamed:@"UIResource.bundle/chat_sender_audio_playing_002"], [UIImage imageNamed:@"UIResource.bundle/chat_sender_audio_playing_full"]];
    }
    return _sendMessageVoiceAnimationImages;
}

-(NSArray *)recvMessageVoiceAnimationImages{

    if (!_recvMessageVoiceAnimationImages) {
        _recvMessageVoiceAnimationImages = @[[UIImage imageNamed:@"UIResource.bundle/chat_receiver_audio_playing000"], [UIImage imageNamed:@"UIResource.bundle/chat_receiver_audio_playing001"], [UIImage imageNamed:@"UIResource.bundle/chat_receiver_audio_playing002"], [UIImage imageNamed:@"UIResource.bundle/chat_receiver_audio_playing_full"]];

    }
    return _recvMessageVoiceAnimationImages;
}

-(UIImageView *)fileType{

    if (!_fileType) {
        UIImageView * fileType = [[UIImageView alloc] init];
        _fileType = fileType;
        _fileType.userInteractionEnabled = YES;
        [_contentBtn addSubview:_fileType];
    }
    
    return _fileType;
}
-(UILabel *)fileName{

    if (!_fileName) {
        UILabel * fileName = [[UILabel alloc] init];
        _fileName = fileName;
        [_contentBtn addSubview:_fileName];
    }
    return _fileName;
}
-(UILabel *)fileSize{

    if (!_fileSize) {
        UILabel * fileSize = [[UILabel alloc] init];
        _fileSize = fileSize;
        [_contentBtn addSubview:_fileSize];
    }
    return _fileSize;
}
+(instancetype)messageCellWithTabelView:(UITableView *)tableView andModel:(MessageFrame *)model{
    
    NSString * cellIdentifier = [self cellIdentifierWithModel:model];
    // 首先调用tableView的可重用方法获取已经创建的cell
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果为获取到则创建新cell
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

// 创建子控件（重写构造方法）
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 去掉cell的背景颜色
        self.backgroundColor = [UIColor clearColor];

        // 时间
        UILabel * timeViwe = [[UILabel alloc] init];
        timeViwe.backgroundColor = WJRGBColor(195, 195, 195);
        timeViwe.layer.cornerRadius = 4;
        timeViwe.layer.masksToBounds = YES;
        timeViwe.adjustsFontSizeToFitWidth = YES;
        timeViwe.font = [UIFont systemFontOfSize:12];
        timeViwe.textColor = [UIColor whiteColor];
        [self.contentView addSubview:timeViwe];
        self.timeView = timeViwe;
        // 设置lable的文字居中(Alignment译为：位置)
        timeViwe.textAlignment = NSTextAlignmentCenter;
        // 头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        _iconView = iconView;
        _iconView.layer.cornerRadius = 5;
        _iconView.layer.masksToBounds = YES;
        _iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageTap:)];
        [_iconView addGestureRecognizer:tap];
        
        // 聊天内容
        UIButton * contentButton = [[UIButton alloc] init];
        [self.contentView addSubview:contentButton];
        _contentBtn = contentButton;
        [_contentBtn addTarget:self action:@selector(cellContentClick:) forControlEvents:UIControlEventTouchUpInside];
            // 添加长按手势
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentCellDidLongPress:)];
        longPress.minimumPressDuration = 0.5; // 默认 0.5
        [_contentBtn addGestureRecognizer:longPress];
            // 语音logo、秒数、小红点
        UIImageView * voiceView = [[UIImageView alloc] init];
        self.voiceView = voiceView;
        UILabel * secLabel = [[UILabel alloc] init];
        self.secLabel = secLabel;
        UIImageView * redDot = [[UIImageView alloc] init];
        redDot.layer.cornerRadius = 4;
        redDot.layer.masksToBounds = YES;
        self.redDot = redDot;
        redDot.backgroundColor = [UIColor redColor];
        [_contentBtn addSubview:secLabel];
        [_contentBtn addSubview:voiceView];
        [_contentBtn addSubview:redDot];

        _contentBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _contentBtn.titleLabel.numberOfLines = 0;
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        

    }
    return self;
}

#pragma mark - 重写属性的setter方法(给子控件赋值)

-(void)setMessageFrame:(MessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;//注意setter中首先得写这行
    Message * msg = messageFrame.aMessage;
    // 给时间赋值
    self.timeView.text = msg.timeStr;

    // 给头像赋值
    
    if (msg.direction == MessageDirectionSend) {
        NSString * currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
        NIMUser * currentUserInfo = [[NIMSDK sharedSDK].userManager userInfo:currentUserId];
        
        [_iconView sd_setImageWithURL:[NSURL URLWithString:currentUserInfo.userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];

    }else{
    
        [_iconView sd_setImageWithURL:[NSURL URLWithString:self.user.userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];

    }
    
    // 消息背景图片
    if (msg.direction == MessageDirectionSend) {
        
        [_contentBtn setBackgroundImage:[UIImage resizeImage:@"char_myself_bg"] forState:UIControlStateNormal];
        [_contentBtn setBackgroundImage:[UIImage resizeImage:@"chat_send_press_pic"] forState:UIControlStateHighlighted];
    }else{
        
        [_contentBtn setBackgroundImage:[UIImage resizeImage:@"chat_duifang_bg"] forState:UIControlStateNormal];
        [_contentBtn setBackgroundImage:[UIImage resizeImage:@"chat_recive_press_pic"] forState:UIControlStateHighlighted];
    }

    // 设置子控件的frame
    self.iconView.frame = messageFrame.iconFrame;
    self.contentBtn.frame = messageFrame.contentFrame;
    
    if (!msg.isHideTime) {
        self.timeView.frame = messageFrame.timeFrame;
    }else{
        //注意：考虑到cell可重用问题，这里必须要有else判断，如果隐藏时间则timeView的Label大小（frame）置零。
        self.timeView.frame = CGRectZero;
    }
    // 给聊天内容按钮赋值
    @synchronized (self) {
        [self setMessageContent:msg]; // 注意：**需要先给子控件赋值frame 后再给内容赋值
    }
    
}

#pragma mark - cell 内容赋值
-(void)setMessageContent:(Message *)message{

    switch (message.body.type) {
        case MessageBodyTypeText:
            // 设置文本消息
            [self setTextMessage:message];
            break;
        case MessageBodyTypeImage:
            // 设置图片消息
            [self setImageMessageCell:message];
            break;
        case MessageBodyTypeVoice:
            // 设置语言消息
            [self setVoiceMessageCell:message];
            break;
        case MessageBodyTypeFile:
            // 设置文件消息
            [self setFileMessageCell:message];
            break;
        default:
            break;
    }
}

-(void)setTextMessage:(Message *)message{

    TextMessageBody *body = (TextMessageBody *)message.body;
    _contentBtn.adjustsImageWhenHighlighted = NO;
    
    // 转字符串为富文本字符串
    UIColor * attriStrColor = message.direction == MessageDirectionSend ? [UIColor whiteColor]: WJRGBColor(70, 96, 114);
    NSMutableAttributedString * attributText = [EmotionImageFormateTool replacedEmotionStrWithStr:body.text strFont:[UIFont systemFontOfSize:FontSize] textColor:attriStrColor];
    
    [_contentBtn setAttributedTitle:attributText forState:UIControlStateNormal];
    
}


-(void)setImageMessageCell:(Message *)message{

    ImageMessageBody * body = (ImageMessageBody *)message.body;
    
    _contentBtn.layer.cornerRadius = 5;
    _contentBtn.layer.masksToBounds = YES;

    [_contentBtn setBackgroundImage: body.thumbnailImage forState:UIControlStateNormal];
    
}

-(void)setVoiceMessageCell:(Message *)message{
    
    // voice 动态图片
    
   self.voiceView.image = message.direction == MessageDirectionSend ? [UIImage imageNamed:@"voice_myself_icon"]: [UIImage imageNamed:@"voice_duifang_icon"];
    
    if (_messageFrame.isMediaPlaying) {
        
        self.voiceView.animationImages = message.direction ==  MessageDirectionSend ? self.sendMessageVoiceAnimationImages : self.recvMessageVoiceAnimationImages;
        self.voiceView.animationDuration = 1.f;
        
        [self.voiceView startAnimating];
    }
    else{
        [self.voiceView stopAnimating];
    }
    
    // voice 持续时间label 
    
    int count = ((VoiceMessageBody *)message.body).duration;
    
    NSString * countStr = [NSString stringWithFormat:@"%d\"",count];
    self.secLabel.text = countStr.intValue > 99 ? @"...\"" : countStr;
    self.secLabel.font = [UIFont systemFontOfSize:13];
    self.secLabel.textColor = [UIColor grayColor];
    // voice 小红点
    
    if (message.isRead) {
        self.redDot.hidden = YES;
    }else{
        self.redDot.hidden = NO;
    }

    // 设置voice 标签的frame
    if (message.direction == MessageDirectionSend) {
        CGFloat voiceX = _contentBtn.width - (self.voiceView.image.size.width + 10);
        
        self.voiceView.frame = CGRectMake(voiceX, 15, self.voiceView.image.size.width, self.voiceView.image.size.height);
        
        self.secLabel.frame = CGRectMake(-22, 15, 25, 25);
        self.secLabel.textAlignment = NSTextAlignmentRight;
       
    }else{
    
        CGFloat voiceX = _contentBtn.width;
        self.secLabel.frame = CGRectMake(voiceX, 15, 25, 25);
        self.voiceView.frame = CGRectMake(10, 15, self.voiceView.image.size.width, self.voiceView.image.size.height);
        self.redDot.frame = CGRectMake(voiceX, 0, 8, 8);
        self.secLabel.textAlignment = NSTextAlignmentLeft;
        
    }

}

-(void)setFileMessageCell:(Message *)message{

    FileMessageBody * body = (FileMessageBody *)message.body;
    _contentBtn.adjustsImageWhenHighlighted = NO; // 去掉默认高亮效果
    
    if (message.direction == MessageDirectionSend) {
        [_contentBtn setBackgroundImage:[UIImage resizeImage:@"file_sender_bg"] forState:UIControlStateNormal];
    }else{
    
        [_contentBtn setBackgroundImage:[UIImage resizeImage:@"file_receiver_bg"] forState:UIControlStateNormal];
    }
    
    CGFloat margin = 10;
    CGFloat fileTypeWH = 50;
    
    self.fileType.frame = CGRectMake(margin, margin, fileTypeWH,fileTypeWH);
    
    CGFloat fileNameX = CGRectGetMaxX(self.fileType.frame)+margin;
    CGFloat fileNameW = _contentBtn.width - (margin + fileNameX);
    
    self.fileName.frame = CGRectMake(fileNameX , margin,fileNameW , fileTypeWH/2);
    
    CGFloat fileSizeH = 20;
    
    self.fileSize.frame = CGRectMake(self.fileName.x, CGRectGetMaxY(self.fileType.frame) - fileSizeH, fileTypeWH, fileSizeH);
    self.fileSize.textColor = [UIColor grayColor];
    self.fileSize.font = [UIFont systemFontOfSize:14];
    
    // 给子控件赋值
    self.fileType.image = [self getIconImageWithFilePath:body.localPath];
    self.fileName.text = body.displayName;
    self.fileSize.text = body.fileSize;
    
}

#pragma mark - 消息内容点击/长按事件

-(void)cellContentClick:(UIButton *)btn{
    
    if ([_delegate respondsToSelector:@selector(messageCell:SelectedWithModel:)]) {
        [_delegate messageCell:self SelectedWithModel:_messageFrame];
    }
}

-(void)avatarImageTap:(UIImageView *)avatar{

    if ([_delegate respondsToSelector:@selector(avatarViewSelcted:)]) {
        [_delegate avatarViewSelcted:_messageFrame];
    }
}

-(void)contentCellDidLongPress:(UILongPressGestureRecognizer *)recognizer{

    if (recognizer.state == UIGestureRecognizerStateBegan) {// 一旦识别到手势后就只执行一次处理
        if ([_delegate respondsToSelector:@selector(messageCell:didLongPress:WithModel:)]) {
            [_delegate messageCell:_contentBtn didLongPress:recognizer WithModel:_messageFrame.aMessage];
        }else{
            NSLog(@"未响应代理方法");
            
        }
    }
    
}

#pragma mark - public 

+(NSString *)cellIdentifierWithModel:(MessageFrame *)model{
    
    NSString *cellIdentifier = nil;
    
    if (model.aMessage.direction == MessageDirectionSend) { // 发送
        switch (model.aMessage.body.type) {
            case MessageBodyTypeText:
                cellIdentifier = EaseMessageCellIdentifierSendText;
                break;
            case MessageBodyTypeImage:
                cellIdentifier = EaseMessageCellIdentifierSendImage;
                break;
            case MessageBodyTypeVoice:
                cellIdentifier = EaseMessageCellIdentifierSendVoice;
                break;
            case MessageBodyTypeFile:
                cellIdentifier = EaseMessageCellIdentifierSendFile;
                break;
            default:
                break;
        }
    }
    else{
        switch (model.aMessage.body.type) {
            case MessageBodyTypeText:
                cellIdentifier = EaseMessageCellIdentifierRecvText;
                break;
            case MessageBodyTypeImage:
                cellIdentifier = EaseMessageCellIdentifierRecvImage;
                break;
            case MessageBodyTypeVoice:
                cellIdentifier = EaseMessageCellIdentifierRecvVoice;
                break;
            case MessageBodyTypeFile:
                cellIdentifier = EaseMessageCellIdentifierRecvFile;
                break;
            default:
                break;
        }
    }
    
    return cellIdentifier;
    
}

#pragma mark - private 

// 识别消息中的网址

// 获取压缩后的缩略图
-(UIImage *)getThumbnailImage:(NSData *)data {
    
    UIImage * image = [UIImage imageWithData:data];
    CGSize size = image.size;
    UIImage * thumbnailImage = size.width * size.height > 200 * 200 ? [UIImage scaleImage:image toScale:sqrt((200 * 200) / (size.width * size.height))] : image;
    
    return thumbnailImage;
    
}
// 文件消息图片名称
-(UIImage *)getIconImageWithFilePath:(NSString *)filePath{
    
    NSString * extention = [filePath pathExtension];
    if ([extention.lowercaseString isEqualToString:@"pdf"]) {
        return [UIImage imageNamed:@"pdf_icon"];
    }
    return [UIImage imageNamed:@"default_icon"];
}

@end
