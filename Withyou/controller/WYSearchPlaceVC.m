//
//  WYSearchPlaceVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/3/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSearchPlaceVC.h"
#import "WYCommonTableViewCell.h"

@interface WYSearchPlaceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WYSearchPlaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地点";
    [self setNaviBar];
    [self creatTableView];
    //高德地图添加开启 HTTPS 功能
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    //高德地图的key
    [AMapServices sharedServices].apiKey = KeyForGaoDe;

    
}
-(void)setNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)backAction{
    
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_response.pois[indexPath.row],kAMapPOIKeywordsSearchReponse, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAMapPOIKeywordsSearchReponse object:nil userInfo:dic];
    //然后回到前两个
    NSInteger index = [self.navigationController.viewControllers count] - 1;
    [self.navigationController popToViewController:self.navigationController.viewControllers[index - 2] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 ///POI
 @interface AMapPOI : AMapSearchObject
 ///POI全局唯一ID
 @property (nonatomic, copy)   NSString     *uid;
 ///名称
 @property (nonatomic, copy)   NSString     *name;
 ///兴趣点类型
 @property (nonatomic, copy)   NSString     *type;
 ///类型编码
 @property (nonatomic, copy)   NSString     *typecode;
 ///经纬度
 @property (nonatomic, copy)   AMapGeoPoint *location;
 ///地址
 @property (nonatomic, copy)   NSString     *address;
 ///电话
 @property (nonatomic, copy)   NSString     *tel;
 ///距中心点的距离，单位米。在周边搜索时有效
 @property (nonatomic, assign) NSInteger     distance;
 ///停车场类型，地上、地下、路边
 @property (nonatomic, copy)   NSString     *parkingType;
 ///商铺id
 @property (nonatomic, copy)   NSString     *shopID;
 
 ///邮编
 @property (nonatomic, copy)   NSString     *postcode;
 ///网址
 @property (nonatomic, copy)   NSString     *website;
 ///电子邮件
 @property (nonatomic, copy)   NSString     *email;
 ///省
 @property (nonatomic, copy)   NSString     *province;
 ///省编码
 @property (nonatomic, copy)   NSString     *pcode;
 ///城市名称
 @property (nonatomic, copy)   NSString     *city;
 ///城市编码
 @property (nonatomic, copy)   NSString     *citycode;
 ///区域名称
 @property (nonatomic, copy)   NSString     *district;
 ///区域编码
 @property (nonatomic, copy)   NSString     *adcode;
 ///地理格ID
 @property (nonatomic, copy)   NSString     *gridcode;
 ///入口经纬度
 @property (nonatomic, copy)   AMapGeoPoint *enterLocation;
 ///出口经纬度
 @property (nonatomic, copy)   AMapGeoPoint *exitLocation;
 ///方向
 @property (nonatomic, copy)   NSString     *direction;
 ///是否有室内地图
 @property (nonatomic, assign) BOOL          hasIndoorMap;
 ///所在商圈
 @property (nonatomic, copy)   NSString     *businessArea;
 ///室内信息
 @property (nonatomic, strong) AMapIndoorData *indoorData;
 ///子POI列表
 @property (nonatomic, strong) NSArray<AMapSubPOI *> *subPOIs;
 ///图片列表
 @property (nonatomic, strong) NSArray<AMapImage *> *images;
 
 ///扩展信息只有在ID查询时有效
 @property (nonatomic, strong) AMapPOIExtension *extensionInfo;
 @end
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
