//
//  WYHandleApplicationView.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroupApplication.h"
typedef enum : NSUInteger {
    WYWrongViewApplicationHaveExpired = 1,
    WYWrongViewApplicationHaveRefused = 2,
    WYWrongViewApplicationHaveAccept = 3,
    WYWrongViewApplicationMeNotInGroup = 4
    
} WYApplicationType;

@interface WYHandleApplicationView : UIView
@property(nonatomic, strong)UIImageView *statusIV;
@property(nonatomic, strong)UILabel *msgLb;
@property(nonatomic, strong)UIView *lineView;

-(void)setUpView:(WYApplicationType)type;

@end
