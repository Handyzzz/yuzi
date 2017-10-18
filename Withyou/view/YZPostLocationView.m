//
//  YZPostLocationView.m
//  Withyou
//
//  Created by ping on 2017/5/18.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostLocationView.h"

@implementation YZPostLocationView

- (UILabel *)addressLabel {
    if(_addressLabel == nil) {
        UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(25, 2, kAppScreenWidth - 30, 16)];
        address.textColor = kRGB(99, 172, 243);
        address.font = [UIFont systemFontOfSize:kPostWithWhomFont.pointSize];
        [self addSubview:address];
        self.addressLabel = address;
    }
    return _addressLabel;
}

- (UIImageView *)iconImage {
    if(_iconImage == nil) {
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"shareLocation"];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.addressLabel);
            make.right.equalTo(self.addressLabel.mas_left).equalTo(-9);
        }];
        _iconImage = icon;
    }
    return _iconImage;
}
@end
