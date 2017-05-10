//
//  ArtboardViewController.h
//  JWChat
//
//  Created by JerryWang on 2017/5/8.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionHandler)(UIImage *);

@interface ArtboardViewController : UIViewController

@property (nonatomic,copy) CompletionHandler completion;

@end
