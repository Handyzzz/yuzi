//
//  WYGroupClasses.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYGroupClasses : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) int count;
@property(nonatomic, assign) int  category;
@property(nonatomic, strong) NSString *image;

//推荐分类的群组
+(void)listRecommentGroupCategory:(NSInteger)type Block:(void(^)(NSArray *groupsCateArr,BOOL success))block;

+ (void)saveAllGroupCategoryToLocalDB:(NSArray *)groupCategoryArr;

+ (void)queryAllGroupCategoryWithBlock:(void (^)(NSArray *groupCategoryArr))block;

@end
