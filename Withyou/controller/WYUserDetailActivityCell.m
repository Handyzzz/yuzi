
//
//  WYUserDetailActivityCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserDetailActivityCell.h"
#define imageWidth ((kAppScreenWidth - 5 - 15*2)/2)
#define imageHeight ((imageWidth * 11)/17)

@implementation WYUserDetailActivityCell

-(UIView *)groundView{
    if (_groundView == nil) {
        _groundView = [UIView new];
        _groundView.backgroundColor = UIColorFromHex(0xfbfbfb);
        _groundView.layer.borderWidth = 0.5;
        _groundView.layer.borderColor = UIColorFromHex(0xdfdfdf).CGColor;
        [self.contentView addSubview:_groundView];
        [_groundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.bottom.equalTo(0);
            make.height.equalTo(imageHeight);
        }];
    }
    return _groundView;
}

-(UIImageView *)IV{
    if (_IV == nil) {
        _IV = [UIImageView new];
        [self.groundView addSubview:_IV];
        [_IV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(0);
            make.width.equalTo(imageWidth);
            make.bottom.equalTo(0);
        }];
    }
    return _IV;
}

-(UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textColor = UIColorFromHex(0x333333);
        [self.groundView addSubview:_titleLb];
        _titleLb.numberOfLines = 2;
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.left.equalTo(self.IV.mas_right).equalTo(15);
            make.right.equalTo(-20);
        }];
    }
    return _titleLb;
}

-(UILabel *)locationLb{
    if (_locationLb == nil) {
        _locationLb = [UILabel new];
        _locationLb.font = [UIFont systemFontOfSize:12];
        _locationLb.textColor = UIColorFromHex(0x999999);
        [self.groundView addSubview:_locationLb];
        _locationLb.numberOfLines = 1;
        [_locationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.IV.mas_right).equalTo(15);
            make.bottom.equalTo(self.timeLb.mas_top).equalTo(-8);
            make.right.equalTo(-20);
        }];
    }
    return _locationLb;
}

-(UILabel *)timeLb{
    if (_timeLb == nil) {
        _timeLb = [UILabel new];
        _timeLb.font = [UIFont systemFontOfSize:12];
        _timeLb.textColor = UIColorFromHex(0x999999);
        [self.groundView addSubview:_timeLb];
        _timeLb.numberOfLines = 1;
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.IV.mas_right).equalTo(15);
            make.bottom.equalTo(-15);
            make.right.equalTo(-20);
        }];
    }
    return _timeLb;
}


-(void)setCellData:(NSArray *)eventsArr :(NSIndexPath *)indexPath{
    
    WYEvent *event = eventsArr[indexPath.row];
    
    self.IV.image = [UIImage imageNamed:@"userDetailbook"];
    self.titleLb.text = @"草间弥生上海展览的的的的的的的的的的";
    self.locationLb.text = @"上海静安寺";
    self.timeLb.text = @"2017.05-20";
}
+(CGFloat)calculateCellHeight:(WYUserDetail*)userInfo :(NSIndexPath *)indexPath{
    CGFloat sumHeight = 0.0;
    if (indexPath.row == 0) {
        sumHeight = 15 + imageHeight;
    }else{
        sumHeight = 8 + imageHeight;
    }
    return sumHeight;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
