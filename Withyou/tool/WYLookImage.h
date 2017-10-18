//
//  WYImageZoomVC.h
//  Withyou
//
//  Created by Tong Lu on 1/15/15.
//  Copyright (c) 2015 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYLookImage : UIView<UIScrollViewDelegate>
+ (void)showWithImage:(UIImage *)image  imageURL:(NSString *)imageURL;
@end
