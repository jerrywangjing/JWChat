//
//  ChatRoomViewController.h
//  ESDemo
//
//  Created by jerry on 16/9/12.
//  Copyright © 2016年 Zhang, Lawrence. All rights reserved.
//>聊天室视图

#import <UIKit/UIKit.h>

@class ConversationModel,ContactsModel;

@interface ChatRoomViewController : UIViewController

@property (nonatomic,strong) ContactsModel * contact; // 当前好友
@property (nonatomic,strong) ConversationModel * conversationModel;
@property (nonatomic,copy) NSString * conversationId; // 即当前联系人姓名

// 收到新消息回调
-(void)receivedNewMessages:(NSArray *)messages;

@end
