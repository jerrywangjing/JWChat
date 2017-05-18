//
//  MapViewController.m
//  JWChat
//
//  Created by JerryWang on 2017/5/15.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "MapViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface MapViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) MAMapView * mapView;
@property (nonatomic,strong) AMapSearchAPI * mapSearch;
@property (nonatomic,strong) MAPointAnnotation * centerPin; // 中心大头针

@property (nonatomic,weak) UITableView * locationsView; // 显示当前及周边位置信息
@property (nonatomic,strong) NSMutableArray * locations; // 地理位置对象

@property (nonatomic,strong) AMapReGeocode * reGeocode; // 当前反地理编码对象
@property (nonatomic,getter=isAllowUpdateLocation) BOOL allowUpdateLocation; // 允许更新位置信息
@property (nonatomic,weak) UIActivityIndicatorView *indicator;
@property (nonatomic,assign) NSInteger selectedRow; // 记录选中的行（防止cell重用）

@end

@implementation MapViewController

#pragma mark - getter

- (NSMutableArray *)locations{

    if (!_locations) {
        _locations = [NSMutableArray array];
    }
    return _locations;
}

#pragma mark - init

- (void)loadView{

    [super loadView];
    
    [self initMapView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _allowUpdateLocation = YES;
    self.selectedRow = 0; // 默认选中第0行
    
    [self configNavBarItem];
    [self setupSubviews];
    
    
}

- (void)dealloc{

    [_mapView clearDisk];
}
- (void)configNavBarItem{

    self.navigationItem.title = @"位置";
    
    // cancel item
    
    UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick:)];
    // send item
    
    UIBarButtonItem * send =[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendBtnClick:)];
    send.tintColor = [UIColor greenColor];
    
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = send;
    
}

- (void)initMapView{

    // init map
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NavBarH, SCREEN_WIDTH, (SCREEN_HEIGHT - NavBarH)/2)];
    
    _mapView.showsUserLocation = YES; // 进入立即显示用户定位
    _mapView.userTrackingMode = MAUserTrackingModeFollow; // 跟踪模式 跟随
    _mapView.maxZoomLevel = 18;      // 最大缩放级别
    //mapView.showTraffic = YES;      // 交通地图
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    [self.view addSubview:_mapView];
    
    // init search api
    
    _mapSearch = [[AMapSearchAPI alloc] init];
    _mapSearch.delegate = self;
    
}

- (void)setupSubviews{

    // location annotation
    UIButton * location = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [location setImage:[UIImage imageNamed:@"locationIcon"] forState:UIControlStateNormal];
    [location addTarget:self action:@selector(returnToUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:location];
    // 布局
    [location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mapView).offset(10);
        make.bottom.equalTo(_mapView).offset(-20);
        
    }];
    
    // moved annotation (可移动标注点)
    
    _centerPin = [[MAPointAnnotation alloc] init];
    _centerPin.lockedScreenPoint = CGPointMake(SCREEN_WIDTH/2, _mapView.height/2);
    _centerPin.lockedToScreen = YES;
    
    [_mapView addAnnotation:_centerPin];
    
    // location tableView
    
    UITableView * locationView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-(NavBarH+CGRectGetHeight(_mapView.frame))) style:UITableViewStylePlain];
    _locationsView = locationView;
    _locationsView.dataSource = self;
    _locationsView.delegate = self;
    _locationsView.backgroundColor = [UIColor whiteColor];
    _locationsView.tableFooterView = [UIView new];
    
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator = indicator;
    [_indicator startAnimating];
    
    [_locationsView addSubview:indicator];
    
    [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_locationsView);
        make.top.mas_equalTo(15);
    }];
    
    [self.view addSubview:_locationsView];
    
}

#pragma mark - actions

- (void)sendBtnClick:(UIButton *)btn{
    
    CGRect rect = CGRectMake((_mapView.width-200)/2, (_mapView.height-100)/2, 200, 100);
    
    WJWeakSelf(weakSelf);
    
    [_mapView takeSnapshotInRect:rect withCompletionBlock:^(UIImage *resultImage, CGRect rect) {
        
        UIImage * image = resultImage;
        
        NSString * address = nil;
        NSString * roadName = nil;
        AMapGeoPoint * geoPoint = nil;
        
        if (weakSelf.selectedRow == 0) {
            address = _reGeocode.formattedAddress;
            roadName = address;
            geoPoint = [AMapGeoPoint locationWithLatitude:_centerPin.coordinate.latitude longitude:_centerPin.coordinate.longitude];
        }else{
            AMapPOI * poi = _reGeocode.pois[weakSelf.selectedRow-1];
            address = poi.name;
            roadName = poi.address;
            geoPoint = poi.location;
        }
        
        // 回调发送一个地理位置消息
        
        if (weakSelf.completion) {
            
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                weakSelf.completion(image, address, roadName, geoPoint);
            }];
            
        }
    }];
}
- (void)cancelBtnClick:(UIButton *)btn{

    [self dismissViewControllerAnimated:YES completion:nil];
}

// return to userLocation

- (void)returnToUserLocation{

    _allowUpdateLocation = YES;
    
    MAUserLocation * userLocation = _mapView.userLocation;
    
    [self gotoLocation:userLocation.coordinate];
    
}

#pragma mark - mapView delegate

- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView{
    // 即将启动定位
}

- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView{

}
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction{

}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    
    if (wasUserAction) {
        if (!self.isAllowUpdateLocation) {
            self.allowUpdateLocation = YES;
        }
    }
    
    // 更新当前位置信息
    if (self.isAllowUpdateLocation) {
        AMapReGeocodeSearchRequest * recodeRequest = [[AMapReGeocodeSearchRequest alloc] init];
        recodeRequest.location = [AMapGeoPoint locationWithLatitude:_centerPin.coordinate.latitude longitude:_centerPin.coordinate.longitude];
        recodeRequest.requireExtension = YES; // 返回扩展信息
        
        [_mapSearch AMapReGoecodeSearch:recodeRequest]; // 发起地理编码查询
    }
   
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    // 用户位置或设备方向变化后的回调
    
}

#pragma mark - searchAPI delegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{

    NSLog(@"查询失败：%@",error.localizedDescription);
}

// 反地理编码查询
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{

    _reGeocode = response.regeocode;
    [_indicator stopAnimating];
    self.selectedRow = 0; // 重新加载地址列表后，恢复选中为0
    [self.locationsView reloadData];
}

// 地理编码查询
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{

}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _reGeocode.pois.count + 1; // 加1是为了显示当前位置信息
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellId = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
        // arrow view
        UIImageView * arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_nor"]];
        cell.accessoryView = arrow;
        cell.accessoryView.hidden = YES;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = _reGeocode.formattedAddress;
        cell.detailTextLabel.text = nil;
        cell.accessoryView.hidden = indexPath.row == self.selectedRow ? NO :YES;
        return cell;
    }
    
    AMapPOI * poi = _reGeocode.pois[indexPath.row-1];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryView.hidden = indexPath.row == self.selectedRow ? NO :YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.selectedRow = indexPath.row;
    [tableView reloadData];
    
    // 更新地图数据
    
    _allowUpdateLocation = NO;
    
    if (indexPath.row == 0) {
        [self gotoLocation:_centerPin.coordinate];
    }else{
    
        AMapPOI * poi = _reGeocode.pois[indexPath.row-1];
        [self gotoLocation:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude)];
        
    }
}

#pragma mark - private

// 移动地图到指定坐标点
- (void)gotoLocation:(CLLocationCoordinate2D)coordinate{

    [_mapView setZoomLevel:15 animated:YES];
    [_mapView setCenterCoordinate:coordinate animated:YES];
}
@end
