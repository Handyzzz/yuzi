//
//  Message.h
//  Withyou
//
//  Created by ping on 2016/12/17.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface YZMessage : NSObject


// uuid: 此消息本身的uuid，字符型
@property(copy, nonatomic) NSString * uuid;

// user_uuid: 此消息归属的用户的uuid，请求到的应该是自己的uuid，但是因为与子是多用户的，在存到本地数据库时会需要区分。
@property(copy, nonatomic) NSString * user_uuid;

// created_at_float: 此消息产生的时间，小数表示的unix timestamp，小数点后有6位数字
@property(strong, nonatomic) NSNumber *created_at_float;

// 不再用数字型的type，而是用字符串型的
//@property(assign, nonatomic) YZMessageType message_type;

// tony 2017.05.23 added
@property(copy, nonatomic) NSString* message_type_str;

// message_content：消息的文字内容，如果是有人评论的话，这里显示为对方发布评论的内容。如果是有人关注了我，则为『ABC关注了你』。后端会处理好，前端只需要原样显示即可。
@property(copy, nonatomic) NSString * message_content;

// 消息体的小图标，星标或者被关注时会有
@property(copy, nonatomic) NSString * message_content_pic;

// author_uuid: 与我互动的用户的uuid
@property(copy, nonatomic) NSString * author_uuid;

// 动作的描述
@property(copy, nonatomic) NSString * action_text;

//author与我互动的人
// tony 2017.5.23
//现在可以不用这个嵌套的字段， 这个嵌套增加了复杂度
//@property(nonatomic ,strong) WYUser *author;

// author_icon: 与我互动的用户的头像url
@property(copy, nonatomic) NSString * author_icon;

// author_name: 此用户的姓名
@property(copy, nonatomic) NSString * author_name;

// target_type: 暂定与message_type一致，这里前端可以暂时不用
//@property(assign, nonatomic) int target_type;

// 点击后进入的资源的类型，包括post, group, group_invitation, user, link
@property(copy, nonatomic) NSString * target_type_str;

// target_uuid: 被触发的内容的uuid，用于定位到这个页面
@property(copy, nonatomic) NSString * target_uuid;

// target_pic: 若右侧内容有图片时，为图片url，否则为空字符串。
@property(copy, nonatomic) NSString * target_pic;

// target_content: 若右侧内容没有图片时，则必有文字内容，此为文字内容。另外，如果是推荐朋友或者群组给用户的话，这里是朋友或者群组的名字，需要拼接
@property(copy, nonatomic) NSString * target_content;

// 如果需要点击跳转到某个url的话，使用这个url
@property(copy, nonatomic) NSString * target_url;

// 如果需要显示某个评论回复了哪个评论，被回复的评论的内容在这里，
@property(copy, nonatomic) NSString * reply_content;


// 缓存消息
+ (void)saveToDataBase:(NSArray<YZMessage *> *)arr withCallback:(void(^)(BOOL res))cb;
// 查询缓存消息 指定消息之后的换成, 如果不穿,返回最新的前50条
+ (void)queryDBCacheWith:(YZMessage *)msg Results:(void(^)(NSArray<YZMessage *> *list))cb;
// 删除消息
+ (void)deleteWith:(NSString *)uuid;
// 查询是否缓存
+ (void)isExist:(NSArray *)messags callback:(void(^)(int count))cb;
// 清空缓存
+ (void)removeAll;

//数据库读取时，抽象出来的一个方法
+ (YZMessage *)messageFromFMResultSet:(FMResultSet *)rs;

@end
