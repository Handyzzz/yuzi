//
//  WYFileManager.m
//  Withyou
//
//  Created by Tong Lu on 9/30/14.
//  Copyright (c) 2014 Withyou Inc. All rights reserved.
//

#import "WYFileManager.h"

@implementation WYFileManager

+ (void)writeDict:(NSDictionary *)dict ToCacheFile:(NSString *)file
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 写入文件缓存
        if (file!=nil) {
            //Due to null values may be in dictionary, it cannot be written in the file
            NSError *error = nil;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
            BOOL success = [data writeToFile:kCachesPath(file) options:NSDataWritingAtomic error:&error];
            NSLog(@"!!! cached to file %@, success %d, error %@", kCachesPath(file), success, error);
        }
    });
}

- (void)loadCaches:(NSString *)file WithClass:(NSString *)className WithDictKey:(NSString *)key
{
    NSError *error;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:kCachesPath(file)];
    
    if (!fileExists) {
        NSLog(@"file not exist, start waiting for location update, and then refresh");
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:kCachesPath(file) options:NSDataReadingMapped error:&error];
    if (error) {
        NSLog(@"nsdata error %@", error);
        return;
    }
    
    NSDictionary *dic = nil;
    
    @try {
        dic = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (id exception) {
        NSLog(@"NSKeyedUnarchiver failed with fatal error %@", exception);
    }
    @finally {
        
    }
    

    
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (!dic) {
        NSLog(@"no dict, but still has to wait for location update, then refesh");
        return;
    }else{
        NSLog(@"in cache loading");
    }
    
    // 解析缓存文件
//    NSMutableArray *array = [NSMutableArray array];    
//    Class classFromString = NSClassFromString(className);
//    
//    for (NSDictionary *dict in [dic objectForKey:key]) {
//        classFromString *message = [[classFromString alloc] initWithDict:dict];
//        WYBaseFrame *frame = [[WYBaseFrame alloc] init];
//        frame.WYMessage = message;
//        [array addObject:frame];
//    }
//    
//    [_allFrame addObjectsFromArray:array];
//    NSLog(@"cached array added");
//    [_tableView reloadData];
    
}

@end
