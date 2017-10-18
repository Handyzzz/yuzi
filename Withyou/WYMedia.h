//
//  WYMedia.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYMedia : NSObject
@property (nonatomic, copy)NSString *uuid;
@property (nonatomic, copy)NSString *admin_uuid;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *icon_url;
@property (nonatomic, assign)int follower_num;
@property (nonatomic, assign)bool followed;
@property (nonatomic, copy)NSString *introduction;
@property (nonatomic, assign)int article_num;
@property (nonatomic, strong)NSNumber *created_at_float;
@property (nonatomic, assign)int type;
@end

