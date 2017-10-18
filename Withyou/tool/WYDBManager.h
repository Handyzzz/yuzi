//
//  WYDBManager.h
//  Withyou
//
//  Created by Tong Lu on 16/8/17.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface WYDBManager : NSObject

+(WYDBManager*)getSharedInstance;
+(NSString *)getDatabasePath;
- (FMDatabaseQueue *)sharedQueue;

//do not use it if not necessary
//+ (void)removeDatabase;

+ (BOOL)executeTransactionWith:(NSString *)sql Arguments:(NSArray *)array;
- (void)createTablesAndUpdateToNewestVersion;

@end
