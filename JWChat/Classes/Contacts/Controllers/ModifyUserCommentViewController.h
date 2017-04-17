//
//  ModifyUserCommentViewController.h
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/11/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletedBlock)(NSString * comment);
@interface ModifyUserCommentViewController : UIViewController

@property (nonatomic,strong) NIMUser * user;
@property (nonatomic,copy) CompletedBlock modifyCallback;
@end
