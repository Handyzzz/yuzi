//
//  WYQiniuApi.m
//  Withyou
//
//  Created by Tong Lu on 2016/10/9.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYQiniuApi.h"
#import "WYHttpClient.h"
#import "QNUploadManager.h"
#import "UIImage+WYUtils.h"

@implementation WYQiniuApi

static NSString *userDefaultsPrivateQiniuKey = @"qiNiuPrivateUpToken";


+ (void)uploadPHAsset:(PHAsset *)asset ForKey:(NSString *)key Token:(NSString *)token complete:(UploadCompleteHandler)handler
{
    NSString *finalKey = nil;
    if(key)
        finalKey = key;
    else
    {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        uuid = [uuid lowercaseString];
        finalKey = [@"p-" stringByAppendingString:uuid];
    }
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putPHAsset:asset key:finalKey  token:token
                 complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                     
//                     NSLog(@"response info is %@, key is %@, resp %@", info, key, resp);
                     
                     if (resp)
                     {
                         if (handler)
                             handler(key);
                     }
                     else
                     {
                         if (handler)
                             handler(nil);
                     }
                 }
     
                   option:nil];

}
+ (void)uploadPHAsset:(PHAsset *)asset ForKey:(NSString *)key complete:(UploadCompleteHandler)handler
{
    NSString *finalKey = nil;
    if(key)
        finalKey = key;
    else
    {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        uuid = [uuid lowercaseString];
        finalKey = [@"p-" stringByAppendingString:uuid];
    }
    
    [[self class] getQiniuUpTokenWithBlock:^(NSString *token){
        [[self class] uploadPHAsset:asset ForKey:finalKey Token:token complete:^(NSString *key) {
            if (handler)
                handler(key);
        }];
    }];
}
+ (void)uploadPrivatePHAsset:(PHAsset *)asset ForKey:(NSString *)key complete:(UploadCompleteHandler)handler
{
    NSString *finalKey = nil;
    if(key)
        finalKey = key;
    else {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        uuid = [uuid lowercaseString];
        finalKey = [@"p-" stringByAppendingString:uuid];
    }
    [[self class] getPrivateQiniuUpTokenWithBlock:^(NSString *token){
        [[self class] uploadPHAsset:asset ForKey:finalKey Token:token complete:^(NSString *key) {
            if (handler)
                handler(key);
        }];
    }];
}
+ (void)getPrivateQiniuUpTokenWithBlock:(void (^)(NSString *token))block
{
    // check NSDefaults FIRST
    // if not expired, use the old one
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsPrivateQiniuKey];
    if(dict){
        NSString *token = [dict objectForKey:@"private_up_token"];
        NSNumber *expireSeconds = [dict objectForKey:@"expire_seconds"];
        NSNumber *createdAt = [dict objectForKey:@"created_at_int"];
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        
        //10分钟来上传图片，应该够了
        BOOL leftTimeIsEnough = [expireSeconds intValue] + [createdAt intValue] > ceil(timeStamp) + 600;
        if(token && leftTimeIsEnough){
            if(block)
                block(token);
        }
        else{
            [[self class] requestFromBackendPrivateQiniuUpTokenWithBlock:^(NSString *token) {
                if(block)
                    block(token);
            }];
        }
    }
    else{
        [[self class] requestFromBackendPrivateQiniuUpTokenWithBlock:^(NSString *token) {
            if(block)
                block(token);
        }];
    }
}
+ (void)requestFromBackendPrivateQiniuUpTokenWithBlock:(void (^)(NSString *token))block
{
    [[WYHttpClient sharedClient] GET:@"api/v1/private_up_token/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *token = [responseObject objectForKey:@"private_up_token"];
        
        if(token){
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:userDefaultsPrivateQiniuKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"private token upload requested is %@", token);
            
            if(block)
                block(token);
        }
        else{
            if(block)
                block(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block)
            block(nil);
    }];
}
+ (void)getQiniuUpTokenWithBlock:(void (^)(NSString *token))block
{
    static NSString *userDefaultsQiniuKey = @"qiNiuUpToken";
    
    // check NSDefaults FIRST
    // if not expired, use the old one
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsQiniuKey];
    if(dict)
    {
        NSString *token = [dict objectForKey:@"up_token"];
        NSNumber *expireSeconds = [dict objectForKey:@"expire_seconds"];
        NSNumber *createdAt = [dict objectForKey:@"created_at_int"];
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        
        if([expireSeconds intValue] + [createdAt intValue] > ceil(timeStamp) + 3600 )
        {
            //一张图片要十秒，但是多张图片，可以预留一小时，现在的后端给出的有效期是一周
            
            if(token){
                
                if(block)
                    block(token);
                
//                NSLog(@"token upload local is %@", token);
                return;
            }
            
        }
    }
    
    [[WYHttpClient sharedClient] GET:@"api/v1/up_token/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *token = [responseObject objectForKey:@"up_token"];
        if(token){
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:userDefaultsQiniuKey];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSLog(@"token upload requested is %@", token);
            
            if(block)
                block(token);
        }
        else{
            if(block)
                block(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(block)
            block(nil);
    }];

}

+ (void)uploadUIImage:(UIImage *)image ForKey:(NSString *)key WithBlock:(void (^)(NSString *key))block
{
    NSData *pngData = UIImageJPEGRepresentation(image, 0.9);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *finalKey = nil;
        if(key){
            finalKey = key;
        }else{
            NSString *uuid = [[NSUUID UUID] UUIDString];
            uuid = [uuid lowercaseString];
            finalKey = [@"p-" stringByAppendingString:uuid];
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"tempFileName%@",finalKey]];
        [pngData writeToFile:filePath atomically:YES]; // Write the file
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self class] uploadFileAtPath:filePath ForKey:finalKey complete:^(NSString *key) {
                if(block)
                    block(key);
                [UIImage  removeImage:filePath];
                if(!key)
                    [OMGToast showWithText:@"图片上传未成功, 请稍后再试"];
            }];
        });
    });
}

+ (void)uploadFileAtPath:(NSString *)filePath ForKey:(NSString *)key complete:(UploadCompleteHandler)handler{
    
    [[self class] getQiniuUpTokenWithBlock:^(NSString *token){
        if(!token)
        {
            [OMGToast showWithText:@"照片暂时无法上传，请稍后再试"];
            return;
        }
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        [upManager putData:data key:key  token:token
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      if (info.ok) {
                          handler(key);
                      }
        }option:nil];
    }];
}

@end
