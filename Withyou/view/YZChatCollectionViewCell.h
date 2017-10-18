//
//  YZChatCollectionViewCell.h
//  Withyou
//
//  Created by ping on 2017/3/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#define chatItemW ((kAppScreenWidth - (3 - 1)*8)/3)
#define chatItemH ((chatItemW *1.0) + 62)

#define annularWH  74.f
#define chatImageWH 68.f

@interface YZChatCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) UIView *groudView;
@property (nonatomic, strong) UIImageView *annularIV;
@property (nonatomic, weak) UIImageView *iconImage;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *textLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (copy, nonatomic) void(^removeMessageBlock)();
- (void) rebuildWith:(WYUser *)user;

@end
