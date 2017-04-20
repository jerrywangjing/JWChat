//
//  ContactTableViewCell.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "ContactTableViewCell.h"
#import "ContactsModel.h"

@interface ContactTableViewCell ()

@property (nonatomic,weak) UIImageView * headImageView;//头像
@property (nonatomic,weak) UILabel * onlineLabel; // 是否在线
@property (nonatomic,weak) UILabel * nameLabel;//姓名
@property (nonatomic,copy) NSString * btnState; // 记录按钮状态
@property (nonatomic,weak) UIButton * addBtn; // 添加按钮

@end

@implementation ContactTableViewCell

#pragma mark - init
+(instancetype)contactsCellWithTableView:(UITableView *)tableView{
    
     static NSString * cellId = @"contactsCell";
    
    ContactTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self setupSubviews];
    }
    return self;
}
#pragma mark - getter

- (UIImageView *)headImageView{
    if (!_headImageView) {
        UIImageView * headView = [[UIImageView alloc] init];
        _headImageView = headView;
        [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
        _headImageView.layer.cornerRadius = 5;
        _headImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImageView];
    }
    return _headImageView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        UILabel * nameLable =[[UILabel alloc] init];
        _nameLabel = nameLable;
        [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)onlineLabel{
    
    if (!_onlineLabel) {
        UILabel * online = [[UILabel alloc] init];
        _onlineLabel = online;
        _onlineLabel.font = [UIFont systemFontOfSize:12];
        _onlineLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_onlineLabel];
    }
    return _onlineLabel;
}

-(UIButton *)addBtn{

    if (!_addBtn) {
        
        UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn = addBtn;
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"submit_but_bg_nor"] forState:UIControlStateNormal];
        [_addBtn setBackgroundImage: [UIImage imageNamed:@"submit_but_bg_hlt"] forState:UIControlStateHighlighted];
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addBtn addTarget:self action:@selector(addContactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.hidden = YES;
        [self.contentView addSubview:self.addBtn];
    }
    return _addBtn;
}
// 控制是否显示添加按钮
-(void)setShowAddBtn:(BOOL)showAddBtn{

    if (showAddBtn) {
        self.addBtn.hidden = NO;
    }
}
#pragma mark - setup subViews

- (void)setupSubviews{
    
    // 布局view
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(12);
        make.top.equalTo(_headImageView).offset(2);
    }];
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(_headImageView);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}

-(void)setAddBtnState:(NSString *)state addTag:(NSInteger)tag{

    _addBtn.tag = tag;
    if ([state isEqualToString:@"已发送"]) {
        
        [_addBtn setTitle:@"已发送" forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _addBtn.enabled = NO;
    }else{
        
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _addBtn.enabled = YES;
    }
    
}

//-(void)setUserModel:(ContactsModel *)userModel{
//
//    _userModel = userModel;
//    
//    _headImageView.image = [UIImage getAvatarImageWithString:_userModel.avatarImageUrl];
//    _headImageView.alpha = [userModel.online isEqualToString:@"1"]? 1:0.5;
//    _nameLabel.text = userModel.userComment ? userModel.userComment : userModel.userName;
//    _onlineLabel.text = [userModel.online isEqualToString:@"1"]? @"[在线]":@"[离线]";
//    
//}

- (void)setUser:(NIMUser *)user{

    _user = user;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:user.userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar"]];
    _nameLabel.text = user.alias ? user.alias : user.userInfo.nickName;
    _onlineLabel.text = @"[在线]";
    
}

-(void)addContactBtnClick:(UIButton *)btn{

    // block回调
    _addBtnDidClickBlock(btn);
}
@end
