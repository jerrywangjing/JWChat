//
//  AddOtherFuncKeyboard.h
//  ESDemo
//
//  Created by jerry on 16/9/20.
//  Copyright © 2016年 Zhang, Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AddKeyboardBtnType) {
    
    AddKeyboardBtnTypeSendPhoto,
    AddKeyboardBtnTypeTakePhoto,
    AddKeyboardBtnTypeVideo,
    AddKeyboardBtnTypeSendFile,
    AddKeyboardBtnTypeLocation,
    AddKeyboardBtnTypeWhiteBoard,
};


@protocol AddOtherFuncKeyboardDelegate <NSObject>
/// 按钮点击事件代理
-(void)funcKeyboard:(UIView *)keyboard didBeginSendPhotosWithType:(AddKeyboardBtnType)btnType;

@end
@interface AddOtherFuncKeyboard : UIView

@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,weak)id<AddOtherFuncKeyboardDelegate>delegate;
//@property (nonatomic,assign,getter=isActive) BOOL active;

@end
