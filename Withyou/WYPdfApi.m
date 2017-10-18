//
//  WYPdfApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPdfApi.h"

@implementation WYPdfApi
+(void)listAllSelfPdfs:(NSInteger)page Block:(void(^)(NSArray *pdfsArr,BOOL hasMore))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/pdfs/?page=%ld",page];
    [[WYHttpClient sharedClient]GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *pdfs = [YZPdf YYModelParse:[responseObject objectForKey:@"results"]];
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        if (block) {
            block(pdfs,hasMore);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}
@end
