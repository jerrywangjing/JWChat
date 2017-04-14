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

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(LoginState))success failure:(void (^)(NSError *))failure{

    [MBProgressHUD showHUD];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        
//        if (username && password) {
//            if ([username isEqualToString:@"Jerry"] && [password isEqualToString:@"111111"]) {
//                success(LoginStateSuccess);
//            }else{
//                success(LoginStateFailure);
//            }
//        }else{
//            // 服务器错误
//            NSError * error = nil;
//            failure(error);
//        }
        
        NSString * url = @"http://test.jerry.com:8888/login.php";
        NSDictionary * params = @{ @"account" : username,@"password" : password };
        
        [WJHttpTool post:url params:params success:^(id responseObject) {
            NSDictionary * response = (NSDictionary *)responseObject;
            
            NSString * result = response[@"result"];
            if ([result isEqualToString:@"1"]) {
                success(LoginStateSuccess);
            }
            
        } failure:^(NSError *error) {
            
            failure(error);
        }];
        
    });
    
}
@end
