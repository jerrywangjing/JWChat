//
//  WJAlertSheetView.h
//  JWChat
//
//  Created by JerryWang on 2017/4/26.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SelectedIndex) {
    SelectedIndexFirst,
    SelectedIndexSecond,
    SelectedIndexCancel,
};

@interface WJAlertSheetView : UIView

+ (void)showAlertSheetViewWithFirstItemTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle completion:(void (^)(SelectedIndex index))completion;

@end
