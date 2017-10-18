//
//  WYUserNickNameVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYUserNickNameVC : UIViewController
@property (nonatomic, strong)NSString *keyWords;
/**
 *keyWords 昵称 数组中是WYNickName
 *keyWords 标签 数组中是@"xxxxx"
 */
@property (nonatomic, copy)NSMutableArray *detailArr;
@property (nonatomic, copy)void(^doneClick)(NSMutableArray *detailArr);

@end
