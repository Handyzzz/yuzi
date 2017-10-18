//
//  WYHotTagListHeaderView.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYHotTagListHeaderView.h"
#import "WYsingleHotTagView.h"

@implementation WYHotTagListHeaderView

-(UILabel *)hotTitleLb{
    if (_hotTitleLb == nil) {
        _hotTitleLb = [UILabel new];
        _hotTitleLb.font = [UIFont systemFontOfSize:20 weight:0.4];
        _hotTitleLb.textColor = UIColorFromHex(0x333333);
        [self addSubview:_hotTitleLb];
        [_hotTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(20);
        }];
    }
    return _hotTitleLb;
}

-(UILabel *)hotAllTagLb{
    _hotAllTagLb = [UILabel new];
    _hotAllTagLb.textColor = kRGB(153, 153, 153);
    _hotAllTagLb.font = [UIFont systemFontOfSize:12];
    [self addSubview:_hotAllTagLb];
    [_hotAllTagLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(0);
        make.height.equalTo(60);
    }];
    _hotAllTagLb.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hotAllTagLbAction)];
    [_hotAllTagLb addGestureRecognizer:tap];

    return _hotAllTagLb;
}

-(UIView *)allTagView{
    if (_allTagView == nil) {
        _allTagView = [UIView new];
        [self addSubview:_allTagView];
        [_allTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.top.equalTo(60);
            make.height.equalTo(220);
        }];
    }
    return _allTagView;
}

-(UILabel *)attionTitleLb{
    if (_attionTitleLb == nil) {
        _attionTitleLb = [UILabel new];
        _attionTitleLb.font = [UIFont systemFontOfSize:20 weight:0.4];
        _attionTitleLb.textColor = UIColorFromHex(0x333333);
        [self addSubview:_attionTitleLb];
        [_attionTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(self.allTagView.mas_bottom).equalTo(35);
        }];
    }
    return _attionTitleLb;
}

-(UILabel *)attionAllTagLb{
    _attionAllTagLb = [UILabel new];
    _attionAllTagLb.textColor = kRGB(153, 153, 153);
    _attionAllTagLb.font = [UIFont systemFontOfSize:12];
    [self addSubview:_attionAllTagLb];
    [_attionAllTagLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(self.attionTitleLb);
        make.height.equalTo(60);
    }];
    _attionAllTagLb.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attionAllTagLbAction)];
    [_attionAllTagLb addGestureRecognizer:tap];
    
    return _attionAllTagLb;
}


-(void)setUpHeaderViewDetail:(NSArray *)tagArr{
    self.hotTitleLb.text = @"热门标签";
    self.hotAllTagLb.text = @"查看全部";
    [self setUpAllTagView:tagArr];
    self.attionTitleLb.text = @"关注标签";
    self.attionAllTagLb.text = @"查看全部";
}

-(void)setUpAllTagView:(NSArray *)tagArr{
    
    NSArray *imaArr = @[@"hot_taglist_one",@"hot_taglist_two",@"hot_taglist_three",@"hot_taglist_four",@"hot_taglist_five"];
    
    NSInteger sum = tagArr.count > 5 ? 5 : tagArr.count;
    for (int i = 0; i < sum; i ++) {
        NSDictionary *dic = tagArr[i];
        WYsingleHotTagView *singleView = [[WYsingleHotTagView alloc]initWithTagName:dic backImg:imaArr[i]];
        singleView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagAction:)];
        [singleView addGestureRecognizer:tap];
        [self.allTagView addSubview:singleView];
        [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(36);
            make.top.equalTo(46*i);
        }];
    }
}

-(void)tagAction:(UITapGestureRecognizer*)sender{
    self.tagClicked(sender.view.tag);
}

-(void)hotAllTagLbAction{
    self.hotAllTagLbClick();
}

-(void)attionAllTagLbAction{
    self.attionAllTagLbClick();
}
@end
