//
//  WYStudyApi.h
//  
//
//  Created by Handyzzz on 2017/8/9.
//
//

#import <Foundation/Foundation.h>

@interface WYStudyApi : NSObject
//展示我的所有学习经历
+(void)getUserAllStudy:(NSString *)userUuid page:(NSInteger)page Block:(void(^)(NSArray *studyArr,BOOL hasMore))block;


//创建学习经历
+(void)postUserStudyDetail:(NSDictionary *)dic Block:(void(^)(WYStudy *study))block;

//修改一条具体的学习经历的详情
+(void)patchStudyDetail:(NSString *)jobUuid Dic:(NSDictionary *)dic Block:(void(^)( WYStudy*study))block;


//删除一条具体的学习经历的详情
+(void)deleteStudyDetail:(NSString *)jobUuid Block:(void(^)(BOOL haveDelete))block;

@end
