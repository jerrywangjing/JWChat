//
//  ApplyNoticeTableViewCell.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/11/23.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplyNoticeTableViewCell,ContactsModel;

@protocol ApplyNoticeTableViewCellDelegate <NSObject>
@optional
-(void)applyNoticeCell:(ApplyNoticeTableViewCell *)applyNoticeCell didSelectedAcceptBtn:(UIButton *)acceptBtn;
-(void)applyNoticeCell:(ApplyNoticeTableViewCell *)applyNoticeCell didSelectedRefuseBtn:(UIButton *)refuseBtn;

@end

@interface ApplyNoticeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *verifyMsg;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;


@property (strong,nonatomic) ContactsModel * cellData;

@property (weak,nonatomic) id<ApplyNoticeTableViewCellDelegate> delegate;

- (IBAction)refuseBtn:(id)sender;
- (IBAction)acceptBtn:(id)sender;

+ (instancetype)applyNoticeCellWithTableView:(UITableView *)tableView;
@end
