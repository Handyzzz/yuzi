//
//  YZLink.h
//  Withyou
//
//  Created by ping on 2017/1/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface YZLink : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *word_count;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *source;
@end
