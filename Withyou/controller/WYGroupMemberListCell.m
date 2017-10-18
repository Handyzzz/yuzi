//
//  WYGroupMemberListCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/3/31.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupMemberListCell.h"

@implementation WYGroupMemberListCell

-(UIImageView*)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        [self.contentView addSubview:_iconIV];
        _iconIV.layer.cornerRadius = 25;
        _iconIV.clipsToBounds = YES;
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(10);
            make.width.height.equalTo(50);
        }];
    }
    return _iconIV;
}
-(UILabel *)TextLb{
    if (_TextLb == nil) {
        _TextLb = [UILabel new];
        _TextLb.textColor = [UIColor blackColor];
        _TextLb.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_TextLb];
        [_TextLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconIV);
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
        }];
    }
    return _TextLb;
}
-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.textColor = [UIColor blackColor];
        _nameLb.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconIV).equalTo(-10);
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
        }];
    }
    return _nameLb;
}
-(UILabel *)relationLb{
    if (_relationLb == nil) {
        _relationLb = [UILabel new];
        [self.contentView addSubview:_relationLb];
        _relationLb.textColor = [UIColor lightGrayColor];
        _relationLb.font = [UIFont systemFontOfSize:12];
        [_relationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconIV).equalTo(15);
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
        }];
    }
    return _relationLb;
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
        //这个是自定义的也要写 不写不可以
        self.iconIV.backgroundColor = [UIColor clearColor];
        self.TextLb.backgroundColor = [UIColor clearColor];
        self.nameLb.backgroundColor = [UIColor clearColor];
        self.relationLb.backgroundColor = [UIColor clearColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    return;
}

@end
