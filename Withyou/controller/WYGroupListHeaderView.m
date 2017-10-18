//
//  WYGroupListHeaderView.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupListHeaderView.h"
#import "WYGroupClasses.h"
#define itemWH ((kAppScreenWidth - (15 * 2 + 3 *6))/4.0)
#define searchBarH 50
@implementation WYGroupListHeaderView

-(UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont systemFontOfSize:12];
        _titleLb.textColor = kRGB(153, 153, 153);
        _titleLb.text = @"推 荐 群 组";
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15 + searchBarH);
        }];
    }
    return _titleLb;
}

-(UIButton *)moreBtn{
    if (_moreBtn == nil) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"显示更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:kRGB(43, 161, 212) forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(15 + searchBarH);
            make.right.equalTo(-15);
        }];
    }
    return _moreBtn;
}

-(UIView *)bodyView{
    if (_bodyView == nil) {
        _bodyView = [UIView new];
        [self addSubview:_bodyView];
        [_bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(42 + searchBarH);
            make.right.equalTo(-15);
            make.height.equalTo(itemWH);
        }];
    }
    return _bodyView;
}

-(UIView *)searchView{
    if (_searchView == nil) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 50)];
        _searchView.backgroundColor = kRGB(235, 235, 235);
        [self addSubview:_searchView];
        
        
        UIView *groundView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, kAppScreenWidth - 30, 30)];
        groundView.backgroundColor = [UIColor whiteColor];
        groundView.layer.cornerRadius = 4;
        groundView.clipsToBounds = YES;
        [_searchView addSubview:groundView];
        
        
        UILabel *label = [UILabel new];
        label.text = @"搜索群组";
        label.textColor = UIColorFromHex(0xc5c5c5);
        label.font = [UIFont systemFontOfSize:14];
        label.userInteractionEnabled = YES;
        [_searchView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo((12 + 6)/2.0);
            make.centerY.equalTo(0);
        }];
        
        
        UIImageView * leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_friendsearch_search"]];
        [_searchView addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(label.mas_left).equalTo(-6);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction)];
        [_searchView addGestureRecognizer:tap];
    }
    return _searchView;
}


-(void)setUpClassifyView:(NSArray *)classArr{
    //0的情况下 整个头都不要
        
    UIImageView *lastIV;
    for (int i = 0; i < classArr.count; i ++) {
        
        WYGroupClasses *gClass = classArr[i];
        UIImageView *singleIV = [UIImageView new];
        [singleIV sd_setImageWithURL:[NSURL URLWithString:gClass.image]];
        singleIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(catagoryAction:)];
        [singleIV addGestureRecognizer:tap];
        singleIV.tag = i;
        [self.bodyView addSubview:singleIV];
        [singleIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(itemWH);
            make.top.equalTo(0);
            if (i == 0) {
                make.left.equalTo(0);
            }else{
                make.left.equalTo(lastIV.mas_right).equalTo(6);
            }
        }];
        lastIV = singleIV;
        
        //上边加label
        UILabel *nameLb = [UILabel new];
        nameLb.textColor = [UIColor whiteColor];
        nameLb.font = [UIFont systemFontOfSize:14];
        nameLb.text = gClass.name;
        [singleIV addSubview:nameLb];
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(singleIV);
        }];
    }
}

-(void)setUpHeaderView:(NSArray*)classArr{
    [self searchView];
    [self titleLb];
    //更多按钮一定有
    [self moreBtn];
    [self bodyView];
    [self setUpClassifyView:classArr];
}

-(void)setUpSearchView{
    [self searchView];
}

-(void)showMore{
    self.showMoreClick();
}
-(void)catagoryAction:(UITapGestureRecognizer*)sender{
    self.categoryClick(sender.view.tag);
}

-(void)searchAction{
    self.searchClick();
}

@end
