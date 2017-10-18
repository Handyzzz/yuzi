//
//  WYPreviewPhotoListCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/26.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPreviewPhotoListCell.h"

@implementation WYPreviewPhotoListCell
//-(UIImageView *)photoIV{
//    if (_photoIV == nil) {
//           }
//    return _photoIV;
//}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _photoIV = [UIImageView new];
        _photoIV.contentMode = UIViewContentModeScaleAspectFill;
        _photoIV.clipsToBounds = YES;
        [self.contentView addSubview:_photoIV];
        [_photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPressGesture];
        
        

    }
    return self;
}
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    self.longTapClick(longPress);
}


@end
