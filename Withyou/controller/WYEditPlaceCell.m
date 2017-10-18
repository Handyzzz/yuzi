//
//  WYEditPlaceCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/3/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYEditPlaceCell.h"

@interface WYEditPlaceCell()<UITextFieldDelegate>

@end
@implementation WYEditPlaceCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.textFd.delegate = self;
    }
    return self;
}

//建议cell的高度70
-(UIImageView*)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        [self.contentView addSubview:_iconIV];
        _iconIV.layer.cornerRadius = 4;
        _iconIV.clipsToBounds = YES;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(10);
            make.width.height.equalTo(50);
        }];
    }
    return _iconIV;
}

-(UITextField*)textFd{
    if (_textFd == nil) {
        _textFd = [UITextField new];
        _textFd.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_textFd];
        [_textFd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.right.equalTo(-60);
            make.height.equalTo(25);
        }];
    }
    return _textFd;
}
-(UILabel*)desLb{
    if (_desLb == nil) {
        _desLb = [UILabel new];
        [self.contentView addSubview:_desLb];
        _desLb.numberOfLines = 1;
        _desLb.textAlignment = NSTextAlignmentLeft;
        _desLb.textColor = [UIColor lightGrayColor];
        _desLb.font  = kFont_12;
        [_desLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textFd.mas_bottom).equalTo(5);
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.height.equalTo(20);
        }];
    }
    return _desLb;
}

/*
 坑啊  给cell写了一个点击父视图 收键盘的方法 居然影响到了 tableView的编辑模式不能用 更无语的是删除模式可以用 选择模式不可以用
 而且结束的是textFd的响应者身份 还不是[self.view endEditing:YES]
  -(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.textFd resignFirstResponder];
 }
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

@end
