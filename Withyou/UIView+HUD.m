//
//  UIView+HUD.m
//  
//
//  Created by 夯大力 on 16/9/9.
//  Copyright © 2016年 Handyzzz. All rights reserved.
//


#import "UIView+HUD.h"

@implementation UIView (HUD)


-(void)addAnimation:(MBProgressHUD *)hud{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_loading"]];
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima.toValue = @(M_PI*2);
    anima.duration = 1.0f;
    //足够长 网络延时后 隐藏掉
    anima.repeatCount = 100;
    [imgView.layer addAnimation:anima forKey:nil];
    hud.customView = imgView;
    //HUD去掉别背景框的正确
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.backgroundView.color = [UIColor clearColor];
}

-(void)showHUDNoHide{
    [self hideAllHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self addAnimation:hud];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.bezelView.color = [UIColor clearColor];

}

- (void)showHUDDelayHide{
    [self hideAllHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self addAnimation:hud];

    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.bezelView.color = [UIColor clearColor];

    //转圈提示
    [hud hideAnimated:YES afterDelay:2];
}

//这个方法会杀死其他的所有的HUD
- (void)hideAllHUD{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

-(void)showMsgNOHide:(NSString *)msg{
    [self hideAllHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
}
- (void)showMsgDelayHide:(NSString *)msg{
    
    [self hideAllHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    [hud hideAnimated:YES afterDelay:2];
    
}



/*
 HUD.mode = MBProgressHUDModeIndeterminate;//菊花，默认值
 HUD.mode = MBProgressHUDModeDeterminate;//圆饼，饼状图
 HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;//进度条
 HUD.mode = MBProgressHUDModeAnnularDeterminate;//圆环作为进度条
 HUD.mode = MBProgressHUDModeCustomView; //需要设置自定义视图时候设置成这个
 HUD.mode = MBProgressHUDModeText; //只显示文本
 
 //1,设置背景框的透明度  默认0.8
 HUD.opacity = 1;
 //2,设置背景框的背景颜色和透明度， 设置背景颜色之后opacity属性的设置将会失效
 HUD.color = [UIColor redColor];
 HUD.color = [HUD.color colorWithAlphaComponent:1];
 //3,设置背景框的圆角值，默认是10
 HUD.cornerRadius = 20.0;
 //4,设置提示信息 信息颜色，字体
 HUD.labelColor = [UIColor blueColor];
 HUD.labelFont = [UIFont systemFontOfSize:13];
 HUD.labelText = @"Loading...";
 //5,设置提示信息详情 详情颜色，字体
 HUD.detailsLabelColor = [UIColor blueColor];
 HUD.detailsLabelFont = [UIFont systemFontOfSize:13];
 HUD.detailsLabelText = @"LoadingLoading...";
 //6，设置菊花颜色  只能设置菊花的颜色
 HUD.activityIndicatorColor = [UIColor blackColor];
 //7,设置一个渐变层
 HUD.dimBackground = YES;
 //8,设置动画的模式
 //    HUD.mode = MBProgressHUDModeIndeterminate;
 //9，设置提示框的相对于父视图中心点的便宜，正值 向右下偏移，负值左上
 HUD.xOffset = -80;
 HUD.yOffset = -100;
 //10，设置各个元素距离矩形边框的距离
 HUD.margin = 0;
 //11，背景框的最小大小
 HUD.minSize = CGSizeMake(50, 50);
 //12设置背景框的实际大小   readonly
 CGSize size = HUD.size;
 //13,是否强制背景框宽高相等
 HUD.square = YES;
 //14,设置显示和隐藏动画类型  有三种动画效果，如下
 //    HUD.animationType = MBProgressHUDAnimationFade; //默认类型的，渐变
 //    HUD.animationType = MBProgressHUDAnimationZoomOut; //HUD的整个view后退 然后逐渐的后退
 HUD.animationType = MBProgressHUDAnimationZoomIn; //和上一个相反，前近，最后淡化消失
 */


@end





