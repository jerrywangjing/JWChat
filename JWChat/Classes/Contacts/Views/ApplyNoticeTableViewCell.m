//
//  ApplyNoticeTableViewCell.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/11/23.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "ApplyNoticeTableViewCell.h"
#import "ContactsModel.h"

@implementation ApplyNoticeTableViewCell

+(instancetype)applyNoticeCellWithTableView:(UITableView *)tableView{

    static NSString * cellId = @"applyCell";
    ApplyNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyNoticeTableViewCell" owner: nil options:nil].firstObject;
        cell.avatarImage.layer.cornerRadius = 5;
        cell.avatarImage.layer.masksToBounds = YES;
    }
    return cell;
}

// cell 赋值

-(void)setCellData:(ContactsModel *)cellData{

    _cellData = cellData;
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:cellData.avatarImageUrl]];
    _userName.text = cellData.userName;
    _verifyMsg.text = @"请求添加你为好友";

}
- (IBAction)acceptBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(applyNoticeCell:didSelectedAcceptBtn:)]) {
        [self.delegate applyNoticeCell:self didSelectedAcceptBtn:sender];
    }
}

- (IBAction)refuseBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(applyNoticeCell:didSelectedRefuseBtn:)]) {
        [self.delegate applyNoticeCell:self didSelectedRefuseBtn:sender];
    }
}


@end
