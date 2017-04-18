//
//  ProfileViewController.m
//  JWChat
//
//  Created by jerry on 17/4/1.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "ProfileViewController.h"
#import "ChatToolBar.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

-(void)loadView {
    
    [super loadView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}
@end
