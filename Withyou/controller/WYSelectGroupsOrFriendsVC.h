//
//  WYSelectGroupsOrFriendsVC.h
//  Withyou
//
//  Created by 夯大力 on 2017/2/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"
typedef void(^visiableScopeBlock)(NSString *targetUuid,NSString*name,WYGroup *group,BOOL haveSelectd);

@interface WYSelectGroupsOrFriendsVC : UIViewController
@property (nonatomic, copy) visiableScopeBlock visiableScopeBlock;
@property(nonatomic,strong)NSString *selectType;
@property (nonatomic ,strong)NSString *Uuid;
@end
