//
//  WYPreviewPhotoListVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/26.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPreviewPhotoListVC : UIViewController
@property (nonatomic, copy) void(^selectedPhotos)(NSArray *selectedAssetArr ,NSArray* selectedImageArr);
@property (nonatomic, strong) NSMutableArray *selectedAssetArr;
@end
