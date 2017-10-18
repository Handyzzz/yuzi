//
//  WYGroupListApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupListApi.h"
#import "WYGroup.h"

@implementation WYGroupListApi
//请求所有群组
+ (void)requestGroupListWithBlock:(void (^)(NSArray *groups))block
{
    if([[WYUtility sharedAppDelegate] requestGroupLock])
    {
        //if another thread is requesting, this lock prevent a new request
        return;
    }
    
    NSNumber *t = [[NSUserDefaults standardUserDefaults] objectForKey:kGroupListNewestLastUpdatedTime];
    if(!t) {
        t = @0;
    }
    
    [WYUtility sharedAppDelegate].requestGroupLock = true;
    
    //    debugLog(@"t is %@", t);
    
    [[WYHttpClient sharedClient] GET:@"api/v1/group/all/" parameters:@{@"t": t} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *allGroups = [responseObject objectForKey:@"all"];
        NSArray *delUidArr = [responseObject objectForKey:@"delete"];
        if(allGroups.count > 0)
        {
            //所有群组
            NSArray *groupArray = [NSArray yy_modelArrayWithClass:[WYGroup class] json:allGroups];
            //所有群组最后更新时间戳
            NSArray *sortdesc = @[[NSSortDescriptor sortDescriptorWithKey:@"last_updated_at_float" ascending:NO],
                                  ];
            NSArray *sortedArray = [groupArray sortedArrayUsingDescriptors:sortdesc];
            NSNumber *largestTime = [[sortedArray objectAtIndex:0] last_updated_at_float];
            
            [[NSUserDefaults standardUserDefaults] setObject:largestTime forKey:kGroupListNewestLastUpdatedTime];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //这个需要保存在本地，因为都是自己参与的群组
            [WYGroup saveNewGroupsToLocalDB:groupArray];
            
            [WYUtility sharedAppDelegate].requestGroupLock = false;
            
            if(block)
                block([groupArray copy]);
            
        }
        else
        {
            
            [WYUtility sharedAppDelegate].requestGroupLock = false;
            
            if(block)
                block(nil);
        }
        if (delUidArr.count > 0) {
            //将群组从本地删除
            for (NSString *uuid in delUidArr) {
                [WYGroup removeGroupInGroups:uuid];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [WYUtility sharedAppDelegate].requestGroupLock = false;
        
        if(block)
            block(nil);
        
    }];
    
}

//推荐群组
+(void)listRecommendGroupsBlock:(void(^)(NSArray *groupsArr,BOOL success))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/group/recommend_groups/"];
    [[WYHttpClient sharedClient]GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *groupModelArr = [responseObject objectForKey:@"all"];
        NSArray *groupArr = [WYGroup YYModelParse:groupModelArr];
        
        if (block) {
            block(groupArr,YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}

//推荐更多群组
//推荐更多群组 没有的时候返回的时候空数组
+(void)listMoreRecommendGroups:(NSArray *)groupArr Block:(void(^)(NSArray *moreGroupArr,BOOL success))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/group/recommend_more_group/"];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:groupArr forKey:@"group_list"];
    debugLog(@"%@",dic);
    
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *moreGroupModelArr = [responseObject objectForKey:@"all"];
        NSArray *moreGroupsArr = [WYGroup YYModelParse:moreGroupModelArr];
        if (block) {
            block(moreGroupsArr,YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%lu",httpResponse.statusCode);
        if (block) {
            block(nil,NO);
        }
    }];
}

//搜索群组
+(void)listSearchGroups:(NSString *)text time:(NSNumber *)time Block:(void(^)(NSArray *groupArr,BOOL success))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/group/search_by_keyword/"];
    NSDictionary *dic = @{
                          @"keyword":text,
                          @"t":time,
                          };
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"%@",responseObject);
        NSArray *groupModelArr = [responseObject objectForKey:@"all"];
        NSArray *groupArr = [WYGroup YYModelParse:groupModelArr];
        if (block) {
            block(groupArr,YES);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
    
}

@end
