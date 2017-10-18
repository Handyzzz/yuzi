//
//  WYBaseMentionTextVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPublishOtherView.h"
@interface WYBaseMentionTextVC : UIViewController

@property (nonatomic, copy) void(^myBlock)(NSAttributedString *text, NSArray *mention);

@property (strong, nonatomic) NSString *navigationTitle;
//没有文字允许清空
@property (assign, nonatomic) BOOL allowEmptyText;
//placeHolderLabel
@property (nonatomic, strong) UILabel *placeHolder;
//placeHolderText
@property (nonatomic, strong) NSString *placeHolderText;

@property (nonatomic, strong)WYPost *post;

@end

