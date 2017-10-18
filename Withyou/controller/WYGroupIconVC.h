//
//  WYGroupIconVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,select_group_icon_type) {
    select_group_icon_typeA = 1,
    select_group_icon_typeB = 2,
};

@interface WYGroupIconVC : UIViewController

//相机相册的回调
@property(nonatomic,copy)void(^selectImgClick)(UIImage *chosenImage,PHAsset *aset,NSDictionary *dic,select_group_icon_type type);

@end
