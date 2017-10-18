//
//  WYUserEditWorkVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/2.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYUserEditWorkVC : UIViewController
@property (nonatomic, assign)BOOL isAdd;

@property (nonatomic, copy)void(^doneClick)(WYJob *job);
@property (nonatomic, strong)WYJob *job;

@end
