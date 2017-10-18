//
// Created by Handyzzz on 2017/9/27.
// Copyright (c) 2017 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYMedia.h"

@interface WYMediaTag : NSObject
@property (nonatomic, assign)int tag_num;
@property (nonatomic, assign)int tag_sum;
@property (nonatomic, copy)NSString *tag_name;
@property (nonatomic, copy)NSArray<WYMedia *> *media_list;
@end
