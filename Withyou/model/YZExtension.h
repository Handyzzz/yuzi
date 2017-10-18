//
//  YZExtension.h
//  Withyou
//
//  Created by ping on 2017/5/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "YZVideo.h"
#import "YZLink.h"
#import "YZPdf.h"

@interface YZExtension : NSObject

@property (nonatomic, strong) NSArray <WYPhoto*> *photos;
@property (nonatomic, strong) NSArray <YZVideo*> *videos;
@property (nonatomic, strong) NSArray <YZPdf*> *pdfs;
@property (nonatomic, strong) NSArray <YZLink*> *links;

@end
