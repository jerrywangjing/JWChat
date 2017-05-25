//
//  RegisterViewController.h
//  JWChat
//
//  Created by JerryWang on 2017/5/25.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^registerCompletionBlock)(NSString *account,NSString * password);
@interface RegisterViewController : UIViewController

@property (nonatomic,copy) registerCompletionBlock completion;
@end
