//
//  ContactsDetailTableViewCell.m
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/11/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ContactsDetailTableViewCell.h"
#import "ContactsModel.h"

@interface ContactsDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *neckName;

@end
@implementation ContactsDetailTableViewCell

+(instancetype)contactsCellWithTableView:(UITableView *)tableView{

    static NSString * cellId = @"contactCell";
    ContactsDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ContactsDetailTableViewCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.avatarImageView.layer.cornerRadius = 5;
        cell.avatarImageView.layer.masksToBounds = YES;
    }
    return cell;
}

-(void)setUser:(NIMUser *)user{

    _user = user;

    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];
    _userName.text = user.userInfo.nickName == nil ? user.userId : user.userInfo.nickName;
    _userId.text = [NSString stringWithFormat:@"ID号：%@",user.userId];
    _neckName.text = [NSString stringWithFormat:@"备注：%@",user.alias];
}

@end
