//
//  WYDiscovers.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYDiscovers.h"
#import "WYDisCoversCell.h"
#import "WYHotTagAndPostVC.h"
#import "WYDescoverSearchVC.h"
#import "WYUserVC.h"
#import "WYSelfSettingsVC.h"
#import "Scan_VC.h"
#import "WYGroupListVC.h"
#import "WYSelfFriendListsVC.h"
#import "WYMyQRcodeViewController.h"
#import "WYRecommendArticleVC.h"
#import "WYSelfVC.h"

#define imgkey @"imageName"
#define titlekey @"titleName"
#define actionkey @"actionName"

@interface WYDiscovers ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSArray *dataSource;
@end

@implementation WYDiscovers

-(void)initData{
    
    _dataSource = @[
             @[@{
                   imgkey: @"discover_read",
                   titlekey: @"阅读",
                   actionkey: @"readAction"
                   }],
             @[@{
                   imgkey: @"discover_group",
                   titlekey: @"群组",
                   actionkey: @"groupAction"
                   }],
             @[@{
                   imgkey: @"discover_search",
                   titlekey: @"查找好友",
                   actionkey: @"addFriendsAction"
                   },
               @{
                   imgkey: @"discover_scan",
                   titlekey: @"扫一扫",
                   actionkey: @"scanAction"
                   }],
             @[@{
                   imgkey: @"discover_me",
                   titlekey: @"我",
                   actionkey: @"mySelfAction"
                   }]
            ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUpTableView];
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[WYDisCoversCell class] forCellReuseIdentifier:@"WYDisCoversCell"];
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == _dataSource.count - 1) {
        return 12.f;
    }
    return 0.001f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 12)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 12)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYDisCoversCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYDisCoversCell"];
    NSDictionary *dic = _dataSource[indexPath.section][indexPath.row];
    cell.iconIV.image = [UIImage imageNamed:[dic objectForKey:imgkey]];
    cell.titleLb.text = [dic objectForKey:titlekey];
    
    UIView *view = [cell.contentView viewWithTag:1001];
    UIImageView *img = [cell.contentView viewWithTag:1002];

    if (!(indexPath.section == 2 && indexPath.row == 2)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (view) [view removeFromSuperview];
        if (img) [img removeFromSuperview];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (view == nil) {
            view = [[UIView alloc]initWithFrame:CGRectMake(kAppScreenWidth - 80, 0, 80, 52)];
            [cell.contentView addSubview:view];
            view.tag = 1001;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myQRCodes)];
            [view addGestureRecognizer:tap];
        }
        
        if (img == nil) {
            //52的cell高度 自身20 16居中
            img = [[UIImageView alloc]initWithFrame:CGRectMake(kAppScreenWidth - 50, 16, 20, 20)];
            [cell.contentView addSubview:img];
            img.image = [UIImage imageNamed:@"qrCodes"];
            img.tag = 1002;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _dataSource[indexPath.section][indexPath.row];
    NSString *action = [dic objectForKey:actionkey];
    if ([self respondsToSelector:NSSelectorFromString(action)]) {
        [self performSelector:NSSelectorFromString(action)];
    }
}

//阅读
-(void)readAction{
    WYRecommendArticleVC *vc = [WYRecommendArticleVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//热门标签
-(void)hotTagAction{
    WYHotTagAndPostVC *vc = [WYHotTagAndPostVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

//查找朋友
- (void)addFriendsAction
{
    WYDescoverSearchVC *vc = [WYDescoverSearchVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//扫码
- (void)scanAction
{
    Scan_VC *vc = [[Scan_VC alloc] init];
    [vc setDidReceiveBlock:^(NSString *result) {
        [self handleScannedResult:result];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//我的二维码
-(void)myQRCodes{
    
    WYMyQRcodeViewController *vc = [[WYMyQRcodeViewController alloc] init];
    vc.navigationTitle = @"我的二维码";
    vc.hidesBottomBarWhenPushed = YES;
    vc.targetUrl = [NSString stringWithFormat:@"%@/add/u/%@", kBaseURL, kLocalSelf.account_name];
    [self.navigationController pushViewController:vc animated:YES];
}

//群组列表
- (void)groupAction{
    WYGroupListVC *vcGroup = [[WYGroupListVC alloc] init];
    [self.navigationController pushViewController:vcGroup animated:YES];
}

//我
- (void)mySelfAction{
    WYSelfVC *vc = [[WYSelfVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (void)handleScannedResult:(NSString *)result{
    
    if([self handleLocalLoginTest:result])
        return;
    
    if([result hasPrefix:[kBaseURL stringByAppendingString:@"/api/v1/qrweb_login/"]])
    {
        NSURL *url = [NSURL URLWithString:result];
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        NSArray *queryItems = [components queryItems];
        NSString *uuid;
        for (NSURLQueryItem *item in queryItems)
        {
            if([item.name isEqualToString:@"uuid"]){
                uuid = item.value;
                break;
            }
        }
        
        if(!uuid){
            return;
        }
        else{
            debugLog(@"web login uuid is %@", uuid);
            [[[UIAlertView alloc] initWithTitle:@"是否登录与子网页版"
                                        message:@"请选择下一步的操作"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^(){
                return;
            }]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^(){
                [self requestUrlWithUuid:uuid];
            }],
              nil] show];
        }
    }else if([result hasPrefix:[NSString stringWithFormat:@"%@/add/u/",kBaseURL]]) {
        debugLog(@"add u");
        [WYUtility handleAddFriendQrcodeUrl:[result escapedURL]];
    }
    else if([result hasPrefix:[NSString stringWithFormat:@"%@/add/g/",kBaseURL]]){
        //加入群组的操作
        debugLog(@"add g");
        [WYUtility handleAddGroupQrcodeUrl:[result escapedURL]];
    }
    else{
        [WYUtility openURL:[result escapedURL]];
    }
}

- (void)requestUrlWithUuid:(NSString *)uuid
{
    NSString *s = [NSString stringWithFormat:@"%@/%@%@", kBaseURL, kApiVersion, kqrCodeScanAddress];
    [[WYHttpClient sharedClient] GET:s parameters:@{@"uuid": uuid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WYUtility showAlertWithTitle:@"登录请求已成功发送"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WYUtility showAlertWithTitle:@"请求未成功，请刷新二维码再试一次"];
    }];
}

- (BOOL)handleLocalLoginTest:(NSString *)result
{
    NSString *localBaseURL = @"http://192.168.3.21:8000";
    //    debugLog(@"local result %@", result);
    if([result hasPrefix:[localBaseURL stringByAppendingString:@"/api/v1/qrweb_login/"]])
    {
        debugLog(@"inside");
        NSURL *url = [NSURL URLWithString:result];
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        NSArray *queryItems = [components queryItems];
        NSString *uuid;
        for (NSURLQueryItem *item in queryItems)
        {
            if([item.name isEqualToString:@"uuid"]){
                uuid = item.value;
                break;
            }
        }
        
        if(!uuid){
            [WYUtility showAlertWithTitle:@"no uuid found"];
        }
        else{
            debugLog(@"uuid is %@", uuid);
            [[[UIAlertView alloc] initWithTitle:@"是否登录与子网页版本地测试？"
                                        message:@"请选择下一步的操作"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^(){
                return;
            }]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^(){
                
                NSString *s = [NSString stringWithFormat:@"%@/%@%@", localBaseURL, kApiVersion, kqrCodeScanAddress];
                debugLog(@"api kkk %@", s);
                [[WYHttpClient sharedClient] GET:s parameters:@{@"uuid": uuid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [WYUtility showAlertWithTitle:@"登录请求已成功发送"];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [WYUtility showAlertWithTitle:@"请求未成功，请刷新二维码再试一次"];
                }];
                
            }],
              nil] show];
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
