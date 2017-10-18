//
//  WYsingleHotTagView.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYsingleHotTagView : UIView
@property(nonatomic,strong)UIImageView *backIV;
@property(nonatomic,strong)UIImageView *iconIV;
@property(nonatomic,strong)UILabel *nameLb;

-(instancetype)initWithTagName:(NSDictionary *)dic backImg:(NSString *)img;
@end
