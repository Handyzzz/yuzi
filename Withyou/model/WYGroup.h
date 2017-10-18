//
//  WYGroup.h
//  Withyou
//
//  Created by Tong Lu on 7/20/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import "WYUser.h"
typedef NS_ENUM(NSInteger, WYGroupAppliedStatus) {
    WYGroupAppliedStatusDefault = 1,
};

@protocol  WYUser;

@interface WYGroup : NSObject <YYModel>

@property (strong, nonatomic) NSString* uuid;
@property (strong, nonatomic) NSString* name;
//这个是所有的人数
@property (assign, nonatomic) int member_num;
@property (strong, nonatomic) NSNumber *created_at_float;
@property (strong, nonatomic) NSNumber *last_updated_at_float;  //maybe times 100 will be more accurate
//如果是0的话，就是False，那么就是一个真正的多人群组
//否则，就是一个由关注关系产生的双人群
@property (strong, nonatomic) NSNumber *created_by_follow;
@property (strong, nonatomic) NSString *group_icon;
//每次只是部分群成员 第一次会包括所有的管理员
@property (nonatomic) NSArray <WYUser *> *partial_member_list;
//是否是公开可见
@property (strong, nonatomic) NSNumber *public_visible;

@property (nonatomic, strong) NSNumber *content_visible;
//管理员的字段的拼接
@property (strong, nonatomic) NSString *administrator;

//群介绍
@property (nonatomic ,strong) NSString *introduction;
//是否允许群成员去邀请
@property (nonatomic, strong) NSNumber * allow_member_invite;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSArray<WYPost *> *first_ten_post;
//请求者是否愿意公开展示这个群组在自己的个人资料中
@property (nonatomic, strong) NSNumber *display;
//对群内动态是否接收推送通知
@property (nonatomic, strong) NSNumber *notif_new_post;
@property (nonatomic, strong) NSNumber *notif_comment_to_self_related;
@property (nonatomic, strong) NSNumber *notif_comment_to_self_not_related;

@property (nonatomic, strong) NSNumber *applied_status;
@property (nonatomic, strong) NSNumber *category;
@property (nonatomic, strong) NSString *tags;
//设为星标群组
@property (nonatomic, strong) NSNumber * starred;
@property (nonatomic, assign) int unread_post_num;
//未存
@property (nonatomic, strong) NSString *category_name;

//通过管理员UUID字符串 本地获取管理员列表
-(NSMutableArray *)adminList;

//不是通过关注产生的群组的群图片
- (NSString *)groupPicUrl;
- (NSString *)groupName;
- (NSMutableArray *)groupMates;
-(NSString *)tagsString;


//判断自己是否在本地是这个群的成员之一， 之前存的时候是通过partial member list存入的 一定包含自己
//最好用这个 更准确
- (BOOL)meIsMemberOfGroupFromPartialMemberList;

- (BOOL)meIsMemberOfGroupFromLocalDBRecords;



//判断某个用户是否在某个群组内
+ (BOOL)user:(NSString*)userUuid IsMemberOfGroup:(NSString*)groupUuid;

//从本地数据判断一个人是否是管理员
- (BOOL)checkUserIsAdminFromUserUuid:(NSString *)uuid;
- (BOOL)meIsAdmin;

//即将删除的方法
- (BOOL)created_by_follow_bool;

//保存一个群组列表在本地数据库中
//这里不仅仅是存群组group的信息，也存入群组和用户的关系group_user
+ (void)saveNewGroupsToLocalDB:(NSArray *)groupArray;
//保存单个群组到本地数据中 并且保存用户和群组的关系
+ (void)insertGroup:(WYGroup *)group;
//本地查找
+ (WYGroup *)selectGroupDetail:(NSString *)uuid;
//我参与的所有群组，无论是通过创建产生的，还是关注产生的
+ (void)queryAllGroupsWithBlock:(void (^)(NSArray *groups))block;
//我的所有星标群组
+ (void)queryAllStarredGroupsWithBlock:(void(^)(NSArray *groupArr))block;
//返回一个数组，里面都是NSNumber
+ (NSArray *)queryAllMyGroupNumbers;

//从本地数据库中删除某个群组 （ 并且删除用户和群组的关系）
+ (void)removeGroupInGroups:(NSString *)groupUuid;
//添加群组与用户的关系
+(void)addGroupToUser:(NSString*)groupUuid UserUuid:(NSString*)userUuid;

//将user 和 group 的关系删除
+(void)removeGroupToUser:(NSString*)groupUuid UserUuid:(NSString*)userUuid;

//删除group_user表
+(void)delGroupToUserTableData:(FMDatabase *)db :(BOOL*)rollback;


@end


