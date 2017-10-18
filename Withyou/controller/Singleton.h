//
//  Singleton.h
//  TheHardestGame
//
//  Created by 王小飞您 on 13-8-18.
//  Copyright (c) 2013年 wangxiaofei. All rights reserved.
//

//@interface
#define singleton_interface(className) \
+ (className *)shared##className;

//@implementation
#define singleton_implementation(className) \
static className *_instance;\
+ (id)allocWithZone:(NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
+ (className *)shared##className\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc] init];\
    });\
    return _instance;\
}
