//
//  MapViewController.h
//  JWChat
//
//  Created by JerryWang on 2017/5/15.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMapGeoPoint;

typedef void(^MapCompletionBlock)(UIImage *image,NSString *address,NSString *roadName,AMapGeoPoint *coordinate);

@interface MapViewController : UIViewController

@property (nonatomic,copy)MapCompletionBlock completion;

@end
