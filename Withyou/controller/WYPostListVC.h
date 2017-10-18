//
//  WYPostListVC.h
//  Withyou
//
//  Created by Tong Lu on 8/8/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYPostBaseVC.h"


typedef void(^postBlock)(NSMutableArray *postArr);

@interface WYPostListVC : WYPostBaseVC
//未使用
@property(nonatomic ,copy) postBlock postBlock;
//未使用
@property(nonatomic ,strong) NSMutableArray * postArr;
@end
