//
//  WYHttpClient.h
//  Withyou
//
//  Created by Tong Lu on 2016/10/9.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <YYModel/YYModel.h>


@interface WYHttpClient : AFHTTPSessionManager

+ (instancetype)sharedClient;




/*
    额外的需求 使用父类的方法即可 即AFNetworking
    @parameter showToastError 是否显示失败toast
    以下方法在AF的基础上做了些精简, 默认请求成功或者失败 都会调用callback  成功时有值,失败时为nil
 */
- (void)GET:(NSString *)URLString
                        parameters:(id)parameters
                    showToastError:(BOOL)showError
                          callback:(void (^)(id responseObject))callback;


- (void)POST:(NSString *)URLString
                        parameters:(id)parameters
                    showToastError:(BOOL)showError
                          callback:(void (^)(id responseObject))callback;


// 数据转模型的网络请求方法

/*
 @parameter key : 返回数据 对应转模型的key  如果key 为nil  默认转换整个response
 @parameter className: 需要转成的模型类名
 @parameter callback: 回调block  成果会返回对象和服务器数据  失败返回 nil (注意:  如果服务器的数据有问题 那么返回的是一个对象,但可能某些属性值为nil)
 
 默认失败会显示 提示网络失败的toast
 
 example :
 // 服务器传入
 response = {
 
    next: 'url',
    results: [obj,obj],
 }

 // callback 回调参数
 modelArray = [obj,obj];
 response = {
    next: 'url',
    results: [obj,obj],
 }
 
 
 
 [[WYHttpClient sharedClient] GETModelArrayWithKey:@"results" forClass:[YZPostComment class] url:url parameters:param callback:^(NSArray *modelArray, id response) {
        BOOL hasMore = response[@"next"] != [NSNull null];
        if(block) {
            block(modelArray,hasMore);
        }
 }];
 
 */

- (void)GETModelWithKey:(NSString *)key forClass:(Class)ModelClass
                                      url:(NSString *)URLString
                               parameters:(id)parameters
                     callback:(void (^)(id model ,id response))callback;


- (void)GETModelArrayWithKey:(NSString *)key forClass:(Class)ModelClass
                                      url:(NSString *)URLString
                               parameters:(id)parameters
                                 callback:(void (^)(NSArray *modelArray,id response))callback;


- (void)POSTModelWithKey:(NSString *)key forClass:(Class)ModelClass
                    url:(NSString *)URLString
             parameters:(id)parameters
               callback:(void (^)(id model ,id response))callback;


- (void)POSTModelArrayWithKey:(NSString *)key forClass:(Class)ModelClass
                         url:(NSString *)URLString
                  parameters:(id)parameters
                    callback:(void (^)(NSArray *modelArray,id response))callback;


@end
