//
//  ContactTableViewCell.h
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(UIButton *btn);
@class ContactsModel;

@interface ContactTableViewCell : UITableViewCell

//@property (nonatomic,strong) ContactsModel * userModel;
@property (nonatomic,strong) NIMUser *user;

@property (nonatomic,assign,getter=isShowAddBtn) BOOL showAddBtn;
@property (nonatomic,copy) CompletionBlock addBtnDidClickBlock;

-(void)setAddBtnState:(NSString *)state addTag:(NSInteger)tag;

+(instancetype)contactsCellWithTableView:(UITableView *)tableView;

@end
