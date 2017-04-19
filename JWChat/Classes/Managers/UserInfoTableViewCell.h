//
//  UserInfoTableViewCell.h
//  JWChat
//
//  Created by jerry on 2017/4/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface UserInfoTableViewCell : UITableViewCell

@property (nonatomic,strong) ProfileCellModel * model;

+ (instancetype)userInfoCellWithTableView:(UITableView *)tableView;

@end
