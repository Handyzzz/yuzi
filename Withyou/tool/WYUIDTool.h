//
//  WYUIDTool.h
//  Withyou
//
//  Created by hongfei on 14-5-28.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "WYUID.h"

//@class WYUID;

@interface WYUIDTool : NSObject

singleton_interface(WYUIDTool)

@property (nonatomic, copy) WYUID *uid;

- (void)addUID:(WYUID *)uid;
- (void)setEmptyUID;
- (void)removeUID;
- (BOOL)isLoggedIn;

@end
