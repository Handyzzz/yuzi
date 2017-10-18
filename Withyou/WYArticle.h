//
//  WYArticle.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYMedia.h"

@interface WYArticle : NSObject
@property(nonatomic, strong) NSString *uuid;
@property(nonatomic, strong) NSString *media_uuid;
@property(nonatomic, strong) WYMedia *media;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *image_url;
@property(nonatomic, copy) NSString *content_str;
@property(nonatomic, assign) int star_num;
@property(nonatomic, assign) int comment_num;
@property(nonatomic, assign) bool starred;
@property(nonatomic, strong) NSNumber *createdAtFloat;
@property(nonatomic, strong) NSString *content_html;
@property(nonatomic, strong) NSString *web_url;
@end

