//
//  LocationViewController.m
//  JWChat
//
//  Created by JerryWang on 2017/5/19.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "LocationViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "WJAlertSheetView.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface LocationViewController ()<MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic,strong) MAMapView * mapView;
@property (nonatomic,strong) AMapSearchAPI * mapSearch;
@property (nonatomic,strong) MAPointAnnotation * pinView; // 大头针
@property (nonatomic,strong) UIView * addressView;
@property (nonatomic,strong) UILabel * address;
@property (nonatomic,strong) UILabel * road;
@property (nonatomic,strong) CLGeocoder * geocoder;

@property (nonatomic,strong) NSMutableArray * overlays; // 存放规划路径对象

@end

@implementation LocationViewController
#pragma mark - getter

- (NSMutableArray *)overlays{

    if (!_overlays) {
        _overlays = [NSMutableArray array];
    }
    return _overlays;
}

- (CLGeocoder *)geocoder{

    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
#pragma mark - init

- (void)loadView{
    
    [super loadView];
    
    [self initMapView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavBarItem];
    [self setupSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{

    self.navigationController.navigationBar.hidden = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleDefault;
}
- (void)dealloc{

}
- (void)configNavBarItem{
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"map_arrowBtn"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapView addSubview:back];
    
    UIButton * more = [UIButton buttonWithType:UIButtonTypeCustom];
    [more setImage:[UIImage imageNamed:@"map_moreBtn"] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapView addSubview:back];
    [self.mapView addSubview:more];
    
    // 布局
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mapView).offset(10);
        make.top.equalTo(self.mapView).offset(30);
    }];
    [more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mapView).offset(-10);
        make.top.equalTo(back);
    }];
}

- (void)initMapView{
    
    // init map
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];
    
    _mapView.showsUserLocation = YES; // 进入立即显示用户定位
    _mapView.userTrackingMode = MAUserTrackingModeFollow; // 跟踪模式 跟随
    _mapView.maxZoomLevel = 18;      // 最大缩放级别
    _mapView.delegate = self;
    _mapView.zoomLevel = 15;
    _mapView.scaleOrigin = CGPointMake(10, 70);
    _mapView.compassOrigin = CGPointMake(SCREEN_WIDTH-50, 70);
    [self.view addSubview:_mapView];
    
    // init search api
    
    _mapSearch = [[AMapSearchAPI alloc] init];
    _mapSearch.delegate = self;
    
}

- (void)setupSubviews{

    // 大头针
    _pinView = [[MAPointAnnotation alloc] init];
    _pinView.coordinate = CLLocationCoordinate2DMake(_locationBody.latitude, _locationBody.longitude);
    _pinView.title = self.locationBody.address;
    _pinView.subtitle = self.locationBody.roadName;
    [_mapView addAnnotation:_pinView];
    
    // 地址view
    _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH,80)];
    _addressView.backgroundColor = [UIColor whiteColor];
    
    // address
    _address = [[UILabel alloc] init];
    _address.textColor = [UIColor blackColor];
    _address.text = _locationBody.address;
    [_addressView addSubview:_address];
    // road
    _road = [[UILabel alloc] init];
    _road.textColor = [UIColor lightGrayColor];
    _road.font = [UIFont systemFontOfSize:12];
    _road.text = _locationBody.roadName;
    [_addressView addSubview:_road];
    // 布局
    
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressView).offset(15);
        make.right.equalTo(_addressView).offset(-100);
        make.top.equalTo(_addressView).offset(20);
    }];
    [_road mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_address);
        make.right.equalTo(_address);
        make.top.equalTo(_address.mas_bottom).offset(3);
    }];
    
    [self.view addSubview:_addressView];
    
    // location annotation
    UIButton * location = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [location setImage:[UIImage imageNamed:@"locationIcon"] forState:UIControlStateNormal];
    [location addTarget:self action:@selector(returnToUserLocation) forControlEvents:UIControlEventTouchUpInside];
    
    // roadLine btn
    UIButton * roadLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [roadLineBtn setImage:[UIImage imageNamed:@"map_roadLinBtn"] forState:UIControlStateNormal];
    [roadLineBtn addTarget:self action:@selector(roadLineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_addressView addSubview:roadLineBtn];
    
    [self.view addSubview:location];
    
    // 布局
    [location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_mapView).offset(-10);
        make.bottom.equalTo(_mapView).offset(-10);
    }];
    [roadLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_addressView).offset(-15);
        make.centerY.equalTo(_addressView);
    }];
    
}

#pragma mark - mapView delegate

- (void)mapInitComplete:(MAMapView *)mapView{
    [self gotoLocation:CLLocationCoordinate2DMake(_locationBody.latitude, _locationBody.longitude) animated:NO];// 定位到当前位置
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{

    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        
        return annotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = WJRGBAColor(177, 50, 160, 0.5);
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]]; // 设置路径纹理
        
        return polylineRenderer;
    }
    return nil;
}

#pragma mark - searchApi delegate
// 路径规划回调代理
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{

    if (response.route == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 路径规划数据解析
        
        NSMutableArray * coordinates = [NSMutableArray array];
        NSLog(@"可行路线数：%ld",response.route.paths.count);
        for (AMapPath * path in response.route.paths) { // 可行的路线数
            for (AMapStep * step in path.steps) { // 每条路线中的行驶步骤
                NSArray * polylines = [step.polyline componentsSeparatedByString:@";"];
                for (NSString * coordinateStr in polylines) {
                    NSArray * coordinateComponent = [coordinateStr componentsSeparatedByString:@","];
                    [coordinates addObject:coordinateComponent];
                }
            }
        }
        
        // 画路径折线
        
        CLLocationCoordinate2D commonPolylineCoords[coordinates.count];
        
        for (NSInteger i = 0; i<coordinates.count; i++) {
            
            NSArray * coordinateComponent = coordinates[i];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([coordinateComponent.lastObject doubleValue], [coordinateComponent.firstObject doubleValue]);
            
            commonPolylineCoords[i].latitude = coordinate.latitude;
            commonPolylineCoords[i].longitude = coordinate.longitude;
        }
        // 构造折线
        MAPolyline * commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:coordinates.count];

        [self.overlays addObject:commonPolyline];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mapView addOverlay: commonPolyline]; // 绘制折线
        });
    });
    
}

#pragma mark - actions

- (void)backBtnClick:(UIButton *)btn{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreBtnClick:(UIButton *)btn{
    
    [WJAlertSheetView showAlertSheetViewWithTips:nil items:@[@"发送给朋友",@"收藏"] completion:^(NSInteger index,UIButton *item) {
        if (index == 1) {
            NSLog(@"发送给朋友");
        }
        if (index == 2) {
            NSLog(@"收藏");
        }
    }];
}

// road line btn
- (void)roadLineBtnClick:(UIButton *)btn{
    
    NSString * showTraffic = self.mapView.isShowTraffic ? @"隐藏交通图" : @"显示交通图";
    NSString * showRoute = self.overlays.count > 0 ? @"隐藏路线" : @"显示路线";

    [WJAlertSheetView showAlertSheetViewWithTips:nil items:@[showTraffic,showRoute,@"高德地图",@"苹果地图"] completion:^(NSInteger index,UIButton *item) {
        switch (index) {
            case 1:
                self.mapView.showTraffic = !self.mapView.isShowTraffic;
                break;
            case 2:
            {    // 出发点
                
                if (self.overlays.count > 0) {
                    [_mapView removeOverlays:self.overlays];
                    [self.overlays removeAllObjects];
                    return ;
                }
                AMapGeoPoint * origin = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.coordinate.latitude
                                                                 longitude:_mapView.userLocation.coordinate.longitude];
                // 目的地
                AMapGeoPoint * destination = [AMapGeoPoint locationWithLatitude:_locationBody.latitude
                                              
                                                                      longitude:_locationBody.longitude];
            
                [WJAlertSheetView showAlertSheetViewWithTips:nil items:@[@"步行路线",@"骑行路线",@"驾车路线"] completion:^(NSInteger index, UIButton *item) {
                    switch (index) {
                        case 1:
                        {
                            AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
                            navi.origin = origin;
                            navi.destination = destination;
                            [self.mapSearch AMapWalkingRouteSearch:navi];// 发起步行路线规划
                            
                        }
                            break;
                        case 2:
                        {
                            AMapRidingRouteSearchRequest *navi = [[AMapRidingRouteSearchRequest alloc] init];
                            navi.origin = origin;
                            navi.destination = destination;
                            [self.mapSearch AMapRidingRouteSearch:navi];// 发起骑行路线规划
                            
                        }
                            break;
                        case 3:
                        {
                            AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
                            navi.origin = origin;
                            navi.destination = destination;
                            [self.mapSearch AMapDrivingRouteSearch:navi];// 发起驾车路线规划
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                }];
                
            }
                
                break;
            case 3: // 跳转高德地图
            {
                CLLocationCoordinate2D sourceCoordinate = _mapView.userLocation.coordinate;
                CLLocationCoordinate2D destinationCoordinate = CLLocationCoordinate2DMake(self.locationBody.latitude, self.locationBody.longitude);
                
                // 导航url
//                NSString * naviUrl = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=&poiid=&lat=%f&lon=%f&dev=0&style=2",@"JWChat",@"JWChat",destinationCoordinate.latitude,destinationCoordinate.longitude];
                // 路径规划url
                NSString * pathUrl = [NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%f&slon=%f&sname=&did=BGVIS2&dlat=%f&dlon=%f&dname=&dev=0&t=0",@"JWChat",sourceCoordinate.latitude,sourceCoordinate.longitude,destinationCoordinate.latitude,destinationCoordinate.longitude];
                
                NSURL *myLocationScheme = [NSURL URLWithString:pathUrl];
                
                if (![WJApplication canOpenURL:myLocationScheme]) {
                    [MBProgressHUD showLabelWithText:@"本机没有安装此应用"];
                    return;
                }
                
                if (iOS10_OR_LATER) {
                    
                    [[UIApplication sharedApplication] openURL:myLocationScheme options:@{} completionHandler:^(BOOL success) {
                        if (!success) {
                            NSLog(@"跳转高德地图失败");
                        }
                    }];
                }else{
                
                    [[UIApplication sharedApplication] openURL:myLocationScheme];
                }
            }
                
                break;
            case 4: // 跳转苹果地图
            {
                MKMapItem * currentLocation = [MKMapItem mapItemForCurrentLocation];
                MKPlacemark * placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.locationBody.latitude, self.locationBody.longitude)];
                
                MKMapItem * toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];

                BOOL success = [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking}]; // 步行模式
                if (!success) {
                    NSLog(@"打开苹果地图失败");
                }
            }
                
                break;
            default:
                break;
        }
    }];
}

// return to userLocation

- (void)returnToUserLocation{
    
    MAUserLocation * userLocation = _mapView.userLocation;  
    
    [self gotoLocation:userLocation.coordinate animated:YES];
    
}

#pragma mark - private

// 移动地图到指定坐标点
- (void)gotoLocation:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated{
    
    [_mapView setZoomLevel:15 animated:YES];
    [_mapView setCenterCoordinate:coordinate animated:animated];
}
@end
