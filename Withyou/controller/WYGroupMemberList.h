//
//  WYGroupMemberList.h
//  Withyou
//
//  Created by Handyzzz on 2017/3/30.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"

@interface WYGroupMemberList : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) WYGroup *group;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *adminList;

//这是所有的展示在这里的用户的数据源
//包括在前面的管理员，以及在后面的普通的群成员
//普通的群成员用的是memberList这个数组，而这个是全部的
@property (nonatomic, strong) NSMutableArray *resultList;

//与resultList对应的relationship的字符串的list
@property (nonatomic, strong) NSMutableArray *relationshipArrForResultList;

//如果在初始化这个VC的时候指定要添加进来管理员的列表的话，就指定让此值为true
//除非是要查看所有的群成员列表，也就是点击群的详情里面的scrollView里面的群成员，需要查看管理员，其他的大部分不需要查看管理员
//比如，移除成员，转移管理权，都不需要
@property (nonatomic, assign) BOOL includeAdminList;

//给子类留一个可以添加东西的地方 在刷新的时候选select用 就不用将整个cellForRowAtIndexPath方法重写
-(void)updateCellContent:(NSIndexPath *)indexPath;
@end
