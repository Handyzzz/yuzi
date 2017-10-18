//
//  WYRecommendPostTagView.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYRecommendPostTagView.h"
#import "UIImage+WYUtils.h"

@interface WYRecommendPostTagView()
@property(nonatomic,strong)NSMutableArray *buttonList;
@end

@implementation WYRecommendPostTagView

-(NSMutableArray *)buttonList{
    if (_buttonList == nil) {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title TagsArr:(NSArray*)tags;{

    if (self = [super initWithFrame:frame]) {
        
        //推荐标签的标题
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 30)];
        [self addSubview:view];
        view.backgroundColor = UIColorFromHex(0xf5f5f5);
        UILabel *titleLb = [UILabel new];
        titleLb.font = [UIFont systemFontOfSize:12];
        titleLb.textColor = kRGB(153, 153, 153);
        [view addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(8);
        }];
        titleLb.text = title;

        //推荐标签
        for (int i = 0; i < tags.count; i++) {
            NSString *str = tags[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:str forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            //计算button的size 并且给上去
            CGFloat width = [str sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kAppScreenWidth - 30, 32)].width;
            button.size = CGSizeMake(width + 10, 32);
            [button setBackgroundImage:[UIImage imageWithColor:kRGB(154, 177, 186) andSize:button.size] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0x6B797F) andSize:button.size] forState:UIControlStateHighlighted];
            button.layer.cornerRadius = 4;
            button.clipsToBounds = YES;
            button.tag = i;
            [button addTarget:self action:@selector(buttonSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.buttonList addObject:button];
            [self addSubview:button];
        }
        [self resetFrame];
    }
    return self;
}

- (void)resetFrame{
    
    if (self.buttonList.count <= 0) {
        return;
    }
    CGFloat titleHeight = 30;
    CGFloat margin = 10;
    // 存放每行的第一个Button
    NSMutableArray *rowFirstButtons = [NSMutableArray array];
    
    // 对第一个Button进行设置
    UIButton *button0 = self.buttonList[0];
    button0.left = margin;
    button0.top = margin + titleHeight;
    [rowFirstButtons addObject:self.buttonList[0]];
    
    // 对其他Button进行设置
    int row = 0;
    for (int i = 1; i < self.buttonList.count; i++) {
        UIButton *button = self.buttonList[i];
        
        int sumWidth = 0;
        int start = (int)[self.buttonList indexOfObject:rowFirstButtons[row]];
        for (int j = start; j <= i; j++) {
            UIButton *button = self.buttonList[j];
            sumWidth += (button.width + margin);
        }
        sumWidth += 10;
        
        UIButton *lastButton = self.buttonList[i - 1];
        if (sumWidth >= self.width) {
            button.left = margin;
            button.top = lastButton.top + margin + button.height;
            [rowFirstButtons addObject:button];
            row ++;
        } else {
            button.left = sumWidth - margin - button.width;
            button.top = lastButton.top;
        }
    }
    
    UIButton *lastButton = self.buttonList.lastObject;
    self.height = CGRectGetMaxY(lastButton.frame) + 10;
}

-(void)buttonSelectedAction:(UIButton *)sender{
    self.buttonSelectedClick(sender.tag);
}

@end
