//
//  WYPublishAddTagsTool.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPublishAddTagsTool.h"
#import "WYTag.h"

@implementation WYPublishAddTagsTool
//检查是否有重复的字符串 type addTagOfTypePublish
+(BOOL)strIsRepeated:(NSString *)str arr:(NSArray *)arr;{
    
    //内部 是异步  外部是同步
    for (id temp in arr) {
        if ([temp isKindOfClass:[WYTag class]]) {
            if ([((WYTag*)temp).tag_name isEqualToString:str]) {
                return YES;
            }
        }else{
            if ([temp isEqualToString:str]) {
                return YES;
            }
        }
    }
    return NO;
}
@end
