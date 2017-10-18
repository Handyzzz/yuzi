//
//  YZVideo.m
//  Withyou
//
//  Created by ping on 2017/1/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZVideo.h"

@implementation YZVideo

- (NSString *)thumbnailImageUrl
{
//    debugLog(@"self url %@", self.url);
    if(self.width.intValue == 0) return [self.url stringByAppendingString:@"?vframe/png/offset/1/w/1000/h/1000"];
    float a = (self.height.floatValue/self.width.floatValue) * 1000;
    NSString *extention = [NSString stringWithFormat:@"?vframe/png/offset/1/w/1000/h/%d", (int)(a)];
//    debugLog(@"converted video url %@, orig height %@, orig width %@", extention, self.height, self.width);
    
    NSString *s = [self.url stringByAppendingString:extention];
    
    //再加了这个管道之后，sd_webImage就不出图像了
//    NSString *s = [self.url stringByAppendingString:@"?vframe/png/offset/1/w/600/h/600|imageView2/1/w/600/h/600"];

    return s;
}

@end
