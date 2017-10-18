//
//  WYChatApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYChatApi.h"

@implementation WYChatApi
+ (void)chatWithUser:(WYUser *)user {
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationYZChatBegin object:user];
    
    [[WYHttpClient sharedClient] POST:@"/api/v1/em_chat_user/" parameters:@{@"to_uuid":user.uuid} showToastError:NO callback:^(id responseObject) {
        WYLog(@"chatWithUser: %@",responseObject);
    }];
}

+ (void)deleteUserChat:(NSString *)uuid Block:(void(^)(BOOL haveDelete))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/em_chat_user/%@/", uuid];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:uuid forKey:@"to_uuid"];
    
    [[WYHttpClient sharedClient] DELETE:s parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(YES);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%ld",(long)httpResponse.statusCode);
        debugLog(@"%@",httpResponse.description);
        if (block) {
            block(NO);
        }
    }];
}

+ (void)getChatList:(void (^)(NSArray *modals))callback {
    [[WYHttpClient sharedClient] GETModelArrayWithKey:@"results" forClass:[WYUser class] url:@"/api/v1/em_chat_user/chat_user_list/" parameters:nil callback:^(NSArray *modelArray, id response) {
        if(callback) {
            callback(modelArray);
        }
    }];
}


@end
