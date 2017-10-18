//
//  NSString+WYStringEx.h
//  Withyou
//
//  Created by jialei on 14-4-30.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WYStringEx)
//将字符串转换成带行距的字符串
-(NSAttributedString *)TransToAttributeStrWithLineSpace:(NSInteger )lineSpace;
//字体正常排列无间距
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize minimumLineHeight:(CGFloat)minimumLineHeight;
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
+ (CGSize)getStringRect:(NSString*)aString stringInSize:(CGSize)scope font:(UIFont *)font;
+ (NSString *)md5:(NSString *) input;
+ (NSString *)stringFromTimeInt:(int)createdAt;
+ (NSString *)stringFromTimeIntShowHourMinute:(int)createdAt;
+ (NSString *)stringFromTimeIntShowHourMinuteOfSevenDays:(int)createdAt;
// 持续时间 110:00
+ (NSString *)stringFromDuration:(int)duration;

+ (BOOL)passUsernameCheckAtAppSide:(NSString *)name;
+ (NSString *)smallerQiNiuUrlFrom:(NSString *)originalUrl;
+ (NSString *)smallerQiNiuUrlFrom:(NSString *)originalUrl Width:(int)width Height:(int)height;

+ (NSString *)stringWithCreatedAt:(double)createdAt;

+ (UIFont *)smallLabelFont;
+ (NSString *)getDistanceFromHereToLat:(float)lat Lng:(float)lng;

+ (NSNumber *)twoDigitNumberWithRawFloat:(float)number;
+ (BOOL)checkStringOnlyAscii:(NSString *)str;
+ (BOOL)hasUnicodeCharacters:(NSString *)str;
// number => string  最多显示 xx+
+ (NSString *)getNumberStringWith:(int)count andMaxNumber:(int)max;
+ (NSString *)getWorldCountLabel:(int)count;
// 获取拼音首字母
+ (NSString *) pinyinFirstLetter:(NSString*)sourceString;

//后端返回 {"name": "XXX", "uuid": "XXXX"}
//解析后变成为 @"name1, name2, name3"
+ (NSString *)nameStringsFromBackendDictOfInviteResult:(NSArray *)arr;

//escapedURL
- (NSURL *)escapedURL;

//将中文转换为没有音调的拼音
-(NSString *)chChangePin;

@end
