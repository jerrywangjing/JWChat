//
//  RecordView.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/25.
//  Copyright © 2016年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    RecordViewTypeTouchDown,
    RecordViewTypeTouchUpInside,
    RecordViewTypeTouchUpOutside,
    RecordViewTypeDragInside,
    RecordViewTypeDragOutside,
    
}RecordViewType;

@interface RecordView : UIView

@property (nonatomic) NSArray *voiceMessageAnimationImages UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSString *upCancelText UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSString *loosenCancelText UI_APPEARANCE_SELECTOR;

-(void)recordButtonTouchDown;
-(void)recordButtonTouchUpInside;
-(void)recordButtonTouchUpOutside;
-(void)recordButtonDragInside;
-(void)recordButtonDragOutside;

-(void)recordTimeTooShort;
@end
