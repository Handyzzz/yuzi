//
//  WYLocationViewController.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYLocationViewController.h"
#import "WYCommonTableViewCell.h"
//高德地图基础SDK头文件 与key的宏
#define KeyForGaoDe @"d3d23094f663fae3e9ae26dbae992b17"
//高德地图基础SDK头文件 与key的宏
#define KeyForGaoDe @"d3d23094f663fae3e9ae26dbae992b17"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface WYLocationViewController ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) AMapPOISearchResponse *response;

@end

@implementation WYLocationViewController


-(void)initData{
    [self.view showHUDNoHide];
    [AMapServices sharedServices].apiKey = KeyForGaoDe;
    self.locationManager = [[AMapLocationManager alloc]init];
    self.locationManager.delegate = self;
    //开始定位
    [self.locationManager startUpdatingLocation];
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    // 定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    // 赋值给全局变量
    self.location = location;
    
    // 发起周边搜索
    [self searchAround];
    // 停止定位
    [self.locationManager stopUpdatingLocation];
}
/** 根据定位坐标进行周边搜索 */
- (void)searchAround{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    NSLog(@"周边搜索");
    
    //发起周边搜索
    [self.search AMapPOIAroundSearch: request];
}

// 实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if(response.pois.count == 0)
    {
        return;
    }
    self.response = response;
    [self.view hideAllHUD];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self creatTableView];
    //高德地图添加开启 HTTPS 功能
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    //高德地图的key
    [AMapServices sharedServices].apiKey = KeyForGaoDe;
    [self initData];
    
}
-(void)setNavigationBar{
    self.title = @"地点";
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView*)creatTableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionIndexColor = [UIColor blueColor];
        _tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 70.f;
        _tableView.tableHeaderView.hidden = NO;
        [_tableView registerClass:[WYCommonTableViewCell class] forCellReuseIdentifier:@"WYCommonTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma delegate and Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _response.pois.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYCommonTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"WYCommonTableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = ((AMapPOI*)_response.pois[indexPath.row]).name;
    cell.descriptionLabel.text = ((AMapPOI*)_response.pois[indexPath.row]).address;
    
    @try {
        
        if (((AMapPOI*)_response.pois[indexPath.row]).images.count > 0) {
            if (((AMapPOI*)_response.pois[indexPath.row]).images[0].url) {
                NSString *imageUrl = ((AMapPOI*)_response.pois[indexPath.row]).images[0].url;
                [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            }else{
                cell.myImageView.image = [UIImage imageNamed:@"poiImg"];
            }
        }else{
            cell.myImageView.image = [UIImage imageNamed:@"poiImg"];
        }
    } @catch (NSException *exception) {
        debugLog(@"%@",exception);
    } @finally {
        debugMethod();
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMapPOI *poi = self.response.pois[indexPath.row];
    YZAddress *address = [YZAddress new];
    address.name = poi.name;
    address.lat = @(poi.location.latitude);
    address.lng = @(poi.location.longitude);
    self.locationClick(address);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
