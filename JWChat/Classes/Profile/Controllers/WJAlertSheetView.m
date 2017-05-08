//
//  WJAlertSheetView.m
//  JWChat
//
//  Created by JerryWang on 2017/4/26.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "WJAlertSheetView.h"

static const CGFloat ButtonHeight = 50;
static const CGFloat GapHeight = 7;
static const CGFloat GapLineHeight = 0.5;

typedef void(^SelectedBlock)(NSInteger index);

@interface WJAlertSheetView()

@property (nonatomic,weak) UIVisualEffectView * blurView;
@property (nonatomic,copy) SelectedBlock callback;
@property (nonatomic,assign) CGFloat blurViewHeight;
@property (nonatomic,strong) NSArray * items;

@end

@implementation WJAlertSheetView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<NSString *> *)items{

    if (self = [super initWithFrame:frame]) {
        // init code
        _items = items;
        _blurViewHeight = ButtonHeight + GapHeight + items.count * ButtonHeight + (items.count -1) * GapLineHeight;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{

    self.backgroundColor = [UIColor clearColor];
    
    // blurView
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView * blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _blurViewHeight);
    
    _blurView = blurView;
    
    [self addSubview:_blurView];

    // items
    
    for (int i = 0 ; i<_items.count; i++) {
        
        CGFloat itemY = i * (ButtonHeight + GapLineHeight);
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(0, itemY, SCREEN_WIDTH, ButtonHeight);
        
        [item setTitle:_items[i] forState:UIControlStateNormal];
        [item setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:1.0]] forState:UIControlStateNormal];
        [item setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.5]] forState:UIControlStateHighlighted];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [item addTarget:self action:@selector(itemDidClick:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = i;
        
        [_blurView.contentView addSubview:item];
    }
    
    // cancel btn
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancel.frame = CGRectMake(0, _blurViewHeight - (ButtonHeight), SCREEN_WIDTH, ButtonHeight);
    [cancel setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:1.0]] forState:UIControlStateNormal];
    [cancel setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.5]] forState:UIControlStateHighlighted];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [cancel addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_blurView.contentView addSubview:cancel];
    
}


#pragma actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideView];
}

- (void)cancelBtnClick:(UIButton *)btn{
    [self hideView];
}

- (void)itemDidClick:(UIButton *)btn{

    _callback(btn.tag);
    [self hideView];
}

#pragma mark - public

+ (void)showAlertSheetViewItems:(NSArray<NSString *> *)items completion:(void (^)(NSInteger index))completion{

    if (!items) {
        if (items.count <= 0) {
            NSLog(@"item's count could not zero");
            return;
        }
        return;
    }
    
    WJAlertSheetView * sheetView = [[WJAlertSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds items:items];

    sheetView.callback = ^(NSInteger index) {
        completion(index);
    };
    
    [sheetView showView];
}


#pragma mark - private

- (void)showView{

    [UIView transitionWithView:_blurView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.backgroundColor = WJRGBAColor(0, 0, 0, 0.4);// apple 标准背景色
        _blurView.transform = CGAffineTransformMakeTranslation(0, -_blurViewHeight);
        
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
