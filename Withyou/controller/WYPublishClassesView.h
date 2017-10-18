//
//  WYPublishClassesView.h
//  Withyou
//
//  Created by Handyzzz on 2017/3/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum type {
    videoType = 1,
    photoAlbumYype = 2,
    linkType = 3,
    photoType = 4,
    characterType = 5,
    articleType = 6,
} PublishType;
@interface WYPublishClassesView : UIView
//5个放在下边的UIView
@property (nonatomic, strong)UIButton *videoBtn;
@property (nonatomic, strong)UIButton *photoAlbumBtn;
@property (nonatomic, strong)UIButton *linkBtn;
@property (nonatomic, strong)UIButton *photoBtn;
@property (nonatomic, strong)UIButton *characterBtn;
@property (nonatomic, strong)UIButton *articleBtn;
@property (nonatomic, assign)PublishType Type;
@property (copy, nonatomic) void(^contentClick)(PublishType Type);
-(void)setViewData;
@end
