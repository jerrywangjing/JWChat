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

@property (nonatomic,strong) NIMUser * user;
@property (nonatomic,strong) ConversationModel * conversationModel;
@property (nonatomic,copy) ClearChatMessageBlock clearChatMessageBlock;

@end
