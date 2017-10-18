//
//  WYUserChangeIconView.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYUserChangeIconView : UIView
@property(nonatomic,strong)UIImageView *iconIV;
@property(nonatomic,strong)UIButton *cameraBtn;
@property(nonatomic,strong)UIButton *albumBtn;
@property (nonatomic, copy) void(^cameraClick)();
@property (nonatomic, copy) void(^albumClick)();
@end
