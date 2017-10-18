//
//  WYGroupDetailVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/4/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"
#import "WYPostBaseVC.h"

typedef void(^publishInfoBlock)(NSDictionary *dict);

@interface WYGroupDetailVC : WYPostBaseVC

@property (nonatomic, copy) publishInfoBlock publishInfoBlock;


//本来留两个接口 如果有group就可以不用请求 现在必须要请求要不然group的apply_status可能不是正确的
@property (nonatomic, strong) NSString *groupUuid;
@property (nonatomic, strong) WYGroup *group;

//如果是用户新加入一个群组，要祝贺他一声， 说你加入了群组
@property (nonatomic, assign) BOOL first_enter_as_new_member;


@property (nonatomic, assign) BOOL isPresent;
@end
