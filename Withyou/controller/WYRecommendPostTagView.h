//
//  WYRecommendPostTagView.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYRecommendPostTagView : UIView

@property(nonatomic,copy)void(^buttonSelectedClick)(NSInteger index);

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title TagsArr:(NSArray*)tags;

@end
