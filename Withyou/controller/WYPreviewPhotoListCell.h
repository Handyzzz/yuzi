//
//  WYPreviewPhotoListCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/26.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPreviewPhotoListCell : UICollectionViewCell
@property(nonatomic, strong)UIImageView *photoIV;
@property (nonatomic, copy) void(^longTapClick)(UILongPressGestureRecognizer*longPress);

@end
