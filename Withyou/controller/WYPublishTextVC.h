//
//  WYPublicTextVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"
@interface WYPublishTextVC : UIViewController
//去掉@ 添加提及功能
@property (nonatomic, copy) void(^myBlock)(NSString *text, NSArray *mention,int publishVisibleScopeType, NSString *targetUuid,NSString *title,YZAddress *address,NSArray*remindArr,NSArray *pdfs,NSArray *photos,NSArray *tagsArr);
//发布范围的title
@property (copy, nonatomic) NSString *scopeTitle;
//发布类型
@property (nonatomic, assign) int publishVisibleScopeType;
//发布UUid
@property (nonatomic, copy) NSString *targetUuid;

@property (nonatomic, strong) WYGroup *group;
//标签名
@property (nonatomic, strong) NSString*tagName;
@end
