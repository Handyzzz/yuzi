//
//  WYPdfListCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPdfListCell : UITableViewCell
@property(nonatomic, strong)UIView *groundView;
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel *nameLb;
-(void)setCellData:(YZPdf *)pdf;
@end
