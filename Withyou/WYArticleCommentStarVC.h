//
//  WYArticleCommentStarVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/30.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYArticle.h"
@interface WYArticleCommentStarVC : UIViewController
@property(nonatomic, strong)WYArticle *article;
@property(nonatomic, copy)NSMutableArray *tempList;

@end
