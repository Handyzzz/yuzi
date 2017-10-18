//
//  WYPdfApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYPdfApi : NSObject
//用上一页的next作为下一页的页面参数 null - > 0
+(void)listAllSelfPdfs:(NSInteger)page Block:(void(^)(NSArray *pdfsArr,BOOL hasMore))block;

@end
