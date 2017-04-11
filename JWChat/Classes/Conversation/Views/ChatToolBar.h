//
//  ChatToolBar.h
//  JWChat
//
//  Created by jerry on 17/4/11.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputView;
@class ChatToolBar;

@protocol ChatToolBarDelegate <NSObject>

- (void)chatToolBar:(ChatToolBar *)toolBar voiceBtnDidClick:(UIButton *)btn;
- (void)chatToolBar:(ChatToolBar *)toolBar emojiBtnDidClick:(UIButton *)btn;
- (void)chatToolBar:(ChatToolBar *)toolBar addBtnDidClick:(UIButton *)btn;
- (void)chatToolBar:(ChatToolBar *)toolBar textViewDidChange:(UITextView *)textView;
- (void)chatToolBar:(ChatToolBar *)toolBar textViewDidBeginEditing:(UITextView *)textView;
-(BOOL)chatToolBar:(ChatToolBar *)toolBar textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end

@interface ChatToolBar : UIView

@property (nonatomic,strong,readonly) InputView * inputView;
@property (nonatomic,weak) id<ChatToolBarDelegate>delegate;

@end
