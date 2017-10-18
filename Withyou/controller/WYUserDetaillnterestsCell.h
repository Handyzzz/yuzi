//
//  WYUserDetaillnterestsCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/5/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYUserDetail.h"
@interface WYUserDetaillnterestsCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLb;
@property (nonatomic, strong)UIButton *detailBtn;

-(void)setCellData:(NSArray *)interests :(NSIndexPath *)indexPath;
+(CGFloat)calculateCellHeight;

@end
