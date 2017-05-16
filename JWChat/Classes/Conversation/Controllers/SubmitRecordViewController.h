//
//  SubmitRecordViewController.h
//  XYTPatients
//
//  Created by jerry on 2017/5/2.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConsultOrderModel;

typedef void(^CompletionHandler)(ConsultOrderModel * consultInfo);

@interface SubmitRecordViewController : UIViewController

@property (nonatomic,copy)CompletionHandler completion;

@end
