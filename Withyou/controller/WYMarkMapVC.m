//
//  WYMapVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/3/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//



#import "WYMarkMapVC.h"

//高德地图基础SDK头文件 与key的宏
#define KeyForGaoDe @"d3d23094f663fae3e9ae26dbae992b17"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "WYEditPlaceViewController.h"
#import "WYSearchPlaceVC.h"


@interface WYMarkMapVC ()<UISearchBarDelegate,AMapSearchDelegate,MAMapViewDelegate>
@property (nonatomic ,strong) MAMapView *mapView;
@property (nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *aMapPOIKeywordsSearchRequest;
@property (nonatomic, strong) AMapPOIAroundSearchRequest *aMapPOIAroundSearchRequest;
@property (nonatomic, strong) AMapPOISearchResponse *poiArroundResponse;

@property (nonatomic, strong) UIImageView *needleIV;
@property (nonatomic, strong) UIButton *placeBtn;
@end

@implementation WYMarkMapVC


//导航栏透明 view的高度为屏幕高度 y从屏幕头开始算的
//导航栏不透明 view的高度为屏幕高度减去导航高度 y从屏幕头往下60开始算的
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [_searchBar resignFirstResponder];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    self.title = @"地图";
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviBar];
    [self creatMapView];
    [self creatSearchBar];
    [self addneedleIV];

}

-(void)setNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatMapView{
    //高德地图添加开启 HTTPS 功能
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    //高德地图的key
    [AMapServices sharedServices].apiKey = KeyForGaoDe;
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    
    //显示定位小蓝点
    _mapView.showsUserLocation = YES;
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    /*
     ///是否自定义用户位置精度圈(userLocationAccuracyCircle)对应的 view, 默认为 NO.\n 如果为YES: 会调用 - (MAOverlayRenderer *)mapView (MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay 若返回nil, 则不加载.\n 如果为NO : 会使用默认的样式.
     @property (nonatomic) BOOL customizeUserLocationAccuracyCircleRepresentation;
     
     
     */
    //显示室内地图
    _mapView.showsIndoorMap = YES;    //YES：显示室内地图；NO：不显示；
    /*
     //设置底图种类为卫星图
     [_mapView setMapType:MAMapTypeSatellite];
     //设置底图种类为夜景图
     [_mapView setMapType:MAMapTypeStandardNight];
     //设置路况图层
     _mapView.showTraffic = YES;
     
     */
    
    //单击地图使用该回调获取POI信息
    _mapView.touchPOIEnabled = YES;
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 50); //设置指南针位置
    _mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 50);  //设置比例尺位置
    //设置缩放级别
    _mapView.zoomLevel = 15;
    _mapView.delegate = self;
    
    /*
     //添加一个小按钮清除所有的大头针
     UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [clearBtn setBackgroundImage:[UIImage imageNamed:@"broom"] forState:UIControlStateNormal];
     [_mapView addSubview:clearBtn];
     [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(10);
     make.top.equalTo(80);
     make.width.height.equalTo(30);
     }];
     [clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];

     */
    //添加一个回到自己位置的button
    UIButton *backLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backLocationBtn setBackgroundImage:[UIImage imageNamed:@"backLocation"] forState:UIControlStateNormal];
    [_mapView addSubview:backLocationBtn];
    [backLocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-50);
        make.bottom.equalTo(-50);
        make.width.height.equalTo(30);
    }];
    [backLocationBtn addTarget:self action:@selector(backLocationBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

//在地图加载完成 或者地图定位完成后设置都没有用
//在地图初始化完成后可以做关于坐标计算的(经纬度)
/**
 * @brief 地图初始化完成（在此之后，可以进行坐标计算）
 * @param mapView 地图View
 */
- (void)mapInitComplete:(MAMapView *)mapView{
    [self backLocationBtnClick];
}

//取消定位处周围蓝色区域
- (MAOverlayRenderer *)mapView :(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
    return nil;
}

//添加一个图片在屏幕中心 大头针图片的底部中心(针尖位置) 放在地图中心
-(void)addneedleIV{
    if (!_needleIV) {
        _needleIV = [UIImageView new];
        [_needleIV setImage:[UIImage imageNamed:@"needleIV"]];
        [self.mapView addSubview:_needleIV];
        [_needleIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mapView.mas_centerY);
            make.centerX.equalTo(self.mapView.mas_centerX);
            make.width.height.equalTo(50);
        }];
    }
}
//在停止移动的时候 添加一个按钮用来显示当前地名
-(void)addPlaceBtn{
    
    if (_placeBtn == nil) {
        _placeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _placeBtn.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        [_placeBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        _placeBtn.layer.cornerRadius = 5;
        _placeBtn.clipsToBounds = YES;
        _placeBtn.tintColor = [UIColor clearColor];
        [_placeBtn addTarget:self action:@selector(PlacrBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.mapView addSubview:_placeBtn];
        [_placeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.needleIV.mas_centerX);
            make.bottom.equalTo(self.needleIV.mas_top);
            make.height.equalTo(30);
        }];
    }
    //这个停止移动的api可能不是很准 所以这样判断一下
    if (_placeBtn.superview != _mapView) {
        [_mapView addSubview:_placeBtn];
        [_placeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.needleIV.mas_centerX);
            make.bottom.equalTo(self.needleIV.mas_top);
            make.height.equalTo(30);
        }];
    }

}

//点击大头针的上边的按钮
-(void)PlacrBtnClick{
    WYEditPlaceViewController *vc = [WYEditPlaceViewController new];
    vc.response = _poiArroundResponse;
    [self.navigationController pushViewController:vc animated:YES];

}
//返回到用户的位置
-(void)backLocationBtnClick{
    //do something
    //设置地图的中心点为用户的位置
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];

}
//用户将移动地图
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction{
    
    if (!wasUserAction) return;
    //将按钮移除
    [_placeBtn removeFromSuperview];
}
//用户停止移动地图
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    if (!wasUserAction) return;

    //获取地图中心的经纬度
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    //创建搜索
    /*
     ///POI周边搜索
     @interface AMapPOIAroundSearchRequest : AMapPOISearchBaseRequest
     ///查询关键字，多个关键字用“|”分割
     @property (nonatomic, copy)   NSString     *keywords;
     ///中心点坐标
     @property (nonatomic, copy)   AMapGeoPoint *location;
     ///查询半径，范围：0-50000，单位：米 [default = 3000]
     @property (nonatomic, assign) NSInteger     radius;
     @end
     */
    _aMapPOIAroundSearchRequest = [[AMapPOIAroundSearchRequest alloc]init];
    _aMapPOIAroundSearchRequest.location = [AMapGeoPoint locationWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    // 发起搜索
    [self.search AMapPOIAroundSearch:_aMapPOIAroundSearchRequest];
    //加回来之前把title去掉 要不会出现之前的title 然后又回调后才改为新的title
    [_placeBtn setTitle:@"..." forState:UIControlStateNormal];
    [self addPlaceBtn];

}

/*
 //地图区域改变 (可能不是用户移动的)
 - (void)mapViewRegionChanged:(MAMapView *)mapView;
 //地图区域即将改变(可能不是用户移动的)
 - (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated;
 //地图区域已经移动的代理方法(可能不是用户移动的)
 - (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

 */

//清除所有的大头针 会把定位点也清除 我们修改了定位点自定义annotation权限
-(void)clearClick{
    [_mapView removeAnnotations:_mapView.annotations];
}

//搜索框
-(void)creatSearchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.placeholder = @"请输入地点";
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.delegate = self;
        _searchBar.tintColor = [UIColor clearColor];
        _searchBar.backgroundColor = [UIColor clearColor];
        
        //去除搜索条 让它成为灰色
        //searchField.borderStyle = UITextBorderStyleNone;
        //searchField.background = [UIImage imageNamed:@"ic_top"];
        //searchField.layer.cornerRadius = 4.0;
        //searchField.leftViewMode=UITextFieldViewModeNever;
        //searchField.textColor=[UIColor whiteColor];
        
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        //改变placeholder的颜色
        [searchField setValue:[UIColor whiteColor]forKeyPath:@"_placeholderLabel.textColor"];
        [self.mapView addSubview:_searchBar];
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(0);
            make.height.equalTo(50);
        }];
    }
}

//搜索对象AMapSearchAPI
-(AMapSearchAPI *)search{
    if (_search == nil) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}


//搜索框开始编辑的时候
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    //创建搜索
    _aMapPOIKeywordsSearchRequest = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    _aMapPOIKeywordsSearchRequest.keywords            = searchText;
    //_request.city                = @"北京";
    //_request.types               = @"高等院校";
    _aMapPOIKeywordsSearchRequest.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    _aMapPOIKeywordsSearchRequest.cityLimit           = YES;
    _aMapPOIKeywordsSearchRequest.requireSubPOIs      = YES;
}


//用户开始点击键盘上的搜索按钮的时候
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //点击搜索按钮的时候 发起搜索
    [self.search AMapPOIKeywordsSearch:_aMapPOIKeywordsSearchRequest];
    
}

//POI 搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    //设置数据
    if (response.pois.count == 0)
    {
        [_placeBtn setTitle:@"  给我取个名字吧!    " forState:UIControlStateNormal];
        return;
    }
    
    
    //如果是键盘搜索的请求
    if ([request isMemberOfClass:[AMapPOIKeywordsSearchRequest class]]) {
        //回调将response 传到下一个vc  回调的时候判读一下是从label来的
        WYSearchPlaceVC *vc = [WYSearchPlaceVC new];
        vc.response = response;
        [self.navigationController pushViewController:vc animated:YES];

    }
    //如果是中心指针停下后的请求
    if ([request isMemberOfClass:[AMapPOIAroundSearchRequest class]]) {
        _poiArroundResponse = response;
        if (((AMapPOI*)_poiArroundResponse.pois[0]).name.length > 1) {
            NSString *title = [NSString stringWithFormat:@" %@附近  ",((AMapPOI*)_poiArroundResponse.pois[0]).name];
            [_placeBtn setTitle:title forState:UIControlStateNormal];
        }else{
            [_placeBtn setTitle:@"  给我取个名字吧!    " forState:UIControlStateNormal];
        }
    }
    
}

//这个地点是推荐的地点
//点击某个地点的时候 获取该位置的poi
//* @param pois 获取到的poi数组(由MATouchPoi组成)

- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois{
    
    //NSLog(@"++++++++++++++++++%ld",pois.count);
    if (pois.count > 0) {
        for (MATouchPoi *poi in pois) {
            //给标记获取到的点poi 添加标注数据对象
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            //经纬度@property (nonatomic, copy)   AMapGeoPoint *location;
            ///纬度（垂直方向）@property (nonatomic, assign) CGFloat latitude;
            ///经度（水平方向）@property (nonatomic, assign) CGFloat longitude;
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(poi.coordinate.latitude, poi.coordinate.longitude);
            //设置名字
                pointAnnotation.title = poi.name;
                [_mapView addAnnotation:pointAnnotation];
        }

    }
}

//添加标注对象后 回调的设置MAPinAnnotationView的方法   
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        //将点击的对象 加入到markersArr
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
/**
 * @brief 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param view 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    
}

//收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
