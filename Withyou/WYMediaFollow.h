//
//  WYMediaFollow.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/30.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYMedia.h"

@interface WYMediaFollow : NSObject
@property(nonatomic,strong)WYMedia *media;
@property(nonatomic,copy)NSString *media_uuid;
@property(nonatomic,copy)NSString *user_uuid;
@property(nonatomic,copy)NSString *uuid;
@end
