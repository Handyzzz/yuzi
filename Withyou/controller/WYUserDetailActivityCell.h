//
//  WYUserDetailActivityCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/5/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYUserDetail.h"

@interface WYUserDetailActivityCell : UITableViewCell
@property (nonatomic, strong)UIView *groundView;
@property (nonatomic, strong)UIImageView *IV;
@property (nonatomic, strong)UILabel *titleLb;
@property (nonatomic, strong)UILabel *locationLb;
@property (nonatomic, strong)UILabel *timeLb;


+(CGFloat)calculateCellHeight:(WYUserDetail*)userInfo :(NSIndexPath *)indexPath;
-(void)setCellData:(NSArray *)eventsArr :(NSIndexPath *)indexPath;

@end
