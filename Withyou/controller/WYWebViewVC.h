//
//  WYWebViewVC.h
//  Withyou
//
//  Created by Tong Lu on 2017/1/4.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYWebViewVC : UIViewController
//如果是present过来的一定要给YES
@property(nonatomic, assign)BOOL isPresent;
//如果不指定title 就会使用解析出来的title
@property (nonatomic, copy) NSString *navigationTitle;

@property (nonatomic, copy) NSString *targetUrl;

@end
