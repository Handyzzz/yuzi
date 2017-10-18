//
//  WYAddLinkVC.h
//  Withyou
//
//  Created by Tong Lu on 8/2/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"

@interface WYAddLinkVC : UIViewController

//这个title是属于link里边的
@property (nonatomic, copy) void(^myBlock)(NSString *comment, NSArray *mention, NSString *originalImageUrl, NSString *title, NSString *url,int publishVisibleScopeType, NSString *targetUuid,YZAddress *address,NSArray*remindArr,NSArray *tagsArr);

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
