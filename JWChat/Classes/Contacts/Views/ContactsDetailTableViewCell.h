//
//  ContactsDetailTableViewCell.h
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/11/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsDetailTableViewCell : UITableViewCell

@property (nonatomic,strong) NIMUser * user;

+(instancetype)contactsCellWithTableView:(UITableView *)tableView;
@end
