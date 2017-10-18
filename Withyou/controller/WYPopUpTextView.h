//
//  WYPopUpTextView.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/4.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPopUpTextView : UIView
@property(nonatomic,copy)void(^textClick)(NSString *text);
- (instancetype)initWithPlaceHoder:(NSString *)placeHoder;
@end
