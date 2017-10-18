//
//  WYFileManager.h
//  Withyou
//
//  Created by Tong Lu on 9/30/14.
//  Copyright (c) 2014 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYFileManager : NSObject

+ (void)writeDict:(NSDictionary *)dict ToCacheFile:(NSString *)file;

@end
