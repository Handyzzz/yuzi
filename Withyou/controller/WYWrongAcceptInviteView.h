//
//  WYWrongAcceptInviteView.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMessage.h"
#import "WYGroupInvitation.h"

typedef enum : NSUInteger {
    WYWrongViewHaveInGroup = 1,
    WYWrongViewHaveAccept = 2,
    WYWrongViewLoseToApply = 3,
    WYWrongViewLoseToConnection = 4
} WYInviteType;

@interface WYWrongAcceptInviteView : UIView

@property (nonatomic, assign)WYInviteType type;


@property(nonatomic, strong)UIImageView *statusIV;
@property(nonatomic, strong)UILabel *msgLb;
@property(nonatomic, strong)UIImageView *goIV;
@property(nonatomic, strong)UILabel*actionLb;


@property (nonatomic, copy) void(^actionLbClick)(WYInviteType type);

-(void)setUpView:(WYInviteType)type groupInvitation:(WYGroupInvitation *)invitation;

@end
