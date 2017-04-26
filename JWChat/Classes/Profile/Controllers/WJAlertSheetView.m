//
//  WJAlertSheetView.m
//  JWChat
//
//  Created by JerryWang on 2017/4/26.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "WJAlertSheetView.h"
#import "FXBlurView.h"

static const NSInteger itemCount = 3;
static const CGFloat buttonHeight = 50;
static const CGFloat gapHeight = 7;
static const CGFloat gapLineHeight = 0.5;

static const CGFloat blurViewHeight = buttonHeight * itemCount + gapHeight + gapLineHeight;

typedef void(^SelectedBlock)(SelectedIndex index);
@interface WJAlertSheetView()

@property (nonatomic,weak) UIView * blurView;
@property (nonatomic,weak) UIButton * firstBtn;
@property (nonatomic,weak) UIButton * secondBtn;

@property (nonatomic,copy) NSString * firstTitle;
@property (nonatomic,copy) NSString * secondTitle;
@property (nonatomic,copy) SelectedBlock callback;
@end

@implementation WJAlertSheetView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        // init code
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews{

    self.backgroundColor = [UIColor clearColor];
    
    // btn blur view
    
    UIView  * blurView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, blurViewHeight)];
    _blurView = blurView;
    _blurView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
//    [_blurView setBlurEnabled:YES];
//    _blurView.dynamic = NO;
//    _blurView.tintColor = [UIColor clearColor];
//    _blurView.blurRadius = 20; // 模糊半径
    
    [self addSubview:_blurView];
    
    // cancel btn
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];

    cancel.frame = CGRectMake(0, _blurView.height - (buttonHeight), SCREEN_WIDTH, buttonHeight);
    [cancel setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.9]] forState:UIControlStateNormal];
    [cancel setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.7]] forState:UIControlStateHighlighted];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [cancel addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //item 0
    
    UIButton * firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    firstBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, buttonHeight);

    [firstBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.9]] forState:UIControlStateNormal];
    [firstBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.5]] forState:UIControlStateHighlighted];
    [firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [firstBtn addTarget:self action:@selector(firstBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _firstBtn = firstBtn;
    
    // item 1
    
    UIButton * secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondBtn.frame = CGRectMake(0, buttonHeight+0.5, SCREEN_WIDTH, buttonHeight);

    [secondBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.9]] forState:UIControlStateNormal];
    [secondBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.5]] forState:UIControlStateHighlighted];
    [secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [secondBtn addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _secondBtn = secondBtn;
    
    [_blurView addSubview:cancel];
    [_blurView addSubview:_firstBtn];
    [_blurView addSubview:_secondBtn];
    
}

- (void)setFirstTitle:(NSString *)firstTitle{

    _firstTitle = firstTitle;
    [_firstBtn setTitle:firstTitle forState:UIControlStateNormal];
}

- (void)setSecondTitle:(NSString *)secondTitle{

    _secondTitle = secondTitle;
    [_secondBtn setTitle:secondTitle forState:UIControlStateNormal];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideView];
}

#pragma actions

- (void)cancelBtnClick:(UIButton *)btn{

    _callback(SelectedIndexCancel);
    [self hideView];
}

- (void)firstBtnClick:(UIButton *)btn{
    _callback(SelectedIndexFirst);
    [self hideView];
}

- (void)secondBtnClick:(UIButton *)btn{
    _callback(SelectedIndexSecond);
    [self hideView];
}

#pragma mark - public

+ (void)showAlertSheetViewWithFirstItemTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle completion:(void (^)(SelectedIndex index))completion{

    WJAlertSheetView * sheetView = [[WJAlertSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sheetView.firstTitle = firstTitle;
    sheetView.secondTitle = secondTitle;
    sheetView.callback = ^(SelectedIndex index) {
        completion(index);
    };
    
    [sheetView showView];
}

#pragma mark - private

- (void)showView{

    [UIView transitionWithView:_blurView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        _blurView.transform = CGAffineTransformMakeTranslation(0, -blurViewHeight);
        
    } completion:nil];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

- (void)hideView{

    [UIView transitionWithView:_blurView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        _blurView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
