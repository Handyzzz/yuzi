//
//  WYInviteUserJoinGroupCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    WYInviteTypeAdd = 1,
    WYinviteTypeInvite = 2
} WYInviteType;

@interface WYInviteUserJoinGroupCell : UITableViewCell
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel *nameLb;
@property(nonatomic, strong)UILabel *relationLb;
@property(nonatomic, strong)UIButton *controlBTN;
@property (nonatomic, copy) void(^controlBlcok)(WYInviteType type);
-(void)setCellData:(WYUser *)user IsInGroup:(BOOL)isInGroup relation:(NSInteger)status;
@end
