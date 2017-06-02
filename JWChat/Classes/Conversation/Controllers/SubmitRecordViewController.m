//
//  SubmitRecordViewController.m
//  XYTPatients
//
//  Created by jerry on 2017/5/2.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import "SubmitRecordViewController.h"
#import <TZImagePickerController.h>
//#import "ConsultOrderModel.h"
//#import "RichTextEditorViewController.h"
#import <YYText.h>

static const CGFloat TextViewH = 300;

@interface SubmitRecordViewController ()<UITableViewDataSource,UITableViewDelegate,YYTextViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;

@property (nonatomic,assign) BOOL allowSendRecord;
@property (nonatomic,strong) YYTextView * textView;

@property (nonatomic,strong) NSDictionary * userInfo; // 用户身份信息
@property (nonatomic,strong) NSMutableArray * insertImages; // 记录插入的图片

//@property (nonatomic,strong) RichTextEditorViewController * richTextEditorVc; //富文本编辑器

@end

@implementation SubmitRecordViewController

#pragma mark - getter

- (NSMutableArray *)insertImages{

    if (!_insertImages) {
        _insertImages = [NSMutableArray array];
    }
    return _insertImages;
}

#pragma mark - init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // init code
        _allowSendRecord = YES;
    }
    return self;
}

- (void)loadView{
    
    [super loadView];
    
    // init subViews
    [self setupSubviews];
    
//    NSString * phoneNumber = [WJUserDefault objectForKey:kPhoneNumber];
//    _userInfo = [DataManager getUserIDCARDInfoFromKeychainWithID:phoneNumber];
}

- (void)dealloc{
    
    // deinit
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提交病历";
    
    UIBarButtonItem * exchange = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStylePlain target:self action:@selector(exchangeClick:)];
    self.navigationItem.rightBarButtonItem = exchange;
    
    // load data
    [self configData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    
//    [[IQKeyboardManager sharedManager] setEnable:YES];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
//    [[IQKeyboardManager sharedManager] setEnable:NO];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    }
}

- (void)setupSubviews{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = IMBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // table footer view
    
    UIView * footerView = [[UIView alloc] init];
    footerView.size = CGSizeMake(SCREEN_WIDTH, 75);
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton * confimBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [confimBtn setBackgroundImage:[UIImage resizeImage:@"login_nor"] forState:UIControlStateNormal];
    [confimBtn setBackgroundImage:[UIImage resizeImage:@"login_hlt"] forState:UIControlStateHighlighted];
    [confimBtn setTitle:@"提交咨询" forState:UIControlStateNormal];
    [confimBtn addTarget:self action:@selector(confirmBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:confimBtn];
    _tableView.tableFooterView = footerView;
    
    [confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.bottom.equalTo(footerView);
        make.height.mas_equalTo(45);
        make.left.equalTo(footerView).offset(50);
        make.right.equalTo(footerView).offset(-50);
    }];
    
}

- (void)configData{
    
    _dataSource = @[
                    @{
                        HeaderTitle : @"",
                        RowContent  : @[
                                @{
                                    ImageUrl: @"ic_chat_consultcontent_nor",
                                    Title : @"咨询内容",
                                    SubTitle : @"",
                                    },
                                @{},
                                @{
                                    ImageUrl: @"ic_chart_addimage_nor",
                                    Title : @"插入图片",
                                    SubTitle : @"可插入相关症状，检验报告等图片",
                                    },
                                
                                ],
                        FooterTitle : @"",
                        
                        },
                    @{
                        HeaderTitle : @"",
                        RowContent : @[
                                @{
                                    ImageUrl: @"ic_chart_choice",
                                    Title : @"发送病史资料",
                                    SubTitle : @""
                                    }
                                ],
                        FooterTitle : @""
                        }
                    
                    ];
    
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * rowsArr = self.dataSource[section][RowContent];
    
    return rowsArr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.dataSource[section][HeaderTitle];
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    return self.dataSource[section][FooterTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return TextViewH;
        }
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * data = _dataSource[indexPath.section][RowContent][indexPath.row];
    UITableViewCell * baseCell = [self creatBaseCellWithSubTitle:data[SubTitle]];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            baseCell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        if (indexPath.row == 1) {
            UITableViewCell * textViewCell = [self creatTextViewCell];
            return textViewCell;
        }
        if (indexPath.row == 2) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 0.5)];
            line.backgroundColor = WJRGBColor(202, 202, 202);
            [baseCell.contentView addSubview:line];
        }
    }

    baseCell.imageView.image = [UIImage imageNamed:data[ImageUrl]];
    baseCell.textLabel.text = data[Title];

    return baseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell * currentCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            // 插入图片
            [self insetImage];
        }
    }
    
    if (indexPath.section == 1) {
        // 是否发送病史资料
        _allowSendRecord = !_allowSendRecord;
        
        UIImage * checkBox = _allowSendRecord ? [UIImage imageNamed:@"ic_chart_choice"] : [UIImage imageNamed:@"ic_chart_nochoice"];
        currentCell.imageView.image = checkBox;
        
    }
    
}

#pragma mark - actions

- (void)exchangeClick:(UIButton *)btn{

    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:self.textView.text];
    [att yy_setAttributes:@{
                            NSFontAttributeName : [UIFont systemFontOfSize:20],
                            
                            }];

}
- (void)confirmBtnDidClick:(UIButton *)btn{
    
    
    if (_textView.text.length <= 0) {
        [MBProgressHUD showLabelWithText:@"请输入咨询内容"];
        return;
    }
    
    [MBProgressHUD showHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 截取咨询信息中前8个字符作为摘要信息
        
        NSString * summary = @"";
        
        if (_textView.text.length >= 8) {
            
            summary = [[_textView.text substringToIndex:8] stringByAppendingString:@"..."];
        }else{
            
            summary = _textView.text;
        }
        
        // 转模型
        
//        ConsultOrderModel * consultModel = [[ConsultOrderModel alloc] init];
//        consultModel.orderType = ConsultOrderTypeConsult;
//        consultModel.patientName = _userInfo[KEY_IDCARDNAME];
//        consultModel.patientAge = _userInfo[KEY_AGE];
//        consultModel.patientGender = _userInfo[KEY_GENDER];
//        consultModel.orderSummary = summary;
        
        // 富文本数据缓存
        
        [self cacheRichTextWithOrderModel:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            
            if (self.completion) {
                //self.completion(consultModel);
            }
            
            //[self.navigationController popViewControllerAnimated:YES];
        });
        
    });
   
}

- (void)keyboardWillShow{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -44);
    }];
}

- (void)keyboardWillHide{

    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[_tableView class]]) {
        
        [self.view endEditing:YES];
    }
}

#pragma mark - textView delegate

- (void)textViewDidBeginEditing:(YYTextView *)textView{

}

- (void)textViewDidEndEditing:(YYTextView *)textView{

}

#pragma mark - private

- (UITableViewCell *)creatBaseCellWithSubTitle:(NSString *)subStr{
    
    static NSString * baseCellId = @"baseCellId";
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:baseCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseCellId];
        
        UILabel * subTitle = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, cell.width, cell.height)];
        subTitle.textColor = [UIColor grayColor];
        subTitle.font = [UIFont systemFontOfSize:15];
        subTitle.text = subStr;
        
        [cell.contentView addSubview:subTitle];
    }
    
    return cell;
}

- (UITableViewCell *)creatTextViewCell{

    static NSString * textViewCellId = @"textViewCellId";
    
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:textViewCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textViewCellId];
        
        YYTextView * textView = [[YYTextView alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-30, TextViewH-10)];
        textView.placeholderText = @"请输入咨询内容，病情描述...";
        textView.delegate = self;
        textView.font = [UIFont systemFontOfSize:16];
        textView.placeholderFont = [UIFont systemFontOfSize:16];
        textView.dataDetectorTypes = UIDataDetectorTypeAll;
        [cell.contentView addSubview:textView];
        _textView = textView;
    }
    return cell;
}

- (void)insetImage{

    TZImagePickerController * pickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    [pickerVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> * photos, NSArray * assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> * infos) {
        
        UIImage * originalImage = photos.firstObject;
        UIImage * scaleImage = [UIImage imageCompressForSourceImage:originalImage targetWidth:200];
        [self appendAttachImage:scaleImage];
        // 缓存插入的图片
        [self.insertImages addObject:scaleImage];
        
    }];
    
    [self presentViewController:pickerVc animated:YES completion:nil];

}

- (void)appendAttachImage:(UIImage *)image{

    NSMutableAttributedString * attriText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];;
    
    NSMutableAttributedString * attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeBottom attachmentSize:image.size alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
    
    NSInteger index = self.textView.selectedRange.location;
    [attriText insertAttributedString:attachment atIndex:index];
    
    attriText.yy_font = [UIFont systemFontOfSize:16];
    
    self.textView.attributedText = attriText;
}

- (void)cacheRichTextWithOrderModel:(ConsultOrderModel *)model{

    // 将普通文本转可变字符串，用于插入base64图片
    
    NSMutableString * mutString = [[NSMutableString alloc] initWithString:_textView.text];
    
    // 遍历富文本拿到插入附件的位置 location
    
    NSMutableArray  * attachmentlocations = [NSMutableArray array];
    
    [_textView.attributedText enumerateAttributesInRange:NSMakeRange(0, _textView.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        if (range.length == 1) { // 注意：当length == 1，时说明遍历的是富文本字符串的附件位置，故可以精准的得到插入附件的位置index
            [attachmentlocations addObject:@(range.location)];
        }
    }];
    
    // 将图片附件转为base64字符串
    
    NSMutableArray * base64Strs  = [NSMutableArray array];
    
    for (NSInteger i = self.insertImages.count ; i >0; i--) {
        UIImage * image = self.insertImages[i-1];
        NSString * base64 = [UIImage image2DataURL:image];
        [base64Strs addObject:base64];
    }
    
    // 将转换好的base64字符串插入到对应的原附件位置
    
    for (NSInteger i = 0; i<attachmentlocations.count; i++) {
        
        NSInteger index = [attachmentlocations[i] integerValue];
        NSString * base64Str = base64Strs[i];
        
        [mutString insertString:[NSString stringWithFormat:@"<img src=\"%@\">",base64Str] atIndex:index];
        
    }
    
    // 将插好图片附件的字符串转为html标准格式
    
    NSString * html = [NSString stringWithFormat:@"<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n<meta charset=\"UTF-8\">\n<title>html</title>\n</head>\n<body>\n%@\n</body>\n</html>",mutString];
    
    [html writeToFile:@"/Users/jerry/Desktop/result.html" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}


//Base64图片 -> UIImage
+ (UIImage *) dataURL2Image: (NSString *) imgSrc
{
    NSURL *url = [NSURL URLWithString: imgSrc];
    NSData *data = [NSData dataWithContentsOfURL: url];
    UIImage *image = [UIImage imageWithData: data];
    
    return image;
}



//UIImage -> Base64图片
+ (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
+ (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}


@end
