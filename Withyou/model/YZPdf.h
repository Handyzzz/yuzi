//
//  YZPdf.h
//  Withyou
//
//  Created by ping on 2017/5/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//
/*
 "uuid": "7dc98b04-c73b-4b31-8fa5-4ed0f3cecea6",
 "created_at": "2017-07-18T03:02:37.509098Z",
 "size": 155240,
 "name": "Post Json",
 "created_at_float": 1500346957.509098
 */
#import <Foundation/Foundation.h>

@interface YZPdf : NSObject

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, assign) float *created_at_float;
@property (nonatomic, assign) int size;
@property (nonatomic, strong) NSString *url;

@end
