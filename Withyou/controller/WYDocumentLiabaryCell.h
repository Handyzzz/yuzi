//
//  WYDocumentLiabaryCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZPdf.h"

@interface WYDocumentLiabaryCell : UITableViewCell
@property(nonatomic, strong)UIView *groundView;
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel *nameLb;
@property(nonatomic, strong)UIButton *preViewBtn;
@property(nonatomic, copy)void(^preViewClick)();
-(void)setCellData:(YZPdf *)pdf;

@end
