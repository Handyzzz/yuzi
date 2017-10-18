//
//  WYGroupEditVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/4/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"
typedef enum type {
    nameType = 0,
    introduction = 1,
} EditType;
@interface WYGroupEditVC : UIViewController
@property(nonatomic,assign)EditType type;
@property(nonatomic,strong)WYGroup *group;
@property (nonatomic, strong)NSString *key;
@property (nonatomic, strong)NSString *labelString;
@property (nonatomic, strong)NSString *textFieldString;
@property (nonatomic, copy) void(^textClick)(NSString *text);
@end
