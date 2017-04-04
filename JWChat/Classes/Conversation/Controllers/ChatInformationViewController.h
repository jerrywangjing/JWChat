//
//  ChatInformationViewController.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/11/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactsModel,ConversationModel;

typedef void(^ClearChatMessageBlock) (BOOL success);

@interface ChatInformationViewController : UIViewController

@property (strong,nonatomic) ContactsModel * contactsModel;
@property (strong,nonatomic) ConversationModel * conversationModel;
@property (copy,nonatomic) ClearChatMessageBlock clearChatMessageBlock;

@end
