//
//  LogoutBtnCell.m
//  JWChat
//
//  Created by JerryWang on 2017/4/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "LogoutBtnCell.h"
#import "ProfileCellModel.h"

@interface LogoutBtnCell ()

@property (nonatomic,weak) UILabel * titleLabel;

@end

@implementation LogoutBtnCell

+ (instancetype)logoutcellWithTableView:(UITableView *)tableview{
    
    static NSString *logoutCellId = @"logoutCell";
    
    LogoutBtnCell * cell = [tableview dequeueReusableCellWithIdentifier:logoutCellId];
    if (!cell) {
        cell = [[LogoutBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logoutCellId];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    UILabel * titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setModel:(ProfileCellModel *)model{
    
    _model = model;
    
    _titleLabel.text = model.title;
    
}

@end
