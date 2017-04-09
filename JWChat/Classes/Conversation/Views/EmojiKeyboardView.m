//
//  EmojiKeyboardView.m
//  XunYiTongV2.0
//
//  Created by JerryWang on 2016/12/17.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import "EmojiKeyboardView.h"
#import "UIView+WJExtension.h"

#define EmojiViewH 187.5
#define ToolBarH 37.5
#define ToolBtnCount 7

#define WidthGap 18 // 可调节布局间距
#define HeightGap 20
#define BtnWH 30*WIDTH_RATE  // 宽高相等

#define MaxCol 7
#define MaxRow 3
#define NumberOfSinglePage 21 // 一个页面可容纳的最多按钮数
#define PageControlH 15


@interface EmojiKeyboardView ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView * contentScrollView;
@property (nonatomic,weak) UIPageControl * pageControl;
@property (nonatomic,weak) UIView * toolbar;
@property (nonatomic,assign) NSInteger btnsCount;
@property (nonatomic,weak) UIButton * lastBtn;

/// 子视图数据
@property (nonatomic,strong) NSArray * dataArr;

@end

@implementation EmojiKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 初始化
        [self initDataAndSubviews];
    }
    return self;
}

-(void)initDataAndSubviews{

    // 加载默认测试数据

    NSString * dataPath = [[NSBundle mainBundle] pathForResource:@"EmojiImagesArray.plist" ofType:nil];
    _dataArr = [NSArray arrayWithContentsOfFile:dataPath];
    _btnsCount = _dataArr.count;

    NSInteger pageCount = _btnsCount / NumberOfSinglePage;
    if (_btnsCount % NumberOfSinglePage > /* DISABLES CODE */ (0)) {
        pageCount += 1;
    }
    
    //NSLog(@"加载表情视图：pageCount:%ld",pageCount);
    
    UIScrollView * contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width,EmojiViewH)];
    _contentScrollView = contentScrollView;
    _contentScrollView.delegate = self;
    contentScrollView.backgroundColor = IMBgColor;
    contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * pageCount, EmojiViewH);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;

    [self addSubview:contentScrollView];

    // 添加pageControl
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(SCREEN_WIDTH/2, EmojiViewH-PageControlH, 0, 0);
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = ThemeColor;
    pageControl.hidesForSinglePage = YES;
    pageControl.numberOfPages = pageCount;
    _pageControl = pageControl;
    [self addSubview:_pageControl];
    [self bringSubviewToFront:_pageControl];
    
    // 添加表情按钮

    for (int i = 0; i < pageCount; i++) {
        [self addBtnsWithPageNum:i];//循环添加所有表情(耗时操作)
    }

    // 添加toolbar
    UIView * toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, EmojiViewH, self.width, ToolBarH)];
    _toolbar = toolbar;
    _toolbar.backgroundColor = [UIColor whiteColor];
    [self addSubview:_toolbar];
        //添加toolbar 上的按钮

    CGFloat btnW = self.width/ToolBtnCount;
    CGFloat btnH = ToolBarH;
    
    for (int i = 0; i<ToolBtnCount; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(btnW*i, 0, btnW,btnH);
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(toolbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:btn];
        // 发送按钮
        if (i == ToolBtnCount-1) {
            [btn setTitle:@"发送" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            [btn setBackgroundImage:[UIImage imageNamed:@"enableBtn_bg"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"voice_press_bg"] forState:UIControlStateDisabled];
            self.sendBtn = btn;
            self.sendBtn.enabled = NO;
            
        }else if(i == 0){
        
            [btn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"voice_press_bg"] forState:UIControlStateNormal];
        }
        
    }
    
}

// 循环添加按钮
-(void)addBtnsWithPageNum:(NSInteger)pageNum{
    
    // 添加按钮
    
    CGFloat btnW = BtnWH;
    CGFloat btnH = BtnWH;
    CGFloat widthMargin = (self.width - (MaxCol*btnW + (MaxCol-1) * WidthGap))/2; // 横向边距
    CGFloat heightMargin = (EmojiViewH - (MaxRow*btnH + (MaxRow-1) * HeightGap))/2; // 纵向边距

    NSInteger count = _btnsCount - (pageNum * NumberOfSinglePage);
    NSInteger indexCount;
    if (count > 0 && count <= NumberOfSinglePage) {
        
        indexCount = count;
    }else if(count > NumberOfSinglePage){
        
        indexCount = NumberOfSinglePage;
    }else{
        
        return;
    }
    
    
    for (int i = 0; i<indexCount; i++) {
        UIButton  * btn = [[UIButton alloc] init];
        
        int col = i % MaxCol;
        int row = i / MaxCol;
        //注意：由于表情中有删除按钮，取表情按钮时需要减个页码号才正确
        NSInteger index = i + (pageNum * NumberOfSinglePage - pageNum);
        
        // 设置图片frame
        
        btn.x = col * (btnW + WidthGap) + widthMargin + pageNum * self.width;
        btn.y = row * (btnH + HeightGap) + heightMargin;
        
        btn.width = btnW;
        btn.height = btnH;
        btn.tag = index;
        
        [btn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (i== NumberOfSinglePage-1) {
                [btn setImage:[UIImage imageNamed:@"expression_delete"] forState:UIControlStateNormal];
            }else{
                
                [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"[%ld]",index+1]] forState:UIControlStateNormal];
            }
            
            [_contentScrollView addSubview:btn];
            
            self.completionBlock();
        });
        
    }

    // 如果单页按钮数量少于最大容纳数时，任然需要添加删除按钮
    if (indexCount <= (NumberOfSinglePage-1)) {
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.x = (MaxCol-1) * (btnW + WidthGap) + widthMargin + pageNum * self.width;
        btn.y = (MaxRow-1) * (btnH + HeightGap) + heightMargin;
        
        btn.width = btnW;
        btn.height = btnH;
        btn.tag = ((NumberOfSinglePage-1) + pageNum*(NumberOfSinglePage-1));
        
        [btn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [btn setImage:[UIImage imageNamed:@"expression_delete"] forState:UIControlStateNormal];
        });
        [_contentScrollView addSubview:btn];
    }
    
}

#pragma mark - 点击事件

-(void)emojiBtnClick:(UIButton *)btn{
    
    
    if (btn.tag == ((NumberOfSinglePage-1) + _pageControl.currentPage*(NumberOfSinglePage-1))) { // 减一是为了排除删除按钮
        //NSLog(@"删除:%ld",btn.tag);
        [self.inputView deleteBackward];

        if ([self.delegate respondsToSelector:@selector(deleteBtnDicClick:)]) {
            [self.delegate deleteBtnDicClick:btn];
        }
    }else{
    
        [self appendEmojiToInputViewWithTag:btn.tag];
        if ([self.delegate respondsToSelector:@selector(emojiBtnDidClick:)]) {
            [self.delegate emojiBtnDidClick:btn];
        }
        //NSLog(@"点击表情:%ld",btn.tag);
    }
     
}

-(void)toolbarBtnClick:(UIButton * )btn{

    // 处理点击背景高亮(表情包大于1后使用)
//    if (_lastBtn.selected) {
//        _lastBtn.selected = NO;
//    }
//    btn.selected = YES;
//    _lastBtn = btn;
    
    // 处理点击事件
    if (btn.tag == ToolBtnCount-1) {
        //NSLog(@"发送消息");
        if ([self.delegate respondsToSelector:@selector(sendBtnDicClick:)]) {
            [self.delegate sendBtnDicClick:btn];
        }
        
    }else{
    
        if ([self.delegate respondsToSelector:@selector(emojiItemBtnClick:)]) {
            [self.delegate emojiItemBtnClick:btn];
        }
        //NSLog(@"表情包:%ld",btn.tag);
    }
    
}

// 映射表情文字
-(void)appendEmojiToInputViewWithTag:(NSInteger )tag{

    NSString * path = [[NSBundle mainBundle] pathForResource:@"LiuqsEmotionTags.plist" ofType:nil];
    NSArray * emojiArr = [NSArray arrayWithContentsOfFile:path];

    self.inputView.text = [self.inputView.text stringByAppendingString:emojiArr[tag]];
}

#pragma mark - scroll delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger correntCount = (scrollView.contentOffset.x + self.width/2)/self.width;
    self.pageControl.currentPage = correntCount;
}
@end
