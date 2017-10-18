//
//  WYPublishVC.h
//  Withyou
//
//  Created by Tong Lu on 7/28/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"
typedef void(^publishInfoBlock)(NSDictionary *dict);


@interface WYPublishVC : UIViewController
//发布类型
@property (nonatomic, copy) publishInfoBlock publishInfoBlock;
//发布范围
@property (nonatomic, assign) int publishVisibleScopeType;
@property (nonatomic, strong) NSString *targetUuid;
@property (nonatomic, strong) UICollectionView *classifyCollectionView;
@property (nonatomic, strong) NSString *sectionName;
@property (nonatomic, assign) BOOL lastGroupIsLight;
@property (nonatomic, assign) BOOL lastFriendIsLight;

//个人页或者群组页 geiTa写篇帖子吧
@property (nonatomic, assign)int extraAppointType;
@property (nonatomic, strong)NSString * extraAppointUuid;
@property (nonatomic, strong)NSString *extraAppointName;
//从标签页发帖
@property (nonatomic, strong)NSString *tagName;

//指定群组可见的时候 在与谁一起种用到
@property (nonatomic, strong)WYGroup *group;
@end
