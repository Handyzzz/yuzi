//
//  WYsingleHotTagView.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYsingleHotTagView.h"

@implementation WYsingleHotTagView

-(instancetype)initWithTagName:(NSDictionary *)dic backImg:(NSString *)img{
    if (self = [super init]) {
        _backIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, kAppScreenWidth - 30, 36)];
        _backIV.image = [UIImage imageNamed:img];
        [self addSubview:_backIV];
        
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 16, 16)];
        if ([[dic objectForKey:@"pro"] boolValue] == YES) {
            _iconIV.image = [UIImage imageNamed:@"hot_taglist_important_tag"];
        }else{
            _iconIV.image = [UIImage imageNamed:@"hot_taglist_common"];
        }
        [_backIV addSubview:_iconIV];
        
        _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(30, 6, kAppScreenWidth - 90, 22)];
        _nameLb.font = [UIFont systemFontOfSize:16 weight:0.4];
        _nameLb.textColor = [UIColor whiteColor];
        _nameLb.text = [dic objectForKey:@"name"];
        [_backIV addSubview:_nameLb];
    }
    return self;
}
@end
