//
//  WYUserPhotoVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/5/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYUserBaseVC.h"
#import "WYUserDetail.h"

@interface WYUserPhotoVC : WYUserBaseVC
@property (nonatomic, strong)WYUserDetail *userInfo;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *imageArr;

@end
