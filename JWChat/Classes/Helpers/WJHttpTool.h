//
//  WJHttpTool.h
//  sinaWeibo_dome
//
//  Created by JerryWang on 16/8/15.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WJHttpTool : NSObject

/** AFN GET请求封装*/
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/** AFN POST请求封装*/
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/** AFN POST 构建体请求封装*/
+(void)post:(NSString *)url params:(NSDictionary *)params constructingBody:(void(^)(id<AFMultipartFormData> formData))constructingBody success:(void (^)(id respenseObject))success failure:(void (^)(NSError *error))failure;
@end
