//
//  EmojiKeyboardView.h
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/12/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+EmojiExtension.h"

@protocol EmojiKeyboardViewDelegate <NSObject>

-(void)sendBtnDicClick:(UIButton *)btn;
@optional
-(void)emojiBtnDidClick:(UIButton *)btn;
-(void)deleteBtnDicClick:(UIButton *)btn;
-(void)emojiItemBtnClick:(UIButton *)btn;

@end

typedef void(^CompletionBlock)();
@interface EmojiKeyboardView : UIView

@property (nonatomic,weak) UITextView * inputView;
@property (nonatomic,weak) UIButton * sendBtn;
@property (nonatomic,weak)id<EmojiKeyboardViewDelegate>delegate;
@property (nonatomic,copy) CompletionBlock completionBlock;

@end
