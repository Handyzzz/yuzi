//
//  WYGroupClasses.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupClasses.h"
#import "WYGroup.h"
@implementation WYGroupClasses

//推荐分类的群组
+(void)listRecommentGroupCategory:(NSInteger)type Block:(void(^)(NSArray *groupsCateArr,BOOL success))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/rec_group/category/"];
    
    NSDictionary *dic = @{@"num":@(type)};
    [[WYHttpClient sharedClient]GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *cateArr = [WYGroupClasses YYModelParse:[responseObject objectForKey:@"categories"]];
        
        [WYGroupClasses saveAllGroupCategoryToLocalDB:cateArr];
        if (block) {
            block(cateArr,YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block) {
            block(nil,NO);
        }
    }];
}

+ (void)saveAllGroupCategoryToLocalDB:(NSArray *)groupCategoryArr{
   
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString * sql_groupCategory = @"insert or replace into 'rec_group_category' (name, count, category, image) values (?, ?, ?, ?)";
        
        BOOL res;
        int errorCount = 0;
        
        for(WYGroupClasses *groupCategory in groupCategoryArr){
            
            res = [db executeUpdate:sql_groupCategory, groupCategory.name,[NSNumber numberWithInt:groupCategory.count],[NSNumber numberWithInt:groupCategory.category],groupCategory.image];
            
            if (!res) {
                debugLog(@"error to insert groupCategoryArr");
                errorCount++;
                break;
            }else {
                if (errorCount != 0) {
                    break;
                }
            }
        }
        
        if (errorCount != 0) {
            *rollback = YES;
            return;
        }
    }];
}

+ (void)queryAllGroupCategoryWithBlock:(void (^)(NSArray *groupCategoryArr))block{
    
    NSMutableArray *groupCategoryArr = [NSMutableArray array];
    
    __block WYGroupClasses *groupClasses;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *query = @"select * from 'rec_group_category'";
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            groupClasses = [[WYGroupClasses alloc] init];
            
            groupClasses.name = [rs stringForColumn:@"name"];
            groupClasses.count = [rs intForColumn:@"count"];
            groupClasses.category = [rs intForColumn:@"category"];
            groupClasses.image = [rs stringForColumn:@"image"];
            
            [groupCategoryArr addObject:groupClasses];
        }
    }];
    
    if(block)
        block([groupCategoryArr copy]);
}
@end
