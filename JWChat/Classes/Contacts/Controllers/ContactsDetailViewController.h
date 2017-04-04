//
//  ContactsDetailViewController.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContactsModel;

typedef void(^PushToChatRoomBlock) (ContactsModel *user);

@interface ContactsDetailViewController : UIViewController

@property (nonatomic,strong)ContactsModel * contactModel; // 联系人模型
@property (nonatomic,weak) UIViewController * previousVc; // 导航栈中上一个控制器
@property (nonatomic,copy) PushToChatRoomBlock pushToChatRoomBlock;  // 处理跳转到聊天室

@end
