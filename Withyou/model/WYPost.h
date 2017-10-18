//
//  WYPost.h
//  Withyou
//
//  Created by Tong Lu on 7/16/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <YYModel.h>
#import "WYUser.h"
#import "WYPhoto.h"
#import "YZLink.h"
#import "YZVideo.h"
#import "YZMarkText.h"
#import "YZPostComment.h"
#import "YZAddress.h"
#import "YZExtension.h"
#import "WYTag.h"

//1纯文字，2单张照片，3相册，4链接，5视频
typedef NS_ENUM(NSInteger, WYPostType) {
    WYPostTypeOnlyText = 1,
    WYPostTypeSingleImage = 2,
    WYPostTypeAlbum = 3,
    WYPostTypeLink = 4,
    WYPostTypeVideo = 5,
};

@protocol WYPhoto;

@interface WYPost : NSObject <YYModel>

@property (nonatomic) WYUser *author;

@property (strong, nonatomic) NSString* uuid;
@property (assign, nonatomic) WYPostType type;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSNumber *createdAtFloat;
//相册标题
@property (strong, nonatomic) NSString* albumTitle;

/*
 分享的可见范围
 */
@property (strong, nonatomic) NSNumber *targetType;
//如果是针对指定群组可见的话，这里就是那个群组的uuid
//如果是针对指定朋友可见的话，这里就是那个朋友的uuid
@property (strong, nonatomic) NSString* targetUuid;
//如果是针对指定群组可见的话，这里就是那个群组的名称
//如果是针对指定朋友可见的话，这里就是那个朋友的姓名
@property (strong, nonatomic) NSString* targetName;

//分享内的照片的总的数量
@property (assign, nonatomic) int photoNum;
//分享的星标的数量
@property (assign, nonatomic) int starNum;
//分享的评论的数量, 只显示公开评论的数量，因为如果私密评论很多，公开评论为空，就显示为0，用户会觉得奇怪
@property (assign, nonatomic) int commentNum;
//分享的评论的数量, 只显示公开评论的数量，因为如果私密评论很多，公开评论为空，就显示为0，用户会觉得奇怪
@property (assign, nonatomic) int private_comment_num;

//当前用户对此条分享是否加了星标
@property (assign, nonatomic) int starred;

//如果是发布单张图片，或者相册的话，才可能有这个字段，表示封面照片
@property (strong, nonatomic) WYPhoto *mainPic;
//如果是相册的话，这里是相册里的图片的列表
@property (strong, nonatomic) NSArray <WYPhoto*> *images;
//如果是视频的分享的话，这里是视频的内容
@property (strong, nonatomic) YZVideo *video;
//链接
@property (strong, nonatomic) YZLink *link;
//标签(<标签名>)
@property (strong, nonatomic) NSArray *tags;
//标签列表(<WYTag>)
@property (strong, nonatomic) NSArray <WYTag*>*tag_list;
// 地址信息
@property (strong, nonatomic) YZAddress *address;
// 分享扩展
@property (strong, nonatomic) YZExtension *extension;

//与谁一起
@property (strong,nonatomic) NSArray <WYUser*> *with_people;

//@高亮携带的信息
@property (strong, nonatomic) NSArray <YZMarkText *> *mention;

//推荐理由
@property (nonatomic, strong)NSString *recommend_reason;

// 后3条评论
@property (strong, nonatomic) NSArray <YZPostComment *> *comments;

// 星标的人
@property (strong, nonatomic) NSArray <WYUser *> *starred_users;

//订阅
@property (assign,nonatomic) BOOL subscribed;

- (NSString *)authorDisplayName;


+ (NSArray *)queryPostsFromCache;
+ (BOOL)savePostToDB:(WYPost *)post;
+ (BOOL)deletePostFromDB:(NSString *)uuid;
+ (BOOL)deleteAllPostFromCache;


+ (NSArray *)queryRecommendPostsFromCache;
+ (BOOL)saveRecommendPostToDB:(WYPost *)post;
+ (BOOL)deleteRecommendPostFromDB:(NSString *)uuid;
+ (BOOL)deleteAllRecommendPostFromCache;


//草稿箱
+ (void)queryDraftFromCacheBlock:(void (^)(NSArray *contentArr,NSArray *timeArr))block;
+ (BOOL)saveDraftToDBContent:(NSString *)content time:(NSString *)creatTime;
+ (BOOL)deleDraftFromDB:(NSString*)creatTime;
+ (BOOL)deleteAllDraftFromCache;

//@的特殊符号过滤器，对于多个@可能有点问题，而且之后决定不用返回post，而是只对content做过滤
+(WYPost*)filter:(WYPost*)post;

// 返回一个去掉了所有的mention方括号的字符串
+ (NSString *)filteredContentStringFrom:(WYPost*)post;

//经过at转义之后的attributedString,已经有了高亮，应当可以点击
- (NSAttributedString *)convertedAttributedString;

@end
