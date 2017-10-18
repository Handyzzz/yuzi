//
//  WYEditPlaceViewController.h
//  Withyou
//
//  Created by Handyzzz on 2017/3/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//高德地图基础SDK头文件 与key的宏
#define KeyForGaoDe @"d3d23094f663fae3e9ae26dbae992b17"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface WYEditPlaceViewController : UIViewController

//搜索回调的结果
@property (nonatomic, strong) AMapPOISearchResponse *response;
@end
