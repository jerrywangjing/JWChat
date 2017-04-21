//
//  EditUserInfoViewController.m
//  JWChat
//
//  Created by jerry on 2017/4/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "BaseTableViewCell.h"
#import "ProfileCellModel.h"
#import <TZImagePickerController.h>
#import "NTESFileLocationHelper.h"
#import "EditInfoViewController.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,strong) NIMUser * user;

@end

@implementation UserInfoViewController

#pragma mark - getter

-(NSArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

#pragma mark - init

- (instancetype)initWithUser:(NIMUser *)user{

    if (self = [super initWithNibName:nil bundle:nil]) {
        _user = user;
        [self configData];
    }
    return self;
}

-(void)loadView {
    
    [super loadView];
    
    [self setupSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)configData{
    
    _dataSource = @[
                    @{
                        HeaderTitle : @"",
                        RowContent  : @[
                                @{
                                    ImageUrl : [ContactsManager getAvatarUrl:_user],
                                    Title : [ContactsManager getUserName:_user],
                                    SubTitle : _user.userId,
                                    @"gender" : @([ContactsManager getGender:_user]),
                                    
                                    },
                                ],
                        FooterTitle :@"",
                        
                        },
                    @{
                        HeaderTitle : @"",
                        RowContent : @[
                                        @{
                                    
                                            Title : @"昵称",
                                            SubTitle : _user.userInfo.nickName,
                                    
                                        },
                                        @{
                                            
                                            Title : @"性别",
                                            SubTitle : [self userGender:_user.userInfo.gender],
                                            
                                            },
                                        @{
                                            
                                            Title : @"生日",
                                            SubTitle : _user.userInfo.birth ? _user.userInfo.birth : @"",
                                            
                                            },
                                        @{
                                            
                                            Title : @"手机",
                                            SubTitle : _user.userInfo.mobile ? _user.userInfo.mobile : @"",
                                            
                                            },
                                        @{
                                            
                                            Title : @"邮箱",
                                            SubTitle : _user.userInfo.email ? _user.userInfo.email : @"",
                                            
                                            },
                                        @{
                                            
                                            Title : @"签名",
                                            SubTitle : _user.userInfo.sign ? _user.userInfo.sign : @"",
                                            
                                            },
                                        
                                ],
                        FooterTitle : @"",
                        
                        },
                    
                ];
    
}


- (void)setupSubviews{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = IMBgColor;
    [self.view addSubview:_tableView];
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
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
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 100;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserInfoTableViewCell * userInfoCell = [UserInfoTableViewCell userInfoCellWithTableView:tableView];
    BaseTableViewCell * baseCell = [BaseTableViewCell baseCellWithTableView:tableView];
    
    NSArray * dataArr = self.dataSource[indexPath.section][RowContent];
    
    if (indexPath.section == 0) {
        
        ProfileCellModel * model = [ProfileCellModel cellModelWithDic:dataArr.firstObject];
        userInfoCell.model = model;
        return userInfoCell;
    }
    
    if (indexPath.section == 1) {
        baseCell.model = [ProfileCellModel cellModelWithDic:dataArr[indexPath.row]];
        return baseCell;
    }
    
    return [UITableViewCell new];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 修改用户头像
        [self changeAvatar];
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self changeTextInfoWithType:EditInfoTypeNickName];
        }
        if (indexPath.row == 1) {
            [self changeTextInfoWithType:EditInfoTypeGender];
        }
        if (indexPath.row == 2) {
            [self changeTextInfoWithType:EditInfoTypeBirthday];
        }
        if (indexPath.row == 3) {
            [self changeTextInfoWithType:EditInfoTypePhoneNumber];
        }
        if (indexPath.row == 4) {
            [self changeTextInfoWithType:EditInfoTypeEmail];
        }
        if (indexPath.row == 5) {
            [self changeTextInfoWithType:EditInfoTypeSign];
        }
    }
}


#pragma mark - private 

- (NSString *)userGender:(NIMUserGender)gender{
    
    switch (gender) {
        case NIMUserGenderMale:
            return @"男";
            break;
        case NIMUserGenderFemale:
            return @"女";
            break;
        case NIMUserGenderUnknown:
            return @"其他";
            break;
        default:
            return @"未知";
            break;
    }
}

- (void)changeAvatar{

    TZImagePickerController * photoPicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    photoPicker.autoDismiss = NO;
    __weak typeof(self) weakSelf = self;
    __weak typeof(photoPicker) weakPicker = photoPicker;
    
    [photoPicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> * photos, NSArray * assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> * infos) {
        [weakPicker dismissViewControllerAnimated:NO completion:nil];
        
        TZImagePickerController * cropVc = [[TZImagePickerController alloc] initCropTypeWithAsset:assets.firstObject photo:photos.firstObject completion:^(UIImage *cropImage, id asset) {
            // 上传图片
            [weakSelf uploadImage:cropImage];
        }];
        [weakSelf presentViewController:cropVc animated:NO completion:nil];
    }];
    
    [photoPicker setImagePickerControllerDidCancelHandle:^{
        [weakPicker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:photoPicker animated:YES completion:nil];
    
}

- (void)changeTextInfoWithType:(EditInfoType)type{

    EditInfoViewController * editVc = [[EditInfoViewController alloc] init];
    editVc.user = _user;
    editVc.editType = type;
    WJWeakSelf(weakSelf);
    editVc.completion = ^{
        [weakSelf refreshTableView];
    };
    
    [self.navigationController pushViewController:editVc animated:YES];
    
}

- (void)refreshTableView{

    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[_user.userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        if (!error) {
            _user = users.firstObject;
            [self configData];
            [self.tableView reloadData];
        }
    }];
   
}

// 上传头像

- (void)uploadImage:(UIImage *)image{
//    UIImage *imageForAvatarUpload = [image imageForAvatarUpload];
    NSString *fileName = [NTESFileLocationHelper genFilenameWithExt:@"jpg"];
    NSString *filePath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];

    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    BOOL success = data && [data writeToFile:filePath atomically:YES];
    __weak typeof(self) wself = self;
    if (success) {
        [MBProgressHUD showHUD];
        [[NIMSDK sharedSDK].resourceManager upload:filePath progress:nil completion:^(NSString *urlString, NSError *error) {
            
            if (!error && wself) {
                [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagAvatar):urlString} completion:^(NSError *error) {
                    [MBProgressHUD hideHUD];
                    
                    if (!error) {
                        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:urlString]];
                        [wself refreshTableView];
                    }else{
                        [MBProgressHUD showLabelWithText:@"设置头像失败，请重试"];
                    }
                }];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showLabelWithText:@"图片上传失败，请重试"];
            }
        }];
    }else{
        [MBProgressHUD showLabelWithText:@"图片保存失败，请重试"];
    }
}
@end
