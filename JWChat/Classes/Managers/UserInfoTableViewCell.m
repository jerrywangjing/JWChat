//
//  UserInfoTableViewCell.m
//  JWChat
//
//  Created by jerry on 2017/4/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "ProfileCellModel.h"

@interface UserInfoTableViewCell ()

@property (nonatomic,weak) UIImageView * avatarView;
@property (nonatomic,weak) UILabel * titleLabel;
@property (nonatomic,weak) UILabel * accountLabel;
@property (nonatomic,weak) UIImageView * arrowView;
@property (nonatomic,weak) UIImageView * genderView;

@end

@implementation UserInfoTableViewCell

+ (instancetype)userInfoCellWithTableView:(UITableView *)tableView{

    static NSString * userInfoCellId = @"userInfoCellId";
    
    UserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
    
    if (!cell) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoCellId];
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
    
    UIImageView * avatarView = [[UIImageView alloc] init];
    _avatarView = avatarView;
    _avatarView.layer.cornerRadius = 10;
    _avatarView.layer.masksToBounds = YES;
    [self addSubview:_avatarView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
    UIImageView * genderView = [[UIImageView alloc] init];
    _genderView = genderView;
    [self addSubview:_genderView];
    
    UILabel * accountLabel = [[UILabel alloc] init];
    _accountLabel = accountLabel;
    _accountLabel.textColor = [UIColor grayColor];
    _accountLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_accountLabel];
    
    UIImageView * arrowView = [[UIImageView alloc] init];
    _arrowView = arrowView;
    _arrowView.image = [UIImage imageNamed:@"cell_arrow"];
    [self addSubview:_arrowView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarView.mas_right).offset(10);
        make.top.equalTo(_avatarView).offset(5);
        
    }];
    
    [_genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(15);
        make.top.equalTo(_titleLabel);
    }];
    
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(_avatarView).offset(-5);
    }];
    
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setModel:(ProfileCellModel *)model{

    _model = model;
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];
    _titleLabel.text = model.title;
    _accountLabel.text = [NSString stringWithFormat:@"账号：%@",model.subTitle];

    switch (model.gender.integerValue) {
        case NIMUserGenderMale:
            _genderView.image = [UIImage imageNamed:@"icon_gender_male"];
            break;
        case NIMUserGenderFemale:
            _genderView.image = [UIImage imageNamed:@"icon_gender_female"];
            
        default:
            _genderView.hidden = YES;
            break;
    }
}

@end
