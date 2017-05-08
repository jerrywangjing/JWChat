//
//  ArtboardViewController.m
//  JWChat
//
//  Created by JerryWang on 2017/5/8.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "ArtboardViewController.h"
#import "ArtBoardBezierView.h"
#import "WJAlertSheetView.h"

@interface ArtboardViewController ()<ArtBoardBezierViewDelegate>

@property (nonatomic,strong) ArtBoardBezierView * artboardView;
@property (nonatomic,strong) UIView * toolbar;

@property (nonatomic,weak) UIButton * backBtn;
@property (nonatomic,weak) UIButton * forwordBtn;
@end

@implementation ArtboardViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // init code
    }
    return self;
}

- (void)loadView{

    [super loadView];
    
    // artboard
    _artboardView = [[ArtBoardBezierView alloc] initWithFrame:CGRectMake(0, NavBarH, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarH)];
    _artboardView.backgroundColor = [UIColor whiteColor];
    _artboardView.delegate = self;
    [self.view addSubview:_artboardView];
    
    // toolbar
    
    _toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBarH)];
    _toolbar.backgroundColor = [UIColor whiteColor];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarH-0.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    
    // done btn
    
    UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:WJRGBColor(220, 220, 220) forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // delete btn
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // back btn
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn = backBtn;
    [backBtn setImage:[UIImage imageNamed:@"backBtn_normal"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"backBtn_disable"] forState:UIControlStateDisabled];
    backBtn.enabled = NO;
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // forword btn
    UIButton * forwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _forwordBtn = forwordBtn;
    [forwordBtn setImage:[UIImage imageNamed:@"forwordBtn_normal"] forState:UIControlStateNormal];
    [forwordBtn setImage:[UIImage imageNamed:@"forwordBtn_disable"] forState:UIControlStateDisabled];
    forwordBtn.enabled = NO;
    [forwordBtn addTarget:self action:@selector(forwordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // sava btn
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:WJRGBColor(220, 220, 220) forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolbar addSubview:doneBtn];
    [_toolbar addSubview:deleteBtn];
    [_toolbar addSubview:backBtn];
    [_toolbar addSubview:forwordBtn];
    [_toolbar addSubview:saveBtn];
    
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_toolbar).offset(15);
        make.bottom.equalTo(_toolbar).offset(-5);
    }];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_toolbar).offset(-10);
        make.left.equalTo(doneBtn.mas_right).offset(20);
    }];
    [forwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_toolbar).offset(-10);
        make.left.equalTo(backBtn.mas_right).offset(20);
        
    }];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_toolbar).offset(-15);
        make.bottom.equalTo(doneBtn);
    }];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(saveBtn.mas_left).offset(-20);
        make.bottom.equalTo(_toolbar).offset(-10);
    }];
    
    [_toolbar addSubview:bottomLine];
    [self.view addSubview:_toolbar];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)dealloc{

}

#pragma mark - actions

- (void)doneBtnClick:(UIButton *)btn{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteBtnClick:(UIButton *)btn{
    [self.artboardView clearScreen];

}
- (void)backBtnClick:(UIButton *)btn{
    [self.artboardView back];
}
- (void)forwordBtnClick:(UIButton *)btn{
    [self.artboardView forword];
}
- (void)saveBtnClick:(UIButton *)btn{

    [WJAlertSheetView showAlertSheetViewItems:@[@"涂鸦将保存到手机相册中是否继续？",@"保存到相册"] completion:^(NSInteger index) {
        if (index == 1) {
            [self.artboardView saveAsImage];
        }
    }];
}

#pragma mark - delegate

- (void)artboard:(ArtBoardBezierView *)artboard didStartedDraw:(NSInteger)lineCount{

    if (lineCount > 0) {
        _backBtn.enabled = YES;
    }else{
    
        _backBtn.enabled = NO;
    }
}

- (void)artboard:(ArtBoardBezierView *)artboard couldForwordDraw:(NSInteger)forwordLineCount{

    if (forwordLineCount > 0) {
        _forwordBtn.enabled = YES;
    }else{
    
        _forwordBtn.enabled = NO;
    }
}

@end
