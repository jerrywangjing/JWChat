//
//  DataManager.m
//  JWChat
//
//  Created by JerryWang on 2017/4/1.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "DataManager.h"
#import "WJHttpTool.h"

@implementation DataManager

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    [MBProgressHUD showHUD];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        
        NSString * url = @"http://test.jerry.com:8888/login.php";
        NSDictionary * params = @{ @"account" : username, @"password" : password };
        
        [WJHttpTool post:url params:params success:^(id responseObject) {
            NSDictionary * responseDic = (NSDictionary *)responseObject;
            
            success(responseDic);
        } failure:^(NSError *error) {
            
            failure(error);
        }];
        
    });
    
}
@end
