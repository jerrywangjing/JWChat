//
//  ArtBoardBezierView.m
//  Artboard
//
//  Created by JerryWang on 2017/5/6.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "ArtBoardBezierView.h"

@interface ArtBoardBezierView ()

@property (nonatomic,strong) NSMutableArray * pathsOfAllLine; // 所有线的路径
@property (nonatomic,strong) NSMutableArray * colorsOfLine; // 记录每一笔的颜色值
@property (nonatomic,strong) NSMutableArray * pathsOfForword; // 记录可以反悔的线条
@property (nonatomic,strong) NSMutableArray * colorsOfForword; // 记录可反悔的线条颜色
@end

@implementation ArtBoardBezierView

- (NSMutableArray *)colorsOfForword{

    if (!_colorsOfForword) {
        _colorsOfForword = [NSMutableArray array];
    }
    return _colorsOfForword;
}
- (NSMutableArray *)pathsOfForword{

    if (!_pathsOfForword) {
        _pathsOfForword = [NSMutableArray array];
    }
    return _pathsOfForword;
}

- (NSMutableArray *)colorsOfLine{
    
    if (!_colorsOfLine) {
        _colorsOfLine = [NSMutableArray array];
    }
    return _colorsOfLine;
}

- (NSMutableArray *)pathsOfAllLine{

    if (!_pathsOfAllLine) {
        _pathsOfAllLine = [NSMutableArray array];
    }
    return _pathsOfAllLine;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    
    for (NSInteger i = 0 ; i<self.pathsOfAllLine.count; i++) {
        
        UIBezierPath * path = self.pathsOfAllLine[i];
        UIColor * color = self.colorsOfLine[i];
        
        path.lineWidth = 3;
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        [color set];

        [path stroke];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 起始点
    UITouch * touch = [touches anyObject];
    CGPoint startPoint = [touch locationInView:self];
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint]; // 注意:这里需要给bezier曲线设置起始点
    
    [self.pathsOfAllLine addObject:path];
    
    // 设置默认颜色
    if (!self.lineColor) {
        self.lineColor = [UIColor blackColor];
    }
    // 记录每条线的颜色
    [self.colorsOfLine addObject:self.lineColor];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    // 获取到pointsOfAllLine数组的最后一个元素，添加当前画的所有点
    UIBezierPath * path = self.pathsOfAllLine.lastObject;
    [path addLineToPoint:touchPoint]; // 从起始点划线
    
    // 根据触摸点进行划线
    
    [self setNeedsDisplay];
    
    // 回调划线个数
    [self refreshBackBtn];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)clearScreen{
    
    [self.pathsOfAllLine removeAllObjects];
    [self.colorsOfLine removeAllObjects];
    [self setNeedsDisplay];
    
    [self refreshForwordBtn];
    [self refreshBackBtn];
}

- (void)setLineColor:(UIColor *)lineColor{
    
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}

-(void)back{
    // 首先记录需要撤销的线条，用于反悔
    [self.pathsOfForword addObject:self.pathsOfAllLine.lastObject];
    [self.colorsOfForword addObject:self.colorsOfLine.lastObject];
    
    // 删除重做线条
    [self.pathsOfAllLine removeLastObject];
    [self.colorsOfLine removeLastObject];
    [self setNeedsDisplay];
    
    [self refreshBackBtn];
    [self refreshForwordBtn];
}

-(void)forword{

    // 撤销后退
    [self.pathsOfAllLine addObject:self.pathsOfForword.lastObject];
    [self.colorsOfLine addObject:self.colorsOfForword.lastObject];
    [self setNeedsDisplay];
    
    // 删除使用后的可反悔元素
    [self.pathsOfForword removeLastObject];
    [self.colorsOfForword removeLastObject];
    
    [self refreshBackBtn];
    [self refreshForwordBtn];
}

- (void)saveAsImage{
    
    // 保存截图到相册中
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext(); // 一定记得要结束位图上下文
    
    // 保存图片
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (!error) {
        [MBProgressHUD showLabelWithText:@"保存成功"];
    }else{
    
        [MBProgressHUD showLabelWithText:@"保存失败"];
    }
}

- (void)refreshBackBtn{

    if ([self.delegate respondsToSelector:@selector(artboard:didStartedDraw:)]) {
        [self.delegate artboard:self didStartedDraw:self.pathsOfAllLine.count];
    }
}

- (void)refreshForwordBtn{

    if ([self.delegate respondsToSelector:@selector(artboard:couldForwordDraw:)]) {
        [self.delegate artboard:self couldForwordDraw:self.pathsOfForword.count]
        ;
    }
}

@end
