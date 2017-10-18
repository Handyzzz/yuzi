//
//  OMGToast.h
//  Withyou
//
//  Created by Tong Lu on 1/21/15.
//  Copyright (c) 2015 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_DISPLAY_DURATION 2.0f

//暂未用到
typedef enum : NSUInteger {
    OMGToastViewTypeFail = 1,
    OMGToastViewTypeNormal = 2,
} OMGToastViewType;

@interface OMGToast : NSObject {
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}




+ (void)showWithText:(NSString *) text_;

+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;

+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;

+ (void)showCurrentPlace;

@end
