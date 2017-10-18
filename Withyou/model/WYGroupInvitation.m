//
//  WYGroupInvitation.m
//  Withyou
//
//  Created by 夯大力 on 2017/3/2.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupInvitation.h"

@implementation WYGroupInvitation


//请求群组邀请的信息
+(void)retrieveGroupInvitation:(NSString *)groupInvitationUuid Block:(void (^)(WYGroupInvitation *groupInvitation,BOOL isExpired,BOOL inGroup,long status))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/group_invitation/%@/",groupInvitationUuid];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSError *error;
        WYGroupInvitation *groupInvitation = [WYGroupInvitation yy_modelWithDictionary:responseObject];
        if (!error) {
            if (block) {
                block(groupInvitation,[groupInvitation isExpired],[groupInvitation inGroup:httpResponse.statusCode],httpResponse.statusCode);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%ld",(long)httpResponse.statusCode);
        if (block) {
            block(nil,0,0,0);
        }
    }];
}


//接受邀请的post请求
//请求当前邀请的状态 如果是200就跳转 如果是其他的就用alertView提示给用户
+(void)submitAcceptInvitation:(NSString *)groupInvitationUuid Block:(void (^)(WYGroup* group ,long status))block{
    NSString* s = [NSString stringWithFormat:@"api/v1/group_invitation/%@/accept/",groupInvitationUuid];
    
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        WYGroup *group = [WYGroup yy_modelWithDictionary:responseObject[@"group"]];
        if (group) {
            [WYGroup insertGroup:group];
        }
        if (block) {
            block(group ,(long)httpResponse.statusCode);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (block) {
            block(nil ,(long)httpResponse.statusCode);
        }

    }];

}

-(BOOL)isExpired{
    //当前时间距离1979年的秒数
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    //预计过期时间距离1970年的秒数
    NSTimeInterval expirationTime = self.created_at_float + self.expiration_time;
    //判断是否过期
    if (nowTime < expirationTime) {
        //未过期
        return NO;
    }
    //过期
    return YES;
}
-(BOOL)inGroup:(NSUInteger )status{
    if (status == 203) {
        return YES;
    }else{
        return NO;
    }
}
@end
