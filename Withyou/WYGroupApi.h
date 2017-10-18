//
//  WYGroupApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYGroup.h"

@interface WYGroupApi : NSObject

//网络请求群组详情
+ (void)retrieveGroupDetail:(NSString *)uuid Block:(void (^)(WYGroup *group,long status))block;

//群成员列表页面 这里可以通过上拉的到更多的 成员  其他的都只能获取群内的一部分成员  这里边没有管理员
+(void)wholeMemberListForGroup:(NSString*)groupUuid lastUuid:(NSString*)lastUuid Block:(void(^)(NSArray *memberList))block;

//请求获取群组设置的开关状态
+(void)retrieveGroupNotiForSetting:(NSString *)groupUuid Block:(void(^)(NSDictionary *notifDict))block;

//请求上传群组设置的开关状态
+(void)patchUpdateGroupNotiForSetting:(NSString *)groupUuid Param:(NSDictionary *)dic Block:(void(^)(WYGroup *group))block;

//新建群组（有用到保存单个群组到本地 也就保存群主与群的关系）
+ (void)addNewGroupWith:(NSString *)name ImageWith:(PHAsset *)asset groupIntroduction:(NSString *)introduction callback:(void (^)(WYGroup *group,NSInteger status))cb;

//创建群组 不用上传请求key
+ (void)addNewGroupWith:(NSString *)name dict:(NSDictionary *)dic groupIntroduction:(NSString *)introduction callback:(void (^)(WYGroup *group,NSInteger status))cb;

//请求退出群组 并且从本地数据库删掉
+(void)requestQuitGroup:(NSString *)groupUuid groupName:(NSString*)groupName Block:(void(^)( long status))block;

//更换群头像 然后将group更新到本地
+ (void)changeGroup:(NSString *)groupUuid ImageWith:(PHAsset *)asset callback:(void (^)(WYGroup *group))cb;

//管理员修改群资料 包括头像(必须先有key) 名称 介绍 以及对群组bool类型的设置 然后将group更新到本地
+ (void)changeGroupDetail:(NSString*)groupUuid dic:(NSDictionary*)dic Block:(void(^)(WYGroup *group))block;

//通过群的号码来搜索到群
+ (void)searchGroupFromNumer:(NSString *)groupNumberStr Token:(NSString *)token Block:(void(^)(WYGroup *group))block;

//邀请我关注的人
+(void)inviteInfluencer:(NSString *)groupUuid inviteArr:(NSMutableArray *)user_list Block:(void (^)(NSArray* alreadyArr, NSArray*notInfluencerArr ,NSArray* successArr ,long status))block;

//添加关注我的人
+(void)addFollowerToGroup:(NSString *)groupUuid inviteArr:(NSMutableArray *)user_list Block:(void (^)(NSArray* alreadyArr, NSArray*notFollowerArr ,NSArray* successArr ,long status))block;

//移除群成员
+ (void)removeGroupMember:(NSString*)groupUuid RemoveList:(NSArray *)removeList Block:(void(^)(NSArray *removedArr, NSArray*notInGroupArr))block;

//举报群组
+(void)reportGroup:(NSString *)groupUuid type:(NSNumber*)type Block:(void(^)(long status))block;

//转让管理员
+(void)transferAdmin:(NSString*)groupUuid userUuid:(NSString*)userUuid Block:(void(^)(WYGroup *group))block;

//申请加入群组
+ (void)requestJoinGroup:(NSString *)uuid comment:(NSString*)comment callback:(void (^)(BOOL success))block;

//通过群链接邀请
+(void)requestGroupLink:(NSString *)groupUuid Block:(void(^)(NSString *s))block;

//群组后台头像
+(void)listGroupIconsArrPage:(NSInteger)page Block:(void(^)(NSArray *dicArr,BOOL hasMore))block;
@end
