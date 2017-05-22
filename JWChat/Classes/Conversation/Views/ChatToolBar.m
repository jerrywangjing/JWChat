//
//  ChatToolBar.m
//  JWChat
//
//  Created by jerry on 17/4/11.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "ChatToolBar.h"
#import "InputView.h"

@interface ChatToolBar ()<UITextViewDelegate>

@property (nonatomic,strong) UIButton * voiceBtn;
@property (nonatomic,strong) UIButton * emojiBtn;
@property (nonatomic,strong) UIButton * addBtn;

@end

@implementation ChatToolBar

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WJRGBColor(245, 245, 246);
        
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews{

    // voice btn
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceBtn setImage:[UIImage imageNamed:@"voice_hlt"] forState:UIControlStateNormal];
    [_voiceBtn setImage:[UIImage imageNamed:@"voice_nor"] forState:UIControlStateHighlighted];
    [_voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voiceBtn];
    
    // emoji btn
    
    _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_emojiBtn setImage:[UIImage imageNamed:@"face_hlt"] forState:UIControlStateNormal];
    [_emojiBtn setImage:[UIImage imageNamed:@"face_nor"] forState:UIControlStateHighlighted];
    [_emojiBtn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_emojiBtn];

    // add btn
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setImage:[UIImage imageNamed:@"addBtn_hlt"] forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"addBtn_nor"] forState:UIControlStateHighlighted];
    [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];

    // inputview
    
    _inputView = [[InputView alloc] init];
    
    WJWeakSelf(weakSelf);
    _inputView.maxLineHeight = 80;
    _inputView.textHeightChangeBlock = ^(NSString * text,CGFloat textHeight){
        
        [weakSelf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textHeight + 10);
        }];
    };
    
    _inputView.delegate = self;
    _inputView.returnKeyType = UIReturnKeySend;
    _inputView.layer.borderWidth = 0.5;
    _inputView.layer.borderColor = LineColor.CGColor;
    _inputView.font = [UIFont systemFontOfSize:16];
    
    // toolbar 顶部的间隔线
    UIView * toolBarLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    toolBarLine.backgroundColor = LineColor;
    [self addSubview: toolBarLine];
    [self addSubview:_inputView];
    
}

-(void)layoutSubviews{

    [_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    
    [_emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_addBtn.mas_left).offset(-5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(_voiceBtn.mas_right).offset(5);
        make.right.equalTo(_emojiBtn.mas_left).offset(-5);
        make.top.equalTo(self).offset(6);
        make.bottom.equalTo(self).offset(-6);
        
    }];
    
}

#pragma mark - callback 

- (void)voiceBtnClick:(UIButton *)btn{

    if ([self.delegate respondsToSelector:@selector(chatToolBar:voiceBtnDidClick:)]) {
     
        [self.delegate chatToolBar:self voiceBtnDidClick:btn];
    }
}

- (void)emojiBtnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(chatToolBar:emojiBtnDidClick:)]) {
        
        [self.delegate chatToolBar:self emojiBtnDidClick:btn];
    }
}
- (void)addBtnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(chatToolBar:addBtnDidClick:)]) {
        
        [self.delegate chatToolBar:self addBtnDidClick:btn];
    }
}

#pragma mark - textView delegate

-(void)textViewDidChange:(UITextView *)textView{

    if ([self.delegate respondsToSelector:@selector(chatToolBar:textViewDidChange:)]) {
        [self.delegate chatToolBar:self textViewDidChange:textView];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{

    if ([self.delegate respondsToSelector:@selector(chatToolBar:textViewDidBeginEditing:)]) {
        [self.delegate chatToolBar:self textViewDidBeginEditing:textView];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([self.delegate respondsToSelector:@selector(chatToolBar:textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate chatToolBar:self textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

@end
