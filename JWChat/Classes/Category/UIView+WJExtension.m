//
//  UIView+WJExtension.m
//  sinaWeibo_dome
//
//  Created by JerryWang on 16/5/21.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import "UIView+WJExtension.h"

@implementation UIView (WJExtension)

/**
 *  setter方法
 */
-(void)setX:(CGFloat)x{

    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)setY:(CGFloat)y{

    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(void)setWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(void)setHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(void)setSize:(CGSize)size{

    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(void)setOrigin:(CGPoint)origin{

    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
-(void)setCenterX:(CGFloat)centerX{

    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
-(CGFloat)centerX{

    return self.center.x;
}
-(void)setCenterY:(CGFloat)centerY{

    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
-(CGFloat)centerY{

    return self.center.y;
}
/**
 *  getter方法
 */
-(CGFloat)x{

    return  self.frame.origin.x;
}

-(CGFloat)y{

    return self.frame.origin.y;
}

-(CGFloat)width{

    return self.frame.size.width;
}

-(CGFloat)height{

    return self.frame.size.height;
}

-(CGSize)size{

    return self.frame.size;
}

-(CGPoint)origin{

    return self.frame.origin;
}
// cell borderView
+ (UIView *)cellTopBorderView{
    
    UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

+ (UIView *)cellBottomBorderView:(CGFloat)cellHeight{

    UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-0.5, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

/// UIImageView 圆角矩形

- (void)makeRoundedRectWithRadius:(float)radius{
    
    [self makeRoundedRectWithRadius:radius RoundingCorners:UIRectCornerAllCorners];
}

- (void)makeRoundedRectWithRadius:(float)radius RoundingCorners:(UIRectCorner)roundingCorners{
    
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    
    // 防止圆角半径小于0，或者大于宽/高中较小值的一半。
    if (radius < 0)
        radius = 0;
    else if (radius > MIN(w/2, h/2))
        radius = MIN(w, h) / 2.;
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:roundingCorners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
}

@end
