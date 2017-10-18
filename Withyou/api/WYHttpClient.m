//
//  WYHttpClient.m
//  Withyou
//
//  Created by Tong Lu on 2016/10/9.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYHttpClient.h"
#import "YZToastView.h"
#import <YYModel/YYModel.h>

@implementation WYHttpClient

+ (instancetype)sharedClientBeforeToken {
    static WYHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url=[NSURL URLWithString:kBaseURL];
        _sharedClient = [[WYHttpClient alloc] initWithBaseURL:url];
        _sharedClient.securityPolicy = [AFSecurityPolicy defaultPolicy];
        
//        [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        //system will find it automatically
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"1_ditushuo.me_bundle" ofType:@"cer"];
//        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
//        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
//        _sharedClient.securityPolicy.pinnedCertificates = certSet;
        
        _sharedClient.securityPolicy.allowInvalidCertificates = YES;
        _sharedClient.securityPolicy.validatesDomainName = NO;
    
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];

    });
    return _sharedClient;
}

+ (instancetype)sharedClient {
    NSString *auth = [@"Token " stringByAppendingString:kToken];
    [[WYHttpClient sharedClientBeforeToken].requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    return [WYHttpClient sharedClientBeforeToken];
}

- (void)GET:(NSString *)URLString parameters:(id)parameters showToastError:(BOOL)showError callback:(void (^)(id))callback {
    [super GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(callback){
            callback(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"============== network error ============= \n %@",error);
        if(callback) {
            callback(nil);
        }
        if(showError) {
            NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
            [WYHttpClient handleNetworkError:statusCode];
        }
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters showToastError:(BOOL)showError callback:(void (^)(id))callback {
    [super POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(callback) {
            callback(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"============== network error ============= \n %@",error);
        if(callback) {
            callback(nil);
        }
        if(showError) {
            NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
            [WYHttpClient handleNetworkError:statusCode];
        }
    }];
}

- (void)GETModelWithKey:(NSString *)key forClass:(Class)ModelClass url:(NSString *)URLString parameters:(id)parameters callback:(void (^)(id, id))callback  {
    [self GET:URLString parameters:parameters showToastError:YES callback:^(id responseObject) {
        id  obj = [WYHttpClient transformJSONToModel:key class:ModelClass JSON:responseObject];
        if(callback) {
            callback(obj,responseObject);
        }
    }];
}

- (void)GETModelArrayWithKey:(NSString *)key forClass:(Class)ModelClass
                         url:(NSString *)URLString
                  parameters:(id)parameters
                    callback:(void (^)(NSArray *,id))callback {
    [self GET:URLString parameters:parameters showToastError:YES callback:^(id responseObject) {

        id  obj = [WYHttpClient transformJSONToModel:key class:ModelClass JSON:responseObject];
        if(callback) {
            if([obj isKindOfClass:[NSArray class]] == YES) {
                callback(obj,responseObject);
            }else {
                callback(@[],responseObject);
            }
        }
    }];
}

- (void)POSTModelWithKey:(NSString *)key forClass:(Class)ModelClass url:(NSString *)URLString parameters:(id)parameters callback:(void (^)(id, id))callback {
    [self POST:URLString parameters:parameters showToastError:YES callback:^(id responseObject) {
        id  obj = [WYHttpClient transformJSONToModel:key class:ModelClass JSON:responseObject];
        if(callback) {
            callback(obj,responseObject);
        }
    }];
}

- (void)POSTModelArrayWithKey:(NSString *)key forClass:(Class)ModelClass url:(NSString *)URLString parameters:(id)parameters callback:(void (^)(NSArray *, id))callback {
    [self POST:URLString parameters:parameters showToastError:YES callback:^(id responseObject) {
        id  obj = [WYHttpClient transformJSONToModel:key class:ModelClass JSON:responseObject];
        if(callback) {
            if([obj isKindOfClass:[NSArray class]] == YES) {
                callback(obj,responseObject);
            }else {
                callback(@[],responseObject);
            }
        }
    }];
}



#pragma mark - private method
// json to model
+ (id)transformJSONToModel:(NSString *)key class:(Class)ModelClass JSON:(id)json {
    if(json == nil || ModelClass == nil) return nil;
    id  obj = nil;
    id result = json;
    // 如果json 是一个字典 且key 有值 那么对应的就是期望的值
    if([json isKindOfClass:[NSDictionary class]] == YES && key != nil) {
        result = json[key];
    }
    // 如果是dictionary 就转成一个对象  如果是NSArry 那么就转成数组
    if([result isKindOfClass:[NSDictionary class]] == YES) {
        obj = [ModelClass yy_modelWithDictionary:result];
    }else if([result isKindOfClass:[NSArray class]] == YES) {
        obj = [NSArray yy_modelArrayWithClass:ModelClass json:result];
    }else {
        WYLog(@"%@  json to model erro \n json: %@",NSStringFromSelector(_cmd),json);
    }
    return obj;
}

+ (void)handleNetworkError:(NSInteger)statusCode {
    NSString *toastText = @"网络请求失败";
    if(statusCode == 0) {
        toastText = @"未能连接到互联网,请检查网络状态";
    }else if(statusCode >= 400) {
        toastText = [NSString stringWithFormat:@"服务器开小差了: %ld,请稍后再试",statusCode];
    }
    [YZToastView showToastWithTitle:toastText];

}


@end
