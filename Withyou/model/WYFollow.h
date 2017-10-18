//
//  WYFollow.h
//  Withyou
//
//  Created by Tong Lu on 2016/11/1.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import "WYUser.h"

@interface WYFollow : NSObject
//关注关系的一条记录
@property (strong, nonatomic) NSString* uuid;
//关注者本人
@property (strong, nonatomic) NSString* follower;
//被我关注的人
@property (strong, nonatomic) NSString* influencer;

@property (strong, nonatomic) NSNumber* created_at_float;



//每次刚进来的时候拉取follow 发送改事件 获取上次改动时间 获取followList UserList,删除的uuidList
+ (void)listFollowBlock:(void(^)(NSArray*followList,NSArray*userList,NSArray*uuidList))block;




//对于每个follow关系，都有group对应，所以，user都在group里，不用再建立新的table
- (WYUser *)followerUser;
- (WYUser *)influencerUser;


//查询双方的关注关系 返回存在的双向关注关系(最多两个) 以及解除的双向关注关系(可以有N个 关系成员固定但是follow的uuid不同)
+ (void)retrieveRelationship:(NSString *)uuid Block:(void(^)(NSArray *existFollowArr, NSArray *delFollowArr))block;

//添加关注 post给后台 然后将返回的follow关系存在了本地
+ (void)addFollowToUuid:(NSString *)influencerUuid Block:(void (^)(WYFollow *follow,NSInteger status))block;

//通过两个人的UUid来查找follow
+(WYFollow *)selectFollowUuidFollowerUuid:(NSString *)followerUuid influcerUuid:(NSString *)influcerUuid;


//删除在本地与后台双方的关注关系 参数是follow本身的UUID
+ (void)delFollow:(NSString *)followUuid Block:(void (^)(BOOL res))block;


//添加关注我的人 排除掉在当前群内的 
+ (void)listFollowListToMeNotInGroup:(NSString*)groupUuid Block:(void(^)(NSArray *removeArr,BOOL success))block;
//邀请我关注人人 排除掉在当前群内的
+ (void)listFollowListFromMeNotInGroup:(NSString*)groupUuid Block:(void(^)(NSArray *removeArr,BOOL success))block;


//通过一个人的Uuid来判断某个人和我的关系 本地查找
/*1 我关注的人 2 关注我的人 3朋友 4自己*/

+ (NSInteger)queryRelationShipWithMeFollowArr:(NSString*)Uuid infArr:(NSArray *)infArr folArr:(NSArray *)folArr;

//我关注的人
+ (NSArray *)queryAllFollowListFromMe;

//我单向关注的人
+ (NSArray *)queryAllSingleFollowListFromMe;

//我的关注者
+ (NSArray *)queryAllFollowListToMe;

//本地查找相互关注的朋友
+ (NSArray *)queryMutualFollowingFriends;



+ (BOOL)saveFollowToDB:(WYFollow *)follow;
+ (BOOL)delFollowFromDB:(NSString *)followUuid;
+ (BOOL)saveFollowListToDB:(NSArray *)follows;
+ (BOOL)delFollowListFromDB:(NSArray *)followUuids;


//either of the two is self.uuid
+ (BOOL)queryExistFollowFrom:(NSString *)follower To:(NSString *)influencer;

+ (NSNumber *)getTopAdd;
+ (NSNumber *)getTopDel;
+ (void)saveTopAdd:(NSNumber *)num;
+ (void)saveTopDel:(NSNumber *)num;
+ (void)saveTopAddOfOthersFollowingMe:(NSNumber *)num;
+ (void)saveTopDelOfOthersFollowingMe:(NSNumber *)num;
//
+ (void)requestFollowingAndFollower;

@end
