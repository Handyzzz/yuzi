//
//  WYPlaceholderView.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/16.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPlaceholderView : UIView
-(instancetype)initWithImage:(NSString*)imageName msg:(NSString*)msg imgW:(CGFloat)imgW imgH:(CGFloat)imgH;
@property(nonatomic,strong)UIImageView *iconIV;
@property(nonatomic,strong)UILabel *msgLb;
@end
