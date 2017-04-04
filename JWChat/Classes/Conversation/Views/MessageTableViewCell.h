//
//  MessageTableViewCell.h
//  ESDemo
//
//  Created by jerry on 16/9/9.
//  Copyright © 2016年 Zhang, Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageFrame;
@class ContactsModel;
@protocol MessageTableViewCellDelegate; // 申明这是一个协议

@interface MessageTableViewCell : UITableViewCell
/// cell 的frame
@property (nonatomic,weak,readonly) UIButton * contentBtn;
@property (nonatomic,strong) MessageFrame * messageFrame;
@property (nonatomic,strong) ContactsModel * contact;
@property (nonatomic,weak) id<MessageTableViewCellDelegate> delegate;
@property (nonatomic,weak) UIImageView * redDot; // 语音提示红点

// 创建cell
+(instancetype)messageCellWithTabelView:(UITableView *)tableView andModel:(MessageFrame *)model;

// cell 可重用符号
+ (NSString *)cellIdentifierWithModel:(MessageFrame *)model;

@end

// 协议方法
@protocol MessageTableViewCellDelegate <NSObject>

@optional
/// cell 内容点击代理
- (void)messageCell:(id)messageCell SelectedWithModel:(MessageFrame *)model;
/// cell 长按代理
- (void)messageCell:(id)messageCell didLongPress:(UILongPressGestureRecognizer *)recognizer  WithModel:(Message *)model;
/// 状态按钮代理
- (void)statusButtonSelcted:(MessageFrame *)model withMessageCell:(MessageTableViewCell*)messageCell;
/// 好友头像点击代理
- (void)avatarViewSelcted:(MessageFrame *)model;

@end
