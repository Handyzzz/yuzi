//
//  WYMyAttentionTagListCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/2.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYMyAttentionTagListCell : UITableViewCell
@property(nonatomic,strong)UIImageView *iconIV;
@property(nonatomic,strong)UILabel *tagNameLb;
@property(nonatomic,strong)UILabel *updateCountLb;
@property(nonatomic,strong)UIView *line;

-(void)setCellDetai:(NSDictionary *)dic;
@end
