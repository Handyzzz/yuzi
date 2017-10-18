//
//  WYSelectStyleCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSelectStyleCell.h"
//cell height of 70
static int cellHeight = 70;
static int verticalInset = 10;
static int textLabelHeight = 20;

@implementation WYSelectStyleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        int honrizontalInset = 10;
        int iconImageDimension = cellHeight - verticalInset * 2;
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descriptionLabel.numberOfLines = 1;
        self.descriptionLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.descriptionLabel];
        
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.myImageView.frame = CGRectMake(honrizontalInset, verticalInset, iconImageDimension, iconImageDimension);
        self.myImageView.layer.cornerRadius = 4;
        self.myImageView.clipsToBounds = YES;
        self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.myImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    self.textLabel.font = [UIFont systemFontOfSize:16.0f];
    self.textLabel.textColor = kGrayColor75;
    self.textLabel.frame = CGRectMake(cellHeight, verticalInset, kAppScreenWidth - 60 - 70, textLabelHeight);
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    
    self.descriptionLabel.frame = CGRectMake(cellHeight, verticalInset*2 + textLabelHeight, kAppScreenWidth - 60 - 30, textLabelHeight);
    self.descriptionLabel.font = kFont_12;
    
}

/*
 选择模式才会调用这个方法 系统的自带的蓝块是设计中不需要的
 系统是在这个时候 重新设置了 使用的子视图的颜色
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (!self.editing) {
        return;
    }
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        //这两个必须要写
        self.selectedBackgroundView = [UIView new];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        //用了 什么写什么
        self.textLabel.backgroundColor = [UIColor clearColor];
        //这个是自定义的也要写 不写不可以
        self.descriptionLabel.backgroundColor = [UIColor clearColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    return;
}

@end
