//
//  MainTabBarController.m
//  JWChat
//
//  Created by JerryWang on 2017/3/30.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavController.h"
#import "ConversationViewController.h"
#import "ContactsListViewController.h"
#import "ProfileViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

-(void)loadView {

    [super loadView];
    // init rootViews
    [self setTabBarViewControllers:[ConversationViewController new] barItemTitle:@"会话" barItemImage:@"conversation_nor" selectedImage:@"conversation_select"];
    
    [self setTabBarViewControllers:[ContactsListViewController new] barItemTitle:@"联系人" barItemImage:@"contact_nor" selectedImage:@"contact_select"];
    
    [self setTabBarViewControllers:[ProfileViewController new] barItemTitle:@"我" barItemImage:@"profile_nor" selectedImage:@"profile_select"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - private

- (void)setTabBarViewControllers:(UIViewController * )viewController barItemTitle:(NSString *)title barItemImage:(NSString *)image selectedImage:(NSString *)selectedImage{

    viewController.title = title;
    viewController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSDictionary * attsDic = @{NSForegroundColorAttributeName : WJRGBColor(120, 128, 144)};
    NSDictionary * selectedAtts = @{ NSForegroundColorAttributeName : ThemeColor};
    [viewController.tabBarItem setTitleTextAttributes:attsDic forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:selectedAtts forState:UIControlStateSelected];

    
    MainNavController * nav = [[MainNavController alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
    
}

@end
