//
//  ArtBoardBezierView.h
//  Artboard
//
//  Created by JerryWang on 2017/5/6.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtBoardBezierView;

@protocol  ArtBoardBezierViewDelegate <NSObject>

- (void)artboard:(ArtBoardBezierView *)artboard didStartedDraw:(NSInteger)lineCount;
- (void)artboard:(ArtBoardBezierView *)artboard couldForwordDraw:(NSInteger)forwordLineCount;

@end
@interface ArtBoardBezierView : UIView

@property (nonatomic,strong) UIColor * lineColor;

@property (nonatomic,weak)id<ArtBoardBezierViewDelegate> delegate;

- (void)clearScreen;
- (void)back;
- (void)forword;
- (void)saveAsImage;

@end
