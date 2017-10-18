//
//  WYGroupInvitation.h
//  Withyou
//
//  Created by 夯大力 on 2017/3/2.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import "WYGroup.h"

@interface WYGroupInvitation : NSObject

/*
 ## GroupInvitation字段
 
 字段 | 类型  | 说明  | 备注
 ----| ----- | ----- | -----
 uuid | string | 邀请本身的uuid |
 group_uuid | string | 群组的uuid  |
 from_uuid | string| 邀请的发起人 |
 to_uuid | string| 被邀请人 |
 created\_at\_float | float| 邀请产生的时间 |
 accepted | bool| 是否已经接受 |
 expiration_time | int| 失效时间，以秒计算 | 默认两周，后端给出
 group | dict| 邀请我加入的群组 | 需要一个对象来映射
 from_user | dict | 邀请人 |
 */

@property(nonatomic,strong)NSString *uuid;
@property(nonatomic,strong)NSString *group_uuid;
@property(nonatomic,strong)NSString *from_uuid;
@property(nonatomic,strong)NSString *to_uuid;
@property(nonatomic,strong) WYGroup *group;

@property(nonatomic,assign)float  created_at_float;
@property(nonatomic,assign)BOOL accepted;
@property(nonatomic,assign)int expiration_time;
@property(nonatomic,strong)WYUser *from_user;




//请求群组邀请的信息
+(void)retrieveGroupInvitation:(NSString *)groupInvitationUuid Block:(void (^)(WYGroupInvitation *groupInvitation,BOOL isExpired,BOOL inGroup,long status))block;


//请求当前邀请的状态 如果是200就跳转 如果是其他的就用alertView提示给用户
+(void)submitAcceptInvitation:(NSString *)groupInvitationUuid Block:(void (^)(WYGroup* group ,long status))block;

//是否过期
-(BOOL)isExpired;

@end


