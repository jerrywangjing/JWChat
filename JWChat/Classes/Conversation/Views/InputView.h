//
//  YZInputView.h
//  YZInputView
//
//  Created by yz on 16/8/1.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UITextView

/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

/**
 textView最大行高
 */
@property (nonatomic, assign) NSUInteger maxLineHeight;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, copy) void(^textHeightChangeBlock)(NSString *text,CGFloat textHeight);

/**
 *  设置圆角
 */
@property (nonatomic, assign) NSUInteger cornerRadius;

/**
 *  占位文字
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
