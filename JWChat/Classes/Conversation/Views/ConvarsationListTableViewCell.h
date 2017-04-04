//
//  ConvarsationListTableViewCell.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConversationModel;

@interface ConvarsationListTableViewCell : UITableViewCell

@property (nonatomic,strong) ConversationModel * conversationData;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *latestMessage;
@property (weak, nonatomic) IBOutlet UILabel *latestMsgTime;
@property (assign,nonatomic) BOOL isTop;
@property (assign,nonatomic) BOOL isBottom;

+(instancetype)convarsationListCellWithTableview:(UITableView *)tableView;

@end
