//
//  LoginManager.m
//  JWChat
//
//  Created by jerry on 2017/4/17.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "LoginManager.h"
#import <SAMKeychain.h>

@implementation LoginManager

+(instancetype)shareManager{

    static LoginManager * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LoginManager alloc] init];
    });
    
    return instance;
}

// 登录

-(void)loginWithAccount:(NSString *)account password:(NSString *)password completionHandler:(void (^)())completion{
    
    [DataManager loginWithUsername:account password:password success:^(NSDictionary *responseDic) {
        
        NSString *result = responseDic[@"result"];
        NSString *msg = responseDic[@"msg"];
        NSString *token = responseDic[@"NIMToken"];
        
        if ([result isEqualToString:@"1"]) {
            
            if (token) {
                //初始化NIM引擎
                
                [[NIMSDK sharedSDK].loginManager login:account token:token completion:^(NSError * _Nullable error) {
                    
                    if (!error) {
   
                        //保存登录数据
                        
                        NSString * userId = [[NIMSDK sharedSDK].loginManager currentAccount];
                        NIMUser * user = [[NIMSDK sharedSDK].userManager userInfo:userId];
                        NSString * avatarUrl = [ContactsManager getAvatarUrl:user];
                        
                        [WJUserDefault setObject:account forKey:kAccount];
                        [WJUserDefault setObject:avatarUrl forKey:kAvatarUrl];
                        
                        [SAMKeychain setPassword:password forService:kPassword account:account];
                        [SAMKeychain setPassword:token forService:kToken account:account];
                        
                        // 获取用户资料
                        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[account] completion:nil];
                        
                        // 回调处理
                        completion();
                        
                    }else{
                        NSLog(@"NIM引擎登录失败：error:%@",error.localizedDescription);
                        [MBProgressHUD showLabelWithText:@"登录失败"];
                    }
                    
                }];
                
            }
            
        }else{
            
            [MBProgressHUD showLabelWithText:msg];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showLabelWithText:@"登录失败"];
    }];

}

- (BOOL)isFirstLogin{
    
    NSString * account = [WJUserDefault objectForKey:kAccount];
    if (account) {
        
        NSString * password = [SAMKeychain passwordForService:kPassword account:account];
        NSString * token = [SAMKeychain passwordForService:kToken account:account];
        
        if (password && token) {
            
            return NO;
        }
    }
    return YES;
}

- (void)autoLogin{
    
    if ([self isFirstLogin]) {
        return;
    }

    NSString * account = [WJUserDefault objectForKey:kAccount];
    NSString * token = [SAMKeychain passwordForService:kToken account:account];
    
    [[NIMSDK sharedSDK].loginManager autoLogin:account token:token];
}

-(void)logout{

    NSString * account = [WJUserDefault objectForKey:kAccount];
    
    [SAMKeychain deletePasswordForService:kPassword account:account];
    [SAMKeychain deletePasswordForService:kToken account:account];
    //[WJUserDefault setObject:nil forKey:kAccount];
    
    NSLog(@"已清除登录数据");
}


@end
