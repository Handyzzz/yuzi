//
//  WYAddArticleVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/10/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYAddArticleVC : UIViewController
typedef void (^QRCodeDidReceiveBlock)(NSString *result);

@property (nonatomic, copy, readonly) QRCodeDidReceiveBlock didReceiveBlock;
- (void)setDidReceiveBlock:(QRCodeDidReceiveBlock)didReceiveBlock;
@end
