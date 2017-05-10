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

#define BottomBarH 80

@interface ArtboardViewController ()<ArtBoardBezierViewDelegate>

@property (nonatomic,strong) ArtBoardBezierView * artboardView;
@property (nonatomic,strong) UIView * toolbar;

@property (nonatomic,weak) UIButton * backBtn;
@property (nonatomic,weak) UIButton * forwordBtn;

@property (nonatomic,weak) UIButton * lastSelectedBtn; // 记录上次选中的颜色btn
@property (nonatomic,weak) UIButton * lastSelectedPencil; // 记录上次选中的铅笔
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
    _artboardView = [[ArtBoardBezierView alloc] initWithFrame:CGRectMake(0, NavBarH, SCREEN_WIDTH, SCREEN_HEIGHT-(NavBarH+BottomBarH))];
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
        make.right.equalTo(saveBtn.mas_left).offset(-10);
        make.bottom.equalTo(_toolbar).offset(-10);
    }];
    
    
    // bottom toolbar
    
    UIView * bottomToolbar = [[UIView alloc] init];
    bottomToolbar.backgroundColor = [UIColor whiteColor];
    UIView * bottomToolbarLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    bottomToolbarLine.backgroundColor = [UIColor lightGrayColor];
    
    [bottomToolbar addSubview:bottomToolbarLine];
    
    // color btns
    
    NSArray * colorsOfNor = @[@"black_nor",@"blue_nor",@"green_nor",@"yellow_nor",@"orange_nor",@"purple_nor"];
    colorsOfNor = [[colorsOfNor reverseObjectEnumerator] allObjects]; // 倒序排序
    
    NSArray * colorsOfHlt = @[@"black_hlt",@"blue_hlt",@"green_hlt",@"yellow_hlt",@"orange_hlt",@"purple_hlt"];
    colorsOfHlt = [[colorsOfHlt reverseObjectEnumerator] allObjects];
    
    for (NSInteger i = 0; i<colorsOfHlt.count; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:colorsOfNor[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:colorsOfHlt[i]] forState:UIControlStateSelected];
        btn.adjustsImageWhenHighlighted = NO;
        [btn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomToolbar addSubview:btn];
        
        if (i == colorsOfHlt.count-1) {
            btn.selected = YES;
            self.lastSelectedBtn = btn;
        }
        // 布局
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomToolbar.mas_right).offset(-20 -i*btn.currentImage.size.width -i*2);
            make.centerY.equalTo(bottomToolbar);
        }];
    }
    
    // 画笔
    
    NSArray * pencils = @[@"pen",@"brush",@"pencil"];
    for (NSInteger i = 0; i<pencils.count; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:pencils[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pencilClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.adjustsImageWhenHighlighted = NO;
        [bottomToolbar addSubview:btn];
        
        if (i == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                btn.transform = CGAffineTransformMakeTranslation(0, -15);
            }];
            self.lastSelectedPencil = btn; // 设置默认选中画笔
        }
        // 布局
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomToolbar).offset(30 + i*btn.currentImage.size.width + i*20);
            make.bottom.equalTo(bottomToolbar).offset(30);
        }];
    }
    
    [_toolbar addSubview:bottomLine];
    [self.view addSubview:_toolbar];
    [self.view addSubview:bottomToolbar];
    
    // 布局 bottom bar
    [bottomToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, BottomBarH));
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)dealloc{

}

#pragma mark - actions

- (void)doneBtnClick:(UIButton *)btn{

    if (_backBtn.isEnabled) { // 只有当前画板有线条时，才提示是否发送
        
        [WJAlertSheetView showAlertSheetViewWithTips:@"是否将涂鸦发送给对方？" items:@[@"发送"] completion:^(NSInteger index) {
            
            if (index == 0) { // 取消按钮点击
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            if (index == 1) { // 第一个item 点击
                WJWeakSelf(weakSelf);
                [MBProgressHUD showHUD];
                
                [self.artboardView getImageObject:^(UIImage *image) {
                    
                    [MBProgressHUD hideHUD];
                    
                    if (weakSelf.completion) {
                        weakSelf.completion(image);
                    }
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            
        }];
    }else{
    
        [self dismissViewControllerAnimated:YES completion:nil];
    }

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

    [WJAlertSheetView showAlertSheetViewWithTips:@"涂鸦将保存到手机相册中,是否继续？" items:@[@"保存到相册"] completion:^(NSInteger index) {

        if (index == 1) {
            [self.artboardView saveAsImage];
        }
    }];
}

- (void)colorBtnClick:(UIButton *)btn{

    if (_lastSelectedBtn.selected) {
        _lastSelectedBtn.selected = NO;
    }
    btn.selected = !btn.selected;
    
    _lastSelectedBtn = btn;
    
    // 设置画笔颜色
    switch (btn.tag) {
        case 0:
            self.artboardView.lineColor = [UIColor purpleColor];
            break;
        case 1:
            self.artboardView.lineColor = [UIColor orangeColor];
            break;
        case 2:
            self.artboardView.lineColor = [UIColor yellowColor];
            break;
        case 3:
            self.artboardView.lineColor = [UIColor greenColor];
            break;
        case 4:
            self.artboardView.lineColor = [UIColor blueColor];
            break;
        case 5:
            self.artboardView.lineColor = [UIColor blackColor];
            break;
            
        default:
            break;
    }
}

- (void)pencilClick:(UIButton *)btn{
    
    self.artboardView.pencilType = btn.tag;
    
    if (self.lastSelectedPencil) {
        [UIView animateWithDuration:0.2 animations:^{
            self.lastSelectedPencil.transform = CGAffineTransformIdentity;
        }];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformMakeTranslation(0, -15);
    }];
    
    self.lastSelectedPencil = btn;
    
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
