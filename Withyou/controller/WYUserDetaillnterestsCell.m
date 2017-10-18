
//
//  WYUserDetaillnterestsCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserDetaillnterestsCell.h"
#define imageWidth ((kAppScreenWidth - 5 - 15*2)/2)

@implementation WYUserDetaillnterestsCell
-(UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(13);
        }];
    }
    return _titleLb;
}

-(void)setCellData:(NSArray *)interests :(NSIndexPath *)indexPath{
    NSArray *titleArr = @[@"书",@"影",@"音"];
    NSUInteger sum = 0;
    for (int i = 0; i < interests.count; i ++) {
        
        if ([interests[i] count] > 0) {
            if ([interests[i][0] isKindOfClass:[WYBook class]]) {
                //书 可以先确定 不用写到循环中设置
                self.titleLb.text = @"书";
                //[interests[j] count] 但是最多放两个
                
                sum = [interests[i] count] > 2 ? [interests[i] count] : 2;
                for (int j = 0; j < 2 && j< sum; j ++) {
                    UIImageView *imgIV = [UIImageView new];
                    if (i == 0) {
                        [imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(15);
                            make.top.equalTo(self.titleLb.mas_bottom).equalTo(13);
                            make.bottom.equalTo(0);
                            make.height.equalTo(120);
                            make.width.equalTo(imageWidth);
                        }];
                    }else{
                        [imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.titleLb.mas_bottom).equalTo(13);
                            make.bottom.equalTo(0);
                            make.right.equalTo(-15);
                            make.height.equalTo(120);
                            make.width.equalTo(imageWidth);
                        }];
                    }
                    //设置内容

                }
            }else if ([interests[i][0] isKindOfClass:[WYMovie class]]){
                //影 可以先确定 不用写到循环中设置
                self.titleLb.text = @"影";
                //[interests[j] count] 但是最多放两个
                sum = [interests[i] count] > 2 ? [interests[i] count] : 2;
                for (int j = 0; j < 2 && j< sum; j ++) {
                    UIImageView *imgIV = [UIImageView new];
                    if (i == 0) {
                        [imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(15);
                            make.top.equalTo(self.titleLb.mas_bottom).equalTo(13);
                            make.bottom.equalTo(0);
                            make.height.equalTo(120);
                            make.width.equalTo(imageWidth);
                        }];
                    }else{
                        [imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.titleLb.mas_bottom).equalTo(13);
                            make.bottom.equalTo(0);
                            make.right.equalTo(-15);
                            make.height.equalTo(120);
                            make.width.equalTo(imageWidth);
                        }];
                    }
                    //设置内容
                    
                    
                }
            }else if ([interests[i][0] isKindOfClass:[WYMusic class]]){
                //音 可以先确定 不用写到循环中设置
                self.titleLb.text = @"音";
                //[interests[j] count] 但是最多放两个
                sum = [interests[i] count] > 2 ? [interests[i] count] : 2;
                for (int j = 0; j < 2 && sum; j ++) {
                    UIImageView *imgIV = [UIImageView new];
                    if (i == 0) {
                        [imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(15);
                            make.top.equalTo(self.titleLb.mas_bottom).equalTo(13);
                            make.bottom.equalTo(0);
                            make.height.equalTo(120);
                            make.width.equalTo(imageWidth);
                        }];
                    }else{
                        [imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.titleLb.mas_bottom).equalTo(13);
                            make.bottom.equalTo(0);
                            make.right.equalTo(-15);
                            make.height.equalTo(120);
                            make.width.equalTo(imageWidth);
                        }];
                    }
                    //设置内容
                }
            }
        }        
    }
    
    for (int i = 0; i < sum; i ++) {
        UIView *pictureView = [UIView new];
        [self.contentView addSubview:pictureView];
        if (i == 0) {
            [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.top.equalTo(self.titleLb.mas_bottom).equalTo(13);
                make.bottom.equalTo(0);
                make.height.equalTo(120);
                make.width.equalTo(imageWidth);
            }];
        }else{
            [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLb.mas_bottom).equalTo(13);
                make.bottom.equalTo(0);
                make.right.equalTo(-15);
                make.height.equalTo(120);
                make.width.equalTo(imageWidth);
            }];
        }

        
        UIImageView *picIV = [UIImageView new];
        [pictureView addSubview:picIV];
        [picIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(0);
            make.top.equalTo(0);
            make.right.equalTo(pictureView .mas_centerX);
        }];
        UIImageView *commentIV = [UIImageView new];
        [pictureView addSubview:commentIV];
        [commentIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(pictureView.mas_centerX);
            make.right.bottom.equalTo(0);
        }];
        picIV.image = [UIImage imageNamed:@"userDetailbook"];
        commentIV.image = [UIImage imageNamed:@"userDetailbook"];
        
    }   
}


+(CGFloat)calculateCellHeight{
     CGFloat titleHeight = [@"书" sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(kAppScreenWidth, 37)].height;
    return 12 + titleHeight + 12 + 120;
}
@end
