//
//  WYPostRecommendCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/5/6.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum type {
    characterType = 1,
    photoType = 2,
    photoAlbumYype = 3,
    linkType = 4,
    videoType = 5

} PublishType;

/*
文字能有标题的  文字 相册 链接
  */
@interface WYPostRecommendCell : UICollectionViewCell
@property(nonatomic, strong)UIImageView *contentIV;
//视频的情况下 有一个相机的时间的label
@property (nonatomic, weak) UIView *playView;
@property (nonatomic, weak) UILabel *playLabel;


@property(nonatomic, strong)UIImageView *titleIV;
@property(nonatomic, strong)UILabel *titleLb;
@property(nonatomic, strong)UILabel *textLb;


@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UILabel *reasonLb;

@property(nonatomic, strong)UIView *textLabelLine;
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel *nameLb;


-(void)setCellData:(WYPost *)recommentPost;
+(CGFloat)calculateCellHeight:(WYPost*)recommentPost;


@property (copy, nonatomic) void(^iconClick)();
@property (nonatomic, copy) void(^imageClick)();

@end
