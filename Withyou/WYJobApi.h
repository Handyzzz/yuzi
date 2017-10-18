//
//  WYJobApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYJobApi : NSObject
//展示我的所有工作经历
+(void)getUserAllJob:(NSString *)userUuid page:(NSInteger)page Block:(void(^)(NSArray *jobArr,BOOL hasMore))block;

//创建一条工作经历
+(void)postJobDetailDic:(NSDictionary *)dic Block:(void(^)(WYJob *job))block;

//获取一条具体的工作经历的详情
+(void)getJobDetail:(NSString *)jobUuid Block:(void(^)(WYJob *job))block;

//修改一条具体的工作经历的详情
+(void)patchJobDetail:(NSString *)jobUuid Dic:(NSDictionary *)dic Block:(void(^)(WYJob *job))block;

//删除一条具体的工作经历的详情
+(void)deleteJobDetail:(NSString *)jobUuid Block:(void(^)(BOOL haveDelete))block;


@end
