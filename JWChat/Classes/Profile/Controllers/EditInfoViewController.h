//
//  EditInfoViewController.h
//  JWChat
//
//  Created by jerry on 2017/4/21.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EditInfoType) {
    EditInfoTypeNickName,
    EditInfoTypeGender,
    EditInfoTypeBirthday,
    EditInfoTypePhoneNumber,
    EditInfoTypeEmail,
    EditInfoTypeSign
};

typedef void(^CompletionBlock)();

@interface EditInfoViewController : UIViewController

@property (nonatomic,strong) NIMUser * user;
@property (nonatomic,assign) EditInfoType editType;
@property (nonatomic,copy) CompletionBlock completion;

@end
