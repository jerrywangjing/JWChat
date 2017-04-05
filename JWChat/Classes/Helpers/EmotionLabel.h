//
//  EmotionLabel.h
//  ESDemo
//
//  Created by jerry on 16/9/20.
//  Copyright © 2016年 Zhang, Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmotionLabel : UILabel

@property(nonatomic, copy)NSMutableAttributedString *attriText;

@property(nonatomic, assign)BOOL isFirst;

@end
