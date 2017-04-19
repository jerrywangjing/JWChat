//
//  BaseTableViewCell.m
//  JWChat
//
//  Created by jerry on 2017/4/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ProfileCellModel.h"

@interface BaseTableViewCell ()

@property (nonatomic,weak) UIImageView * arrowView;
@property (nonatomic,weak) UILabel * subTitleLabel;
@property (nonatomic,weak) UILabel * titleLabel;

@end

@implementation BaseTableViewCell

+ (instancetype)baseCellWithTableView:(UITableView *)tableview{

    static NSString *baseCellId = @"baseCellId";
    
    BaseTableViewCell * cell = [tableview dequeueReusableCellWithIdentifier:baseCellId];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseCellId];
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
    
    UILabel * subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel = subTitleLabel;
    _subTitleLabel.textColor = [UIColor grayColor];
    _subTitleLabel.font = [UIFont systemFontOfSize:15];
    _subTitleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_subTitleLabel];
    
    UIImageView * arrowView = [[UIImageView alloc] init];
    _arrowView = arrowView;
    _arrowView.image = [UIImage imageNamed:@"cell_arrow"];
    [self addSubview:_arrowView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_arrowView.mas_left).offset(-10);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setShowArrowView:(BOOL)showArrowView{

    _showArrowView = showArrowView;
    if (self.isShowArrowView) {
        _arrowView.hidden = NO;
    }else{
    
        _arrowView.hidden = YES;
    }
}

-(void)setModel:(ProfileCellModel *)model{

    _model = model;
    
    _titleLabel.text = model.title;
    
    if (!model.subTitle || [model.subTitle isEqualToString:@""]) {
        _subTitleLabel.hidden = YES;
    }else{
    
        _subTitleLabel.hidden = NO;
        _subTitleLabel.text = model.subTitle;
    }
    
}

@end
