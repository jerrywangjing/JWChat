//
//  AddOtherFuncKeyboard.m
//
//  Created by jerry on 16/9/20.


#import "AddOtherFuncKeyboard.h"

#define NumberOfSinglePage 8 // 一个页面可容纳的最多按钮数

#define leftRightGap 25*WIDTH_RATE
#define topBottomGap 25
#define BtnWH 65

@interface AddOtherFuncKeyboard ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView * contentScrollView;
@property (nonatomic,strong) UIPageControl * pageControl;
@end

@implementation AddOtherFuncKeyboard


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDataAndSubviews];
    }
    return self;
}

-(void)initDataAndSubviews{

    NSString * dataPath = [[NSBundle mainBundle] pathForResource:@"funKeyboardData.plist" ofType:nil];
    _dataArr = [NSArray arrayWithContentsOfFile:dataPath];
    
    NSInteger pageCount = self.dataArr.count / NumberOfSinglePage;
    if (self.dataArr.count % NumberOfSinglePage > 0) {
        pageCount += 1;
    }
    
    //NSLog(@"加载更多视图：pageCount:%ld",pageCount);
    
    UIScrollView * contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _contentScrollView = contentScrollView;
    _contentScrollView.delegate = self;
    contentScrollView.backgroundColor = IMBgColor;
    contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * pageCount, self.frame.size.height);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < pageCount; i++) {
        [self addBtnsWithPageNum:i];
    }
    
    [self addSubview:contentScrollView];
    
    // 添加pageControl
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(SCREEN_WIDTH/2, self.height-20*HEIGHT_RATE, 0, 0);
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = ThemeColor;
    pageControl.hidesForSinglePage = YES;
    pageControl.numberOfPages = pageCount;
    _pageControl = pageControl;
    [self addSubview:_pageControl];
    [self bringSubviewToFront:_pageControl];
    
}
// 循环添加按钮
-(void)addBtnsWithPageNum:(NSInteger)number{
    
    // 添加按钮
    NSInteger maxCol = 4;
    NSInteger maxRow = 2;
    
    CGFloat btnW = BtnWH * WIDTH_RATE;
    CGFloat btnH = BtnWH * HEIGHT_RATE;
    CGFloat leftRightMargin = (SCREEN_WIDTH - (maxCol * btnW + (maxCol-1) * leftRightGap))/2; // 左右内边距;
    CGFloat topBottomMargin = (self.height - (maxRow * btnH + (topBottomGap+30)))/2;

    NSInteger count = self.dataArr.count - (number * NumberOfSinglePage);
    NSInteger indexCount;
    if (count > 0 && count <= NumberOfSinglePage) {
        
        indexCount = count;
    }else if(count > NumberOfSinglePage){
        
        indexCount = NumberOfSinglePage;
    }else{
        
        return;
    }
    
    // Warning: 这里的多线程使用会造成过场动画消失bug
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i<indexCount; i++) {
            UIButton  * btn = [[UIButton alloc] init];
            
            int col = i % maxCol;
            int row = i / maxCol;
            NSInteger index = i + number * NumberOfSinglePage;
            NSDictionary * btnDic = self.dataArr[index];
            
            //设置图片内容（使图片和文字水平居中显示）
            btn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
            //btn.backgroundColor = [UIColor orangeColor];
            [btn setImage:[UIImage imageNamed:btnDic[@"image"]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            // 设置图片frame
            
            btn.x = col * (btnW + leftRightGap) + leftRightMargin + number * self.width;
            btn.y = row * (btnH + topBottomGap) + topBottomMargin;
            
            btn.width = btnW;
            btn.height = btnH;
            btn.tag = index;
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.currentImage.size.height+20 ,-btn.imageView.frame.size.width, 0,0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, (btn.width - btn.imageView.width)/2 ,0 ,0)];//图片距离右边框距离减少图片的宽度，其它不变
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_contentScrollView addSubview:btn];
            
            //dispatch_async(dispatch_get_main_queue(), ^{
                
                [btn setTitle:btnDic[@"title"] forState:UIControlStateNormal];
            //});
        }

    //});
}


-(void)btnClick:(UIButton *)btn{

    switch (btn.tag) {
        case AddKeyboardBtnTypeSendPhoto:
            [self actionWithBtnType:AddKeyboardBtnTypeSendPhoto];
            break;
        case AddKeyboardBtnTypeTakePhoto:
            [self actionWithBtnType:AddKeyboardBtnTypeTakePhoto];
            break;
        case AddKeyboardBtnTypeVideo:
            [self actionWithBtnType:AddKeyboardBtnTypeVideo];
            break;
        case AddKeyboardBtnTypePhoneCall:
            [self actionWithBtnType:AddKeyboardBtnTypePhoneCall];
            break;
        case AddKeyboardBtnTypeSendFile:
            [self actionWithBtnType:AddKeyboardBtnTypeSendFile];
            break;
        case AddKeyboardBtnTypePatients:
            [self actionWithBtnType:AddKeyboardBtnTypePatients];
            break;
        case AddKeyboardBtnTypeMyConsult:
            [self actionWithBtnType:AddKeyboardBtnTypeMyConsult];
            break;
        case AddKeyboardBtnTypeHisConsult:
            [self actionWithBtnType:AddKeyboardBtnTypeHisConsult];
            break;
        default:
            break;
    }
}
// 发送照片

-(void)actionWithBtnType:(AddKeyboardBtnType)btnType{

    if ([self.delegate respondsToSelector:@selector(funcKeyboard:didBeginSendPhotosWithType:)]) {
        [self.delegate funcKeyboard:self didBeginSendPhotosWithType:btnType];
    }
}

#pragma mark - scroll delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger correntCount = (scrollView.contentOffset.x + self.width/2)/self.width;
    self.pageControl.currentPage = correntCount;
}

/*
    文件消息发送思路：
        1.点击文件按钮，进去文件选择控制器，使用原工作文件接口获取到本院工作文件数据，当点击后发送后，包装文件消息模型，UI展示存储数据库，当点击此文件消息时跳转到pdf 阅读器中显示。
        2.接收到文件消息时，UI展示存储数据库，当点击文件消息时下载此文件完成后pdf显示。
 
 */


@end
