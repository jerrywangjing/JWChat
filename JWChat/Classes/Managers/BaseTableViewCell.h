//
//  BaseTableViewCell.h
//  JWChat
//
//  Created by jerry on 2017/4/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileCellModel;
@interface BaseTableViewCell : UITableViewCell

@property (nonatomic,strong) ProfileCellModel * model;
@property (nonatomic,assign,getter=isShowArrowView) BOOL showArrowView;

+ (instancetype)baseCellWithTableView:(UITableView *)tableview;

@end
