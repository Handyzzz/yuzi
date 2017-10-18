//
//  WYphotosOfTypeTextCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/31.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYphotosOfTypeTextCell.h"

@implementation WYphotosOfTypeTextCell
-(UIImageView*)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _iconIV;
}
@end
