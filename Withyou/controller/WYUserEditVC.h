//
//  WYUserEditVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYUserEditVC : UIViewController
//姓 名 与子ID
@property (nonatomic, strong)NSString *key;
@property (nonatomic, strong)NSString *labelString;
@property (nonatomic, strong)NSString *textFieldString;

@property (nonatomic, copy)void(^doneClick)(NSString *str);
@end
