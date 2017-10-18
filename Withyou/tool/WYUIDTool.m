//
//  WYUIDTool.m
//  Withyou
//
//  Created by hongfei on 14-5-28.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#define kCurrentUidDataFile @"currentuid.data"

#define kCurrentUIDPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:kCurrentUidDataFile]

#import "WYUIDTool.h"
//#import "DBManager.h"


@interface WYUIDTool()

@end

@implementation WYUIDTool

singleton_implementation(WYUIDTool)

- (id)init
{
    if (self = [super init]) {
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:kCurrentUIDPath];
        if(fileExists)
        {
            @try {
                self.uid = [NSKeyedUnarchiver unarchiveObjectWithFile:kCurrentUIDPath];
            }
            @catch (NSException * e) {
                [self removeUID];

            }
            @finally {
                
            }
            
        }
        else
        {
            [self setEmptyUID];
        }
    }
    return self;
}

#pragma mark 归档保存账号
- (void)addUID:(WYUID *)uid
{
    self.uid = uid;
    
    [NSKeyedArchiver archiveRootObject:self.uid toFile:kCurrentUIDPath];
}

- (void)setEmptyUID
{
    WYUID *uid = [[WYUID alloc] init];
    self.uid = uid;
    [NSKeyedArchiver archiveRootObject:self.uid toFile:kCurrentUIDPath];
}

- (void)removeUID
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL state = [fileManager removeItemAtPath:kCurrentUIDPath error:&error];
    if (state) {
        NSLog(@"deleted file of %@", kCurrentUIDPath);
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

- (BOOL)isLoggedIn
{
    if (self.uid.token && ![self.uid.token isEqualToString:@""])
    {
        return true;
    }
    else
    {
        return false;
    }
}


@end
