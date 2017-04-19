//
//  LogoutBtnCell.h
//  JWChat
//
//  Created by JerryWang on 2017/4/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface LogoutBtnCell : UITableViewCell

@property (nonatomic,strong) ProfileCellModel * model;

+ (instancetype)logoutcellWithTableView:(UITableView *)tableview;

@end
