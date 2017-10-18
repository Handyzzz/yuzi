//
//  YZMarkText.h
//  Withyou
//
//  Created by ping on 2017/4/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMarkText : NSObject

//        content_type | int | @人为1，@地址为2 |
//        content_name | name string | @xxx
//        content_uuid | uuid string | @人为朋友的uuid，@地址时为空字符串""  |
//        lat | float | @人时不传，@地址时是纬度的float |
//        lng | float| @人时不传，@地址时是经度的float  |
//        range_start | int |  |
//        range_length | int |  |

@property (nonatomic, assign)int content_type;
// @xxx 字符串
@property (nonatomic, strong)NSString *content_name;
@property (nonatomic, strong)NSString *content_uuid;

@property (nonatomic, assign)float lat;
@property (nonatomic, assign)float lng;
@property (nonatomic, assign)NSUInteger range_start;
@property (nonatomic, assign)NSUInteger range_length;


// return NSMakeRange(self.range_start, self.range_length);
@property (nonatomic, assign)NSRange range;



// 构造方法
+ (YZMarkText *)markWithType:(int)type name:(NSString *)name uuid:(NSString *)uuid latitude:(float)latitude longitude:(float)longitude range_start:(NSUInteger)range_start range_length:(NSUInteger)range_length;


/*
 转为@xxx 高亮的方法
 @param targetStr 要转换的str
 @param markArr 包含YZMarkText的数组 会根据每个对象的markStr 去显示高亮文本
 @return 高亮@显示的 NSAttributedString
 */
+ (NSMutableAttributedString *)convert:(NSString *)targetStr toAtStringWith:(NSArray <YZMarkText *> *)markArr;

/*
 转为@xxx 高亮并且可以点击的方法
 需要成为textView.delegate 实现以下方法去监听
 - (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
 @param targetStr 要转换的str
 @param markArr 包含YZMarkText的数组 会根据每个对象的markStr 去显示高亮文本
 @return 高亮@显示的 NSAttributedString
 */
+ (NSMutableAttributedString *)convert:(NSString *)targetStr abilityToTapStringWith:(NSArray<YZMarkText *> *)markArr;


//同上面的方法，但是可以设置FontSize
+ (NSMutableAttributedString *)convert:(NSString *)targetStr abilityToTapStringWith:(NSArray<YZMarkText *> *)markArr FontSize:(float)size;

+ (NSArray *)convertMarkArrayToJSONArray:(NSArray *)markArr ;


@end
