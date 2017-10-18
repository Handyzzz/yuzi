//
//  WYDraftCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/17.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYDraftCell.h"

@implementation WYDraftCell

-(UITextView *)textView{
    if (_textView == nil) {
        _textView = [UITextView new];
        _textView.editable = NO;
        _textView.textColor = UIColorFromHex(0x333333);
        _textView.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_textView];
    }
    return _textView;
}

-(UILabel *)timeLb{
    if (_timeLb == nil) {
        _timeLb = [UILabel new];
        _timeLb.textColor = UIColorFromHex(0x999999);
        _timeLb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-15);
            make.top.equalTo(self.textView.mas_bottom).equalTo(5);
            make.bottom.equalTo(-12);
        }];
    }
    return _timeLb;
}

-(void)setCellData:(NSArray *)contentArr :(NSArray *)timeArr :(NSIndexPath *)indexPath{
    
       
    NSString *contentStr = contentArr[indexPath.row];
    CGFloat h = [contentStr sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kAppScreenWidth - 30, 65)].height;
    self.textView.frame = CGRectMake(15, 15, kAppScreenWidth - 30, h + 10);
    self.textView.text = contentStr;

    NSString *timeStr = timeArr[indexPath.row];
    NSTimeInterval time=[timeStr doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 这个时间是北京时间
    NSString *nowtimeStr = [formatter stringFromDate:detaildate];
    
    self.timeLb.text = nowtimeStr;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.contentView addGestureRecognizer:longPress];
   
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state != UIGestureRecognizerStateBegan) return;
    if(self.removeDraftBlock) self.removeDraftBlock();
}

+(CGFloat)caculateCellHeight:(NSString *)contentStr{
    CGFloat h = [contentStr sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kAppScreenWidth - 30, 65)].height;
    CGFloat heigh = 15 + h + 5 + 18 + 12 + 10;
    return heigh;
}

@end
