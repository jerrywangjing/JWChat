//
//  AddOtherFuncKeyboard.h
//  ESDemo
//
//  Created by jerry on 16/9/20.
//  Copyright © 2016年 Zhang, Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    AddKeyboardBtnTypeSendPhoto, //发送照片
    AddKeyboardBtnTypeTakePhoto, // 拍摄照片
    AddKeyboardBtnTypeVideo,    // 视频聊天
    AddKeyboardBtnTypePhoneCall, // 拨打电话
    AddKeyboardBtnTypeSendFile, // 发送文件
    AddKeyboardBtnTypePatients, // 本院病人
    AddKeyboardBtnTypeMyConsult, // 我的咨询
    AddKeyboardBtnTypeHisConsult, // 历史咨询
    
}AddKeyboardBtnType;

@protocol AddOtherFuncKeyboardDelegate <NSObject>
/// 按钮点击事件代理
-(void)funcKeyboard:(UIView *)keyboard didBeginSendPhotosWithType:(AddKeyboardBtnType)btnType;

@end
@interface AddOtherFuncKeyboard : UIView

@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,weak)id<AddOtherFuncKeyboardDelegate>delegate;
//@property (nonatomic,assign,getter=isActive) BOOL active;

@end
