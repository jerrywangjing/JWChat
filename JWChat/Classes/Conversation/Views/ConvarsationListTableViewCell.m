//
//  ConvarsationListTableViewCell.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ConvarsationListTableViewCell.h"
#import "ConversationModel.h"
#import "Conversation.h"
#import "ContactsModel.h"
#import "TimeFormateTool.h"

@interface ConvarsationListTableViewCell ()

@end

@implementation ConvarsationListTableViewCell

+(instancetype)convarsationListCellWithTableview:(UITableView *)tableView{

    static NSString * ID = @"conversationCell";
    ConvarsationListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ConvarsationListTableViewCell" owner:nil options:nil].lastObject;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

-(void)setConversationData:(ConversationModel *)model{

    _conversationData = model;
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.user.userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];
    
//    UIImage * avatarImage = _avatarImageView.image;
//    
//    _avatarImageView.image = [UIImage makeRoundedImage: avatarImage radius:10];
    
    _userName.text = [ContactsManager getUserName:model.user];
    
    // 获取最近的一条消息
    Message * latestMsg = model.conversation.latestMessage;
    
    if (latestMsg) {
        _latestMsgTime.text = latestMsg.timeStr;
        
        MessageBody * body = latestMsg.body;
        switch (body.type) {
            case MessageBodyTypeText:
                _latestMessage.text = ((TextMessageBody *)body).text;
                break;
            case MessageBodyTypeImage:
                _latestMessage.text = @"[图片]";
                break;
            case MessageBodyTypeVoice:
                _latestMessage.text = @"[语音]";
                break;
            case MessageBodyTypeFile:
                _latestMessage.text = @"[文件]";
                break;
            default:
                break;
        }
    }
}

-(void)setIsTop:(BOOL)isTop{
    _isTop = isTop;
    if (isTop) {
        UIView * topBorder = [UIView cellTopBorderView];
        [self.contentView addSubview:topBorder];
    }
    
}

-(void)setIsBottom:(BOOL)isBottom{

    _isBottom = isBottom;
    if (isBottom) {
        UIView * bottomBorder = [UIView cellBottomBorderView:CGRectGetHeight(self.frame)];
        [self.contentView addSubview:bottomBorder];
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    UIColor * backgroundColor = [UIColor clearColor];
    UIColor * highlightColor = WJHexRGB(0xdbdbdb, 0.6f);
    
    if (selected) {
        self.backgroundColor = highlightColor;
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.backgroundColor = backgroundColor;
        }completion:^(BOOL finished) {
            [self setNeedsLayout];
        }];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

    [super setHighlighted:highlighted animated:animated];
    
    UIColor * highlightColor = WJHexRGB(0xdbdbdb, 0.6f);
    if (highlighted) {
        self.backgroundColor = highlightColor;
    }else{
    
        [UIView animateWithDuration:0.1 animations:^{
            self.backgroundColor = [UIColor clearColor];
        }];
    }

}
@end
