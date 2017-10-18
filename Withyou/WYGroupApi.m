//
//  WYGroupApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupApi.h"

@implementation WYGroupApi
+ (void)retrieveGroupDetail:(NSString *)uuid Block:(void (^)(WYGroup *group,long status))block
{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/group/%@/", uuid];
    
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        WYGroup *group = [WYGroup yy_modelWithDictionary:responseObject];
        //暂时将 这个数据存为0  后端暂时没有清0
        group.unread_post_num = 0;

        debugLog(@"group detail is %d", group.unread_post_num);
        
        if(!error)
        {
            //这里需要做判断，必须是自己参加的群组，才应保存在本地
            //                 有些情况下，比如说自己点击消息，里面是一个之前自己被拉入群组，点击后会请求群组的详情
            //   但是因为最近加入后又退出了，所以不应该保存在本地
            
            if([group meIsMemberOfGroupFromPartialMemberList])
                [WYGroup saveNewGroupsToLocalDB:@[group]];
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            if(block)
                block(group,httpResponse.statusCode);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if(block)
            block(nil,httpResponse.statusCode);
        
    }];
}


//邀请我关注的人 需要对方同意（所以在这里没有将用户和群组的关系直接保存）
+(void)inviteInfluencer:(NSString *)groupUuid inviteArr:(NSMutableArray *)user_list Block:(void (^)(NSArray* alreadyArr, NSArray*notInfluencerArr ,NSArray* successArr ,long status))block{
    
    NSString *s = [NSString stringWithFormat:@"/api/v1/group/%@/invite_influencer_to_group/",groupUuid];
    
    NSDictionary *md = [NSDictionary dictionaryWithObject:[user_list copy]forKey:@"user_list"];
    [[WYHttpClient sharedClient] POST:s parameters:[md copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%lu",httpResponse.statusCode);
        NSError *error;
        NSArray *alreadyArr = [responseObject objectForKey:@"already_group_mumber_list"];
        NSArray *notInfluencerArr = [responseObject objectForKey:@"not_influencer_list"];
        NSArray *successArr = [responseObject objectForKey:@"success_list"];
        
        if (!error && block) {
            block(alreadyArr,notInfluencerArr,successArr,httpResponse.statusCode);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%lu",httpResponse.statusCode);
        
        if (block){
            //不能给int类型传空值 后边有待完善
            block(nil,nil,nil,httpResponse.statusCode);
        }
        
    }];
    
}
//添加关注我的人 直接拉进群（并且有将用户和群组的关系保存到本地）
+(void)addFollowerToGroup:(NSString *)groupUuid inviteArr:(NSMutableArray *)user_list Block:(void (^)(NSArray* alreadyArr, NSArray*notFollowerArr ,NSArray* successArr ,long status))block{
    
    NSString *s = [NSString stringWithFormat:@"/api/v1/group/%@/add_my_follower_to_group/",groupUuid];
    
    NSDictionary *md = [NSDictionary dictionaryWithObject:[user_list copy]forKey:@"user_list"];
    debugLog(@"%@",md);
    [[WYHttpClient sharedClient] POST:s parameters:[md copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSError *error;
        NSArray *alreadyArr = [responseObject objectForKey:@"already_group_mumber_list"];
        NSArray *notInfluencerArr = [responseObject objectForKey:@"not_influencer_list"];
        NSArray *successArr = [responseObject objectForKey:@"success_list"];
        for (NSDictionary*dic in successArr) {
            //添加用户与群组的关系到本地
            NSString*userUuid = [dic objectForKey:@"uuid"];
            [WYGroup addGroupToUser:groupUuid UserUuid:userUuid];
            
        }
        
        if (!error && block) {
            block(alreadyArr,notInfluencerArr,successArr,httpResponse.statusCode);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%lu",httpResponse.statusCode);
        if (block){
            //不能给int类型传空值 后边有待完善
            block(nil,nil,nil,httpResponse.statusCode);
        }
        
    }];
    
}

+(void)wholeMemberListForGroup:(NSString*)groupUuid lastUuid:(NSString*)lastUuid Block:(void(^)(NSArray *memberList))block{
    
    
    NSString *s = [NSString stringWithFormat:@"/api/v1/group/%@/member_list/",groupUuid];
    //只能传空字符串 不可以传nil
    if (lastUuid) {
        
    }else{
        lastUuid = @"";
    }
    NSDictionary *md = [NSDictionary dictionaryWithObject:lastUuid forKey:@"last_member_uuid"];
    
    [[WYHttpClient sharedClient] GET:s parameters:[md copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%lu",httpResponse.statusCode);
        
        NSArray *arr = [NSArray yy_modelArrayWithClass:[WYUser class] json:[responseObject objectForKey:@"member"]];
        NSError *error;
        if (!error && block) {
            block(arr);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%ld",httpResponse.statusCode);
        if (block){
            //不能给int类型传空值
            block(nil);
        }
        
    }];
}

//请求获取群组设置的开关状态
+(void)retrieveGroupNotiForSetting:(NSString *)groupUuid Block:(void(^)(NSDictionary *notifDict))block{
    
    //    'new_post', 'comment_to_self_related', 'comment_to_self_not_related'
    NSString *s = [NSString stringWithFormat:@"/api/v1/group/%@/notif/",groupUuid];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block){
            block(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if(block)
            block(nil);
    }];
    
    
}
//请求上传群组设置的开关状态
+(void)patchUpdateGroupNotiForSetting:(NSString *)groupUuid Param:(NSDictionary *)dic Block:(void(^)(WYGroup *group))block{
    NSString *s = [NSString stringWithFormat:@"/api/v1/group/%@/group_settings/",groupUuid];
    [[WYHttpClient sharedClient]PATCH:s parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WYGroup *group = [WYGroup yy_modelWithDictionary:responseObject];
        //将这个群组替换到本地
        //修改群组需要保存
        [WYGroup insertGroup:group];
        if(block) {
            block(group);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if(block)
            block(nil);
    }];
}
//退出群组(在本地有删除群组 并且删除的时候有将用户与群组的关系删除)
+(void)requestQuitGroup:(NSString *)groupUuid groupName:(NSString*)groupName Block:(void(^)(long status))block{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:groupName forKey:@"group_name"];
    NSString *s = [NSString stringWithFormat:@"/api/v1/group/%@/quit/",groupUuid];
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (block) {
            block(httpResponse.statusCode);
        }
        //退出成功 从本地删除此群组
        [WYGroup removeGroupInGroups:groupUuid];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (block) {
            block(httpResponse.statusCode);
        }
    }];
}

//新建群组(添加群组到本地的时候 有将用户与群组的关系保存到本地)
+ (void)addNewGroupWith:(NSString *)name ImageWith:(PHAsset *)asset groupIntroduction:(NSString *)introduction callback:(void (^)(WYGroup *group,NSInteger status))cb{

    NSString *uuid = [[NSUUID UUID] UUIDString];
    uuid = [uuid lowercaseString];
    NSString *qiniuKey = [@"g-icon-" stringByAppendingString:uuid];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [[PHImageManager defaultManager] requestImageDataForAsset: asset options: options resultHandler: ^(NSData * imageData, NSString * dataUTI, UIImageOrientation orientation, NSDictionary * info) {
        
        UIImage *image = [UIImage imageWithData:imageData];
        [WYQiniuApi uploadUIImage:image ForKey:qiniuKey WithBlock:^(NSString *key) {
            if(key &&(name.length>0)){
                NSMutableDictionary *md = [NSMutableDictionary dictionary];
                [md setObject:name forKey:@"name"];
                [md setObject:key forKey:@"icon_url_key"];
                [md setObject:introduction forKey:@"introduction"];
                //如果基本信息完整 建群
                [[WYHttpClient sharedClient] POST:@"api/v1/group/" parameters:md progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    WYGroup *group = [WYGroup yy_modelWithDictionary:responseObject];
                    
                    //将这个群组保存到本地
                    //新建群组需要保存
                    [WYGroup insertGroup:group];
                    
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                    
                    if(cb) {
                        cb(group,httpResponse.statusCode);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                    
                    
                    if(cb) {
                        cb(nil,httpResponse.statusCode);
                    }
                }];
            }else{
                // 400+ 这个时候一般是用户没有网络导致没有上传成功 408
                NSInteger status = 408;
                if(cb) {
                    cb(nil,status);
                }
            }
            
        }];
    }];
}

//创建群组 不用上传请求key
+ (void)addNewGroupWith:(NSString *)name dict:(NSDictionary *)dic groupIntroduction:(NSString *)introduction callback:(void (^)(WYGroup *group,NSInteger status))cb{
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setObject:name forKey:@"name"];
    [md setObject:[dic objectForKey:@"qiniu_key"] forKey:@"icon_url_key"];
    [md setObject:introduction forKey:@"introduction"];

    //如果基本信息完整 建群
    [[WYHttpClient sharedClient] POST:@"api/v1/group/" parameters:md progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WYGroup *group = [WYGroup yy_modelWithDictionary:responseObject];
        
        //将这个群组保存到本地
        //新建群组需要保存
        [WYGroup insertGroup:group];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if(cb) {
            cb(group,httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        
        if(cb) {
            cb(nil,httpResponse.statusCode);
        }
    }];

}

//更换群头像 然后将group更新到本地changeGroupDetail内
+ (void)changeGroup:(NSString *)groupUuid ImageWith:(PHAsset *)asset callback:(void (^)(WYGroup *group))cb{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    uuid = [uuid lowercaseString];
    NSString *qiniuKey = [@"g-icon-" stringByAppendingString:uuid];

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        [WYQiniuApi uploadUIImage:image ForKey:qiniuKey WithBlock:^(NSString *key) {
            if(key)
            {
                NSDictionary *parameters = @{@"icon_url_key": key};
                [WYGroupApi changeGroupDetail:groupUuid dic:parameters Block:^(WYGroup *group) {
                    if (cb) {
                        cb(group);
                    }
                }];
            }
            else
            {
                if(cb) {
                    cb(nil);
                }
            }
            
        }];

    }];
}

//管理员修改群资料 包括头像(必须先有key) 名称 介绍 以及对群组bool类型的设置 然后将group更新到本地
+ (void)changeGroupDetail:(NSString*)groupUuid dic:(NSDictionary*)dic Block:(void(^)(WYGroup *group))block{
    [[WYHttpClient sharedClient] PATCH:[NSString stringWithFormat:@"/api/v1/group/%@/", groupUuid]
                            parameters:dic
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   
                                   WYGroup *group = [WYGroup yy_modelWithDictionary:responseObject];
                                   //将这个群组替换到本地
                                   //修改群组需要保存
                                   [WYGroup insertGroup:group];
                                   if(block) {
                                       block(group);
                                   }
                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                   debugLog(@"%lu",httpResponse.statusCode);
                                   
                                   if(block) {
                                       block(nil);
                                   }
                               }];
    
}

+ (void)searchGroupFromNumer:(NSString *)groupNumberStr Token:(NSString *)token Block:(void(^)(WYGroup *group))block
{
    [[WYHttpClient sharedClient] GET:@"api/v1/group/search_by_number/" parameters:@{@"number": groupNumberStr, @"token":token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //group list returned array, not results, since it is not paginated
        NSArray *data = responseObject;
        
        if(data.count > 0)
        {
            NSArray *groupArray = [NSArray yy_modelArrayWithClass:[WYGroup class] json:data];
            if(block)
                block([groupArray firstObject]);
        }
        else
        {
            if(block)
                block(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(block)
            block(nil);
        
    }];
    
}
//请求移除群成员(有本地将用户与群组的关系移除)
+ (void)removeGroupMember:(NSString*)groupUuid RemoveList:(NSArray *)removeList Block:(void(^)(NSArray *removedArr, NSArray*notInGroupArr))block{
    NSString *s = [NSString stringWithFormat:@"/api/v1/group/%@/remove/",groupUuid];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:removeList forKey:@"user_list"];
    
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //数组中成员是字典 两个键值对name uuid
        NSArray *removedArr = [responseObject objectForKey:@"success_list"];
        NSArray *notInGroupArr = [responseObject objectForKey:@"not_in_group_list"];
        
        //成功就将 这些群成员和群组的关系删除掉
        for (NSDictionary*dic in removedArr) {
            NSString * userUuid = [dic objectForKey:@"uuid"];
            [WYGroup removeGroupToUser:groupUuid UserUuid:userUuid];
        }
        if(block) {
            block(removedArr, notInGroupArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(block) {
            block(nil,nil);
        }
    }];
}

//举报群组
+(void)reportGroup:(NSString *)groupUuid type:(NSNumber*)type Block:(void(^)(long status))block{
    NSString *s = [NSString stringWithFormat:@"/api/v1/group/%@/report/",groupUuid];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:type forKey:@"type"];
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (block) {
            block(httpResponse.statusCode);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (block) {
            block(httpResponse.statusCode);
        }
        
    }];
    
}

//转让管理员
+(void)transferAdmin:(NSString*)groupUuid userUuid:(NSString*)userUuid Block:(void(^)(WYGroup *group))block{
    NSString *s = [NSString stringWithFormat:@"/api/v1/group/%@/transfer_group_admin/",groupUuid];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:userUuid forKey:@"transfer_member_uuid"];
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *info = [responseObject valueForKey:@"group"];
        WYGroup *group = [WYGroup yy_modelWithDictionary:info];
        //将这个群组替换到本地
        //修改群组需要保存
        [WYGroup insertGroup:group];
        if(block) {
            block(group);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (block) {
            block(nil);
        }
        
    }];
    
}

+ (void)requestJoinGroup:(NSString *)uuid comment:(NSString*)comment callback:(void (^)(BOOL success))block{
    NSString *url = [NSString stringWithFormat:@"api/v1/group/%@/apply_to_join/",uuid];
    NSDictionary *dic = @{
                          @"comment":comment
                          };
    [[WYHttpClient sharedClient] POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //无返回值        debugLog(@"===========%@",responseObject);
        if(block) {
            block(YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block) {
            block(NO);
        }
    }];
}

//通过群链接邀请
+(void)requestGroupLink:(NSString *)groupUuid Block:(void(^)(NSString *s))block{
    NSString *s = [NSString stringWithFormat:@"/api/v1/get_web_invitation_link_for_group/"];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:groupUuid forKey:@"group"];
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *url = [responseObject objectForKey:@"url"];
        if (block) {
            block(url);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//群组后台头像
+(void)listGroupIconsArrPage:(NSInteger)page Block:(void(^)(NSArray *dicArr,BOOL hasMore))block{
    NSString *s = [NSString stringWithFormat:@"/api/v1/default_group_icons/"];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dicArr = [responseObject objectForKey:@"results"];
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        debugLog(@"=======%@",responseObject);
        if (block) {
            block(dicArr,hasMore);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}
@end
