//
//  RecordView.m
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "RecordView.h"
#import "EMCDDeviceManager.h"

@interface RecordView()

@property (nonatomic ,strong)NSTimer * timer;
@property (nonatomic,weak) UIImageView * recordAnimationView;
@property (nonatomic ,weak) UILabel * textLabel;
@end

@implementation RecordView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    RecordView *recordView = [self appearance]; // 获取全局的recordView 实例对象
    recordView.voiceMessageAnimationImages = @[@"voice1",@"voice2",@"voice3",@"voice4",@"voice5",@"voice6",@"voice7",];
    recordView.upCancelText = NSEaseLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
    recordView.loosenCancelText = NSEaseLocalizedString(@"message.toolBar.record.loosenCancel", @"loosen the fingers, to cancel sending");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
//        bgView.backgroundColor = [UIColor grayColor];
//        bgView.layer.cornerRadius = 5;
//        bgView.layer.masksToBounds = YES;
//        bgView.alpha = 0.6;
//        [self addSubview:bgView];
        
        UIImageView * recordAnimationView = [[UIImageView alloc] initWithFrame:self.bounds];
        _recordAnimationView = recordAnimationView;
        _recordAnimationView.image = [UIImage imageNamed:@"voice1"];
        _recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordAnimationView];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                               self.bounds.size.height - 30,
                                                               self.bounds.size.width - 10,
                                                               25)];
        _textLabel = label;
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = NSEaseLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 7;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - setter
- (void)setVoiceMessageAnimationImages:(NSArray *)voiceMessageAnimationImages
{
    _voiceMessageAnimationImages = voiceMessageAnimationImages;
}

- (void)setUpCancelText:(NSString *)upCancelText
{
    _upCancelText = upCancelText;
    _textLabel.text = _upCancelText;
}

- (void)setLoosenCancelText:(NSString *)loosenCancelText
{
    _loosenCancelText = loosenCancelText;
}

-(void)recordButtonTouchDown
{
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    
}

-(void)recordButtonTouchUpInside
{
    [_timer invalidate]; // 使timer 定时器失效
}

-(void)recordButtonTouchUpOutside
{
    [_timer invalidate];
}

-(void)recordButtonDragInside
{
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
}

-(void)recordButtonDragOutside
{
    _textLabel.text = _loosenCancelText;
    _textLabel.backgroundColor = WJRGBColor(139, 42, 41);
    [_timer invalidate];
    _recordAnimationView.image = [UIImage imageNamed:@"cancel"];

}

-(void)setVoiceImage {
    _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:0]];
    double voiceSound = 0;
    // 获取麦克风音量 audio volumn (0~1) double 值
    voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter]; 
    
    int index = voiceSound*[_voiceMessageAnimationImages count];// 通过音量转换出对应的帧图片
    
    if (index >= [_voiceMessageAnimationImages count]) {
        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages lastObject]];
    } else {
        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:index]];
    }

}
-(void)recordTimeTooShort{

    _recordAnimationView.image = [UIImage imageNamed:@"tooshort"];
    _textLabel.text = @"说话时间太短";
}


@end
