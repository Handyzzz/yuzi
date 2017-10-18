//
//  WYRecommendGroup.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYRecommendGroup : NSObject
@property(nonatomic,strong)NSString *uuid;
@property(nonatomic,assign)int member_num;
@property(nonatomic,assign)int post_num;

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *group_icon;
@property(nonatomic,strong)NSString *introduction;
@property(nonatomic,strong)NSNumber *number;
@property(nonatomic,strong)NSString *tags;
@property(nonatomic,assign)BOOL able_to_apply;

-(NSString *)tagsString;
@end
