//
//  WYWYNetworkStatus.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/8.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYWYNetworkStatus.h"

@implementation WYWYNetworkStatus
+(void)showWrongText:(NSUInteger)status{
    if (status >= 500 && status <= 550) {
        [OMGToast showWithText:@"服务器错误，请稍后再试！"];
    }else if (status > 550){
        [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
    }
}
@end
