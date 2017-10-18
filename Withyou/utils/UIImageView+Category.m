//
//  NSObject+UIImageView_Category.m
//  Withyou
//
//  Created by ping on 2017/1/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "UIImageView+Category.h"

@implementation UIImageView (YZCategory)

/**
 *  获取视频的缩略图方法
 *
 *  @param url 视频的链接地址
 *
 *  @return 视频截图
 */
- (void)setScreenShotImageFromVideoURL:(NSString *)url {
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //视频路径URL
        NSURL *fileURL = [NSURL URLWithString:url];

        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];

        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        
        gen.appliesPreferredTrackTransform = YES;
        
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        
        NSError *error = nil;
        
        CMTime actualTime;
        
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        
        UIImage *shotImage = [[UIImage alloc] initWithCGImage:image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.image = shotImage;
        });
        CGImageRelease(image);
    });
}


@end
