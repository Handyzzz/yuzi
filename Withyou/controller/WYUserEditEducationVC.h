//
//  WYUserEditEducationView.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/2.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYUserEditEducationVC : UIViewController
@property (nonatomic, assign)BOOL isAdd;
@property (nonatomic, copy)void(^doneClick)(WYStudy *study);
@property (nonatomic, strong)WYStudy *study;

@end
