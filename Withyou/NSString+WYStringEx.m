//
//  NSString+WYStringEx.m
//  Withyou
//
//  Created by jialei on 14-4-30.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import "NSString+WYStringEx.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (WYStringEx)
//将字符串转换成带行距的字符串
-(NSAttributedString *)TransToAttributeStrWithLineSpace:(NSInteger )lineSpace{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    
    return attributedString;
}
+ (NSString *) pinyinFirstLetter:(NSString*)sourceString {
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSString *letter;
    if ([source uppercaseString].length > 0) {
        letter = [[source uppercaseString] substringToIndex:1];
    }else{
        letter = nil;
    }
    if(letter == nil) {
        return @"#";
    }
    // 判断是否是字母
    NSString *regex = @"^[A-Z]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([predicate evaluateWithObject:letter] == YES){
        return letter;
    }else {
        return @"#";
    }
}

 
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize minimumLineHeight:(CGFloat)minimumLineHeight{
    
    CGSize size;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    if (minimumLineHeight > 0) {
        //设置行间距
        [paragraph setLineSpacing:minimumLineHeight];
    }else{
        //do nothing
    }
    //字间距,NSKernAttributeName:@(characterSpacing)
    NSDictionary *attribute = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraph};
    size = [self boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    return  size;
}

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    
    CGSize size;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [self boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return  size;
}

+ (CGSize)getStringRect:(NSString*)aString stringInSize:(CGSize)scope font:(UIFont *)font
{
    CGSize size;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.minimumLineHeight = kContentLineSpacing;
    paragraph.maximumLineHeight = kContentLineSpacing;
    
    NSDictionary *attribute = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraph};
    size = [aString boundingRectWithSize:scope  options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    return  size;
}

+ (NSString *)getWorldCountLabel:(int)count {
    if(count <= 0) {
        return @"";
    }else if(count < 100) {
        return [NSString stringWithFormat:@"%d",count];
    }else if (count < 1000) {
        return [NSString stringWithFormat:@"%d百",(int)(count/100)];
    }else if (count < 10000) {
        return [NSString stringWithFormat:@"%d千",(int)(count/1000)];
    }else {
        return [NSString stringWithFormat:@"%d万+",(int)(count/10000)];
    }
}

+ (NSString *)getNumberStringWith:(int)count andMaxNumber:(int)max {
    if(count <= max) {
        return [NSString stringWithFormat:@"%d",count];
    }else {
        return [NSString stringWithFormat:@"%d+",max];
    }
}

//+ (CGFloat)getHeightOfAttributedString:(NSAttributedString *)aString width:(CGFloat)width font:(UIFont *)font
//{
//    
//    return 80.0;
//}

+ (NSString *)md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

+ (NSString *)stringFromTimeInt:(int)createdAt
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
    NSDate *now = [NSDate date];
    
    // 时间间隔 (秒) NSTimeInterval double
    NSTimeInterval delta = [now timeIntervalSinceDate:date];
    
    if (delta < 60 * 60 * 24 * 365) {  // 一年内
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM.dd"];
        NSString *showtime = [formatter stringFromDate:date];
        return showtime;
        
    }
    else {    // 显示完整时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YY.MM.dd"];
        NSString *showtime = [formatter stringFromDate:date];
        return showtime;
    }
}

+ (NSString *)stringWithCreatedAt:(double)createdAt
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
    NSDate *now = [NSDate date];
    
    // 时间间隔 (秒) NSTimeInterval double
    NSTimeInterval delta = [now timeIntervalSinceDate:date];
    
    if (delta < 60 ) {  // 1分钟内
        return @"刚刚";
    }
    else if (delta < 60 * 60) {   // 一小时内
        return [NSString stringWithFormat:@"%.f分钟前", delta/60 + 1];
    }
    else if (delta < 60 * 60 * 24) {  // 一天内
        return [NSString stringWithFormat:@"%.f小时前", delta/(60 * 60) + 1];
    }
    else if (delta < 60 * 60 * 24 * 2) {  // 2天内
        //        return [NSString stringWithFormat:@"%.f天前", delta/(60 * 60 * 24)];
        return [NSString stringWithFormat:@"%.f小时前", delta/(60 * 60) + 1];
        
    }
    else if (delta < 60 * 60 * 24 * 365) {  // 一年内
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM.dd HH:mm"];
        NSString *showtime = [formatter stringFromDate:date];
        return showtime;
    }
    else {    // 显示完整时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YY.MM.dd HH:mm"];
        NSString *showtime = [formatter stringFromDate:date];
        return showtime;
    }
}
+ (NSString *)stringFromTimeIntShowHourMinute:(int)createdAt
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
    NSDate *now = [NSDate date];
    
    // 时间间隔 (秒) NSTimeInterval double
    NSTimeInterval delta = [now timeIntervalSinceDate:date];
    
    if (delta < 60 * 60 * 24 * 30) {  // 30天内
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM.dd HH:mm"];
        NSString *showtime = [formatter stringFromDate:date];
        return showtime;
        
    }
    else {    // 显示日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY.MM.dd"];
        NSString *showtime = [formatter stringFromDate:date];
        return showtime;
    }
}
+ (NSString *)stringFromTimeIntShowHourMinuteOfSevenDays:(int)createdAt
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
    NSDate *now = [NSDate date];
    
    // 时间间隔 (秒) NSTimeInterval double
    NSTimeInterval delta = [now timeIntervalSinceDate:date];
    
    if (delta < 60 * 60 * 24 * 1) {  // 30天内
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *showtime = [formatter stringFromDate:date];
        return showtime;

    }
    else if (delta < 60 * 60 * 24 * 7) {  // 7天内
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE HH:mm"];
        NSString *showtime = [formatter stringFromDate:date];
        return showtime;

        
    }
    else if (delta < 60 * 60 * 24 * 30) {  // 30天内
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM.dd"];
        NSString *showtime = [formatter stringFromDate:date];
        return showtime;
        
    }
    else {    // 显示日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY.MM.dd"];
        NSString *showtime = [formatter stringFromDate:date];
        return showtime;
    }
}

+ (NSString *)stringFromDuration:(int)duration {
    if (duration > 0) {
        int second = duration % 60;
        int minute = duration / 60;
        //如果小于9 就加0
        NSString *s;
        if (second >=0 && second <= 9 ) {
            s = [NSString stringWithFormat:@"0%d",second];
        }else{
            s = [NSString stringWithFormat:@"%d",second];
        }
        NSString *m;
        if (minute >= 0 && minute <= 9) {
            m = [NSString stringWithFormat:@"0%d",minute];

        }else{
            m = [NSString stringWithFormat:@"0%d",minute];

        }
        return [NSString stringWithFormat:@"%@:%@",m, s];

    }
    return @"00:00";
}

+ (BOOL)passUsernameCheckAtAppSide:(NSString *)name
{
    //todo, lowercase, how many character, ascii, bad words
    
    //lower case, ascii
    NSCharacterSet *lowerCaseLetters = [NSCharacterSet lowercaseLetterCharacterSet];
    NSCharacterSet *upperCaseLetters = [NSCharacterSet uppercaseLetterCharacterSet];
    for (int i=0; i < name.length; i++) {
        if (![lowerCaseLetters characterIsMember:[name characterAtIndex:i]] && ![upperCaseLetters characterIsMember:[name characterAtIndex:i]]) {
            return false;
        }
    }
    
    //lte 30, gte 3
    if (name.length > 16 || name.length < 4) {
        return false;
    }
    
    //bad words list
    NSString *badwordsFilePath = [[NSBundle mainBundle] pathForResource:@"badwords4" ofType:@"txt"];
    NSError *error;
    NSString *badwordsFile = [[NSString alloc] initWithContentsOfFile:badwordsFilePath encoding:NSUTF8StringEncoding error:&error];
    NSArray *badwords = [badwordsFile componentsSeparatedByString:@"\n"];
    NSLog(@"first is %@, err is %@", badwords[0], error);
    
    for (NSString* badword in badwords) {
//        NSLog(@"checked %@", badword);
        
        if ([name isEqualToString:badword]) {
            NSLog(@"equaled word %@", badword);
            
            return false;
        }
    }
    
    return true;
}
+ (NSString *)smallerQiNiuUrlFrom:(NSString *)originalUrl
{
    NSString *smallImgUrl;
    smallImgUrl = [originalUrl stringByAppendingString:@"?imageView2/0/w/60/h/60"];
    
    return smallImgUrl;
}
+ (NSString *)smallerQiNiuUrlFrom:(NSString *)originalUrl Width:(int)width Height:(int)height
{
//    return originalUrl;
    NSString *smallImgUrl;
    NSString *appendedDecorator = [NSString stringWithFormat:@"?imageView2/0/w/%d/h/%d", width, height];
    smallImgUrl = [originalUrl stringByAppendingString:appendedDecorator];
    return smallImgUrl;

}
+ (UIFont *)smallLabelFont
{
    UIFont *smallLabelFont;
    
//    if (IS_IPHONE_6P) {
//        smallLabelFont = [UIFont systemFontOfSize:9.0f];
//    }
//    else
//    {
        smallLabelFont = [UIFont systemFontOfSize:11.0f];
//    }
    
    return smallLabelFont;
}

+ (NSNumber *)twoDigitNumberWithRawFloat:(float)number
{
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setRoundingMode:NSNumberFormatterRoundHalfUp];
    [format setMaximumFractionDigits:2];
    NSNumber *temp = [NSNumber numberWithFloat:number];
    
    return temp;
}

+ (NSString *)getDistanceFromHereToLat:(float)lat Lng:(float)lng
{
    if ( (lat - 0) < 0.0001f )
    {
        return @"无地址";
    }
    
    if (true)
    {
        return @"无当前位置";
        
    }
    else
    {

//        double lat2 = 0;
//        double lon2 = 0;
        
//        double distance = [WYMathTool distanceBetweenLat1:lat lon1:lng lat2:lat2 lon2:lon2];
        double distance = 0;

        
        NSNumber *temp = [NSNumber numberWithDouble:distance];
        NSInteger tempInt = [temp integerValue]+1;
//        NSString *result = [NSString stringWithFormat:@"%ldkm内", (long)tempInt ];
        NSString *result = [NSString stringWithFormat:@"%ldkm", (long)tempInt ];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:1];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        
        NSString *numberString = [formatter stringFromNumber:temp];
        NSString *resultOneDigit = [NSString stringWithFormat:@"%@km", numberString];
        
        if (distance > 100.0f) {
            
            return @"100km外";
            
        }
        else if (distance > 20.0f){
            
            return result;
            
        }
        else if (distance > 1.0f){
            
            //@"1到20km间";
            
            return resultOneDigit;
            
        }
        else if (distance > 0.2f){
            
            double da = distance * 10;
            NSNumber *daa = [NSNumber numberWithDouble:da];
            
            NSInteger tempInt = [daa integerValue]+1;
            NSString *result = [NSString stringWithFormat:@"%ld00m内", (long)tempInt ];
            return result;
            
        }
        else{
            
            return @"200m内";
        }
        
    }
}
+ (BOOL)checkStringOnlyAscii:(NSString *)str
{
    if(!str || str.length == 0)
        return YES;
    
    NSCharacterSet *unwantedCharacters =
    [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    return ([str rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound);
}
+ (BOOL)hasUnicodeCharacters:(NSString *)str
{
    return ![str canBeConvertedToEncoding:NSASCIIStringEncoding];
}
+ (NSString *)nameStringsFromBackendDictOfInviteResult:(NSArray *)arr{
    NSString *res = @"";
    for(NSDictionary *dict in arr){
        NSString *name = [dict objectForKey:@"name"];
        res = [res stringByAppendingString:name];
        res = [res stringByAppendingString:@" "];
    }
    
    return res;
}
- (NSURL *)escapedURL{
    NSString *encodedString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    debugLog(@"%@",encodedString);
    NSURL *convertedURL = [NSURL URLWithString:encodedString];
    return convertedURL;
}

-(NSString *)chChangePin{
    //  把汉字转换成拼音第一种方法
    NSString *str = [[NSString alloc]initWithFormat:@"%@", self];
    // NSString 转换成 CFStringRef 型
    CFStringRef string1 = (CFStringRef)CFBridgingRetain(str);
    
    //  汉字转换成拼音
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, string1);
    
    //  拼音（带声调的）
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    
    //  去掉声调符号
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    //  CFStringRef 转换成 NSString
    NSString *strings = (NSString *)CFBridgingRelease(string);
    //  去掉空格
    NSString *resString = [strings stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return resString;
}

@end
