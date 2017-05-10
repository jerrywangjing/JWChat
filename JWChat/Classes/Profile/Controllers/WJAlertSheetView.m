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
static const CGFloat TipsViewHeight = 60;

typedef void(^SelectedBlock)(NSInteger index);

@interface WJAlertSheetView()

@property (nonatomic,weak) UIVisualEffectView * blurView;
@property (nonatomic,weak) UIView * tipsView;
@property (nonatomic,copy) SelectedBlock callback;
@property (nonatomic,assign) CGFloat blurViewHeight;
@property (nonatomic,strong) NSArray * items;
@property (nonatomic,copy) NSString * tips; // 提示语
@property (nonatomic,strong) UIColor * itemColor;

@end

@implementation WJAlertSheetView

- (instancetype)initWithFrame:(CGRect)frame tips:(NSString *)tips items:(NSArray<NSString *> *)items{

    if (self = [super initWithFrame:frame]) {
        // init code
        _items = items;
        _tips = tips;
        _itemColor = (_tips ? [UIColor redColor] : [UIColor blackColor]);
        _blurViewHeight = ButtonHeight + GapHeight + items.count * ButtonHeight + (items.count -1) * GapLineHeight + (_tips ? TipsViewHeight+GapLineHeight : 0);
        
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

    // tips view
    
    if (_tips) {
        
        UIView * tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TipsViewHeight)];
        _tipsView = tipsView;
        tipsView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        [_blurView.contentView addSubview:tipsView];
        
        UILabel * tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = _tips;
        tipsLabel.textColor = [UIColor lightGrayColor];
        tipsLabel.font = [UIFont systemFontOfSize:13];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.numberOfLines = 0;
        
        [tipsView addSubview:tipsLabel];
        
        // 布局
        
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tipsView);
            make.left.equalTo(tipsView).offset(15);
            make.right.equalTo(tipsView).offset(-15);
        }];
    }
    // items
    
    for (int i = 0 ; i<_items.count; i++) {
        
        CGFloat itemY = i * (ButtonHeight + GapLineHeight) + (_tips ? TipsViewHeight+GapLineHeight : 0);

        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(0, itemY, SCREEN_WIDTH, ButtonHeight);
        
        [item setTitle:_items[i] forState:UIControlStateNormal];
        [item setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:1.0]] forState:UIControlStateNormal];
        [item setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:1.0 alpha:0.5]] forState:UIControlStateHighlighted];
        if (i == 0) {
            [item setTitleColor:_itemColor forState:UIControlStateNormal];
        }else{
            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [item addTarget:self action:@selector(itemDidClick:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = i+1;
        
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

    CGPoint point = [[touches anyObject] locationInView:self.blurView];
    if (CGRectContainsPoint(self.tipsView.frame, point)) { // 点击tipsView 不隐藏self
        return;
    }
    [self hideView];
}

- (void)cancelBtnClick:(UIButton *)btn{
    _callback(0);
    [self hideView];
}

- (void)itemDidClick:(UIButton *)btn{

    _callback(btn.tag);
    [self hideView];
}

#pragma mark - public

+ (void)showAlertSheetViewWithTips:(NSString *)tips items:(NSArray<NSString *> *)items completion:(void (^)(NSInteger))completion{

    if (!items) {
        if (items.count <= 0) {
            NSLog(@"item's count could not is zero");
            return;
        }
        return;
    }
    
    WJAlertSheetView * sheetView = [[WJAlertSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds tips:tips items:items];

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
