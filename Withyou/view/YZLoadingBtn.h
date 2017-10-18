//
//  YZLoadingBtn.h
//  Withyou
//
//  Created by ping on 2017/2/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZLoadingBtn : UIButton

@property (nonatomic, assign, readonly)BOOL isLoading;
- (void)startLoading;
- (void)stopLoading;

@end
