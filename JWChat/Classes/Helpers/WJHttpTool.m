//
//  WJHttpTool.m
//  sinaWeibo_dome
//
//  Created by JerryWang on 16/8/15.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import "WJHttpTool.h"
#import "AFNetworking.h"

@implementation WJHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 设置可以接受数据类型 设置content-Type为text/html 或 application/json都可以
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    mgr.requestSerializer.timeoutInterval = 15; // 设置超时时间
    // 2.发送请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (success) {
            success(responseObject); // block回调
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    mgr.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/html", nil];
    mgr.requestSerializer.timeoutInterval = 15;
    // 2.发送请求
    
    [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject); // block回调
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)post:(NSString *)url params:(NSDictionary *)params constructingBody:(void(^)(id<AFMultipartFormData> formData))constructingBody success:(void (^)(id respenseObject))success failure:(void (^)(NSError *error))failure{

    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/html", nil];
    mgr.requestSerializer.timeoutInterval = 15;
    
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (constructingBody) {
            constructingBody(formData);
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
