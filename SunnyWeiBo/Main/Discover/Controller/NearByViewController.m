//
//  NearByViewController.m
//  SunnyWeiBo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "NearByViewController.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
#import "DataService.h"
#import "WeiboModel.h"
#import "WeiboDetailViewController.h"

@interface NearByViewController ()

@end

@implementation NearByViewController
{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createViews];
    
    [self location];

}

- (void)createViews{
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //显示用户位置
    _mapView.showsUserLocation = YES;
    //地图种类 卫星  标准  混合
    _mapView.mapType = MKMapTypeStandard;
    //用户跟踪模式
    // _mapView.userTrackingMode = MKUserTrackingModeFollow;
    //代理
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}

#pragma mark - mapView 代理
//位置更新后被调用
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    
//    CLLocation *location = userLocation.location;
//    CLLocationCoordinate2D coordinate = location.coordinate;
//    
//    NSLog(@"经度 %lf 纬度 %lf",coordinate.longitude,coordinate.latitude);
//    
//    CLLocationCoordinate2D  center = coordinate;
//    
//    //数值越小 越精确
//    MKCoordinateSpan span = {0.5,0.5};
//    MKCoordinateRegion  region = {center,span};
//    
//    mapView.region = region;
//}


//标注视图被选中
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    NSLog(@"选中");
    if (![view.annotation isKindOfClass:[WeiboAnnotation class]]) {
        return;
    }
    
    
    WeiboAnnotation *weiboAnnotation = (WeiboAnnotation *)view.annotation;
    WeiboModel *weiboModel = weiboAnnotation.weiboModel;
    
    
    WeiboDetailViewController *vc = [[WeiboDetailViewController alloc] init];
    vc.weiboModel = weiboModel;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
//返回标注视图
//二 自定义标注视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    //如果是用户定位则用默认的标注视图
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //复用池，获取标注视图
    if ([annotation isKindOfClass:[WeiboAnnotation class]]) {
        WeiboAnnotationView *annotationView = (WeiboAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
        if (annotationView == nil) {
            
            annotationView = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
            
        }
        annotationView.annotation = annotation;
        return annotationView;
    }
    
    
    return nil;
    
}
//标注视图获取
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    
//    
//    //    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
//    //  处理用户当前位置
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        
//        return nil;
//    }
//    
//    
//    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
//    if (pin == nil) {
//        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
//        //颜色
//        pin.pinColor = MKPinAnnotationColorPurple;
//        //从天而降
//        pin.animatesDrop = YES;
//        //设置显示标题
//        pin.canShowCallout = YES;
//        
//        pin.rightCalloutAccessoryView = [UIButton  buttonWithType:UIButtonTypeContactAdd];
//        
//    }
//    return pin;
//    
//}

#pragma mark - 定位管理
- (void)location{
    _locationManager = [[CLLocationManager alloc] init];
    
    if (kVersion > 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.desiredAccuracy =  kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    //1 停止定位
    [_locationManager stopUpdatingLocation];
    
    //2 请求数据
    NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    [self _loadNearByData:lon lat:lat];
    
    //3 设置地图显示区域
    //    typedef struct {
    //        CLLocationDegrees latitudeDelta;
    //        CLLocationDegrees longitudeDelta;
    //    } MKCoordinateSpan;
    //
    //    typedef struct {
    //        CLLocationCoordinate2D center;
    //        MKCoordinateSpan span;
    //    } MKCoordinateRegion;
    
    
    //>>01 设置 center
    
    CLLocationCoordinate2D  center = coordinate;
    
    //>>02 设置span ,数值越小,精度越高，范围越小
    
    MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    [_mapView setRegion:region];
}

//获取附近微博
- (void)_loadNearByData:(NSString *)lon lat:(NSString *)lat{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    
    
    [DataService requestAFUrl:nearby_timeline httpMethod:@"GET" params:params data:nil block:^(id result) {
        
        NSArray *statuses = [result objectForKey:@"statuses"];
        NSMutableArray *annotationArray = [[ NSMutableArray alloc] initWithCapacity:statuses.count];
        
        
        for (NSDictionary *dataDic in statuses) {
            
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dataDic];
            
            //创建annotation
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
            annotation.weiboModel = model;
            [annotationArray addObject:annotation];
            
        }
        //把annotation 添加到mapView
        [_mapView addAnnotations:annotationArray];
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
