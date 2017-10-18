//
//  YZMarkText.m
//  Withyou
//
//  Created by ping on 2017/4/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZMarkText.h"
//#import <AMapSearchKit/AMapSearchKit.h>

@interface YZMarkText()



@end

@implementation YZMarkText


+ (YZMarkText *)markWithType:(int)type name:(NSString *)name uuid:(NSString *)uuid latitude:(float)latitude longitude:(float)longitude range_start:(NSUInteger)location range_length:(NSUInteger)length {
    YZMarkText *obj = [YZMarkText new];
    obj.content_type = type;
    obj.content_name = name;
    obj.content_uuid = uuid;
    obj.lat = latitude;
    obj.lng = longitude;
    obj.range_start = location;
    obj.range_length = length;
    
    return obj;
}

- (NSRange)range {
    return NSMakeRange(self.range_start, self.range_length);
}


+ (NSMutableAttributedString *)convert:(NSString *)targetStr toAtStringWith:(NSArray<YZMarkText *> *)markArr {
    
    // 重新改变颜色
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 字体的行间距
        paragraphStyle.lineSpacing = 6;
    
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName: UIColorFromHex(0x333333)
                                     };
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:targetStr];
    [str addAttributes:attributes range:NSMakeRange(0, str.length)];
    
    // 遍历substring
    for (YZMarkText *mark in markArr) {
        if(mark.range.location == NSNotFound) continue;
        if(mark.range.location + mark.range.length <= str.length) {
            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x2ba1d4) range:mark.range];
        }
        
    }
    return str;
}


+ (NSMutableAttributedString *)convert:(NSString *)targetStr abilityToTapStringWith:(NSArray<YZMarkText *> *)markArr {
    // 重新改变颜色
    NSMutableAttributedString *str = [YZMarkText _convert:targetStr abilityToTapStringWith:markArr];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x333333) range:NSMakeRange(0, str.length)];
    
    return str;
}
// tony added
+ (NSMutableAttributedString *)convert:(NSString *)targetStr abilityToTapStringWith:(NSArray<YZMarkText *> *)markArr FontSize:(float)size {
    
    NSMutableAttributedString *str = [YZMarkText _convert:targetStr abilityToTapStringWith:markArr];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x333333) range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, str.length)];
    return str;
}


+ (NSArray *)convertMarkArrayToJSONArray:(NSArray *)markArr {
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:markArr.count];
    for (YZMarkText *mark in markArr) {
//        content_type | int | @人为1，@地址为2 |
//        content_name | name string | @xxx   |
//        content_uuid | uuid string | @人为朋友的uuid，@地址时为空字符串""  |
//        lat | float | @人时不传，@地址时是纬度的float |
//        lng | float| @人时不传，@地址时是经度的float  |
//        range_start | int |  |
//        range_length | int |  |
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSNumber numberWithInt:mark.content_type] forKey:@"content_type"];
        [dic setObject:mark.content_name forKey:@"content_name"];
        [dic setObject:[NSNumber numberWithInteger: mark.range_start] forKey:@"range_start"];
        [dic setObject:[NSNumber numberWithInteger: mark.range_length] forKey:@"range_length"];

        if(mark.content_type == 1) {
            [dic setObject:mark.content_uuid forKey:@"content_uuid"];
        }else if(mark.content_type == 2) {
            [dic setObject:@"" forKey:@"content_uuid"];
            [dic setObject:[NSNumber numberWithFloat: mark.lat] forKey:@"lat"];
            [dic setObject:[NSNumber numberWithFloat: mark.lng] forKey:@"lng"];
        }
        [temp addObject:[dic copy]];
    
    }
    
    return temp;
}


// private method
+ (NSMutableAttributedString *)_convert:(NSString *)targetStr abilityToTapStringWith:(NSArray<YZMarkText *> *)markArr {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:targetStr];
    // 遍历substring
    for (int i = 0; i< markArr.count; i++) {
        YZMarkText *mark = markArr[i];
        if(mark.range.location == NSNotFound) continue;
        if(mark.range.location + mark.range.length <= str.length) {
            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x2ba1d4) range:mark.range];
            // 出入markArr 的 index
            NSString * value = [NSString stringWithFormat:@"marked://%d",i];
            
            [str addAttribute:NSLinkAttributeName value:value range:mark.range];
        }
    }
    return str;
}



@end
