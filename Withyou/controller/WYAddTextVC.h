//
//  WYAddTextVC.h
//  Withyou
//
//  Created by Tong Lu on 7/31/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYAddTextVC : UIViewController
//文本回传
@property (nonatomic, copy) void(^myBlock)(NSString *text);
//导航栏标题
@property (strong, nonatomic) NSString *navigationTitle;
//默认文字
@property (nonatomic, strong) NSString *placeHolderText;
//已有文字
@property (nonatomic, strong) NSString *defaultText;


//位置
@property (nonatomic ,assign)CGFloat top;
@property (nonatomic ,assign)CGFloat left;
@property (nonatomic ,assign)CGFloat right;
@property (nonatomic ,assign)CGFloat height;


//字体与颜色
@property (nonatomic, strong)UIFont *font;
@property (nonatomic, strong)UIColor *color;


@end
