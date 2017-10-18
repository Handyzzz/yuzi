//
//  YZMapViewController.m
//  Withyou
//
//  Created by ping on 2017/4/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZMapViewController.h"
#import <MapKit/MapKit.h>

@interface YZMapViewController ()

@end

@implementation YZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavi];
    [self setUpMapView];
    
}

-(void)setUpMapView{
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.mapType = MKMapTypeStandard;
    mapView.showsUserLocation = YES;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(self.latitude,self.longitude);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    
    
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    
    mapView.centerCoordinate = centerCoordinate;
    
    mapView.region = region;
    
    MKPointAnnotation *pointAnn = [[MKPointAnnotation alloc] init];
    pointAnn.coordinate = centerCoordinate;
    
    pointAnn.title = self.pointName;
    self.title = self.pointName;
    //显示大头针，把大头针加入到地图上
    
    [mapView addAnnotation:pointAnn];
    [self.view addSubview:mapView];
}


-(void)setUpNavi{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
