//
//  YZVideo.h
//  Withyou
//
//  Created by ping on 2017/1/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface YZVideo : NSObject

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *duration;

- (NSString *)thumbnailImageUrl;

@end
