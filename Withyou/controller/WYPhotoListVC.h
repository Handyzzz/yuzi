//
//  WYPhotoListVC.h
//  Withyou
//
//  Created by Tong Lu on 7/28/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"

@interface WYPhotoListVC : UIViewController

@property (nonatomic, copy) void(^myBlock)(NSArray *album, NSString *text, NSString *title, NSArray *mention,int publishVisibleScopeType, NSString *targetUuid,YZAddress *address,NSArray*remindArr,NSArray *tagsArr);

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
