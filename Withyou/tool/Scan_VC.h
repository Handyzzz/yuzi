//
//  Scan_VC.h
//  仿支付宝
//
//  Created by 张国兵 on 15/12/9.
//  Copyright © 2015年 zhangguobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Scan_VC : UIViewController

typedef void (^QRCodeDidReceiveBlock)(NSString *result);
@property (nonatomic, copy, readonly) QRCodeDidReceiveBlock didReceiveBlock;
- (void)setDidReceiveBlock:(QRCodeDidReceiveBlock)didReceiveBlock;

@end
