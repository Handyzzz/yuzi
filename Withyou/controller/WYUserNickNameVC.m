//
//  WYUserNickNameVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserNickNameVC.h"
#import "WYUserEditNormalCell.h"
#import "WYNickName.h"
#import "WYNickNameApi.h"

@interface WYUserNickNameVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UITextField *textFiled;
@property (nonatomic, assign)NSInteger selectIndex;
@property (nonatomic, strong)UILabel *selectedLb;
@property (nonatomic, strong)UIButton *addButton;
@property (nonatomic, strong)UIView *addNickView;
@end

@implementation WYUserNickNameVC


-(NSMutableArray *)detailArr{
    if (_detailArr == nil) {
        _detailArr = [NSMutableArray array];
    }
    return _detailArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationBar];
    [self setUpUI];
}


-(void)setNavigationBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

-(void)setUpUI{
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYUserEditNormalCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WYUserEditNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLb.text = [NSString stringWithFormat:@"%@%lu",self.keyWords,indexPath.row + 1];
    cell.textLb.font = [UIFont systemFontOfSize:14 weight:0.4];
    cell.textLb.textColor = UIColorFromHex(0x999999);
    if ([self.keyWords isEqualToString:@"昵称"]) {
        if (self.detailArr.count >= indexPath.row + 1) {
            WYNickName *nickName = self.detailArr[indexPath.row];
            cell.detailLb.text = nickName.name;
        }else{
            cell.detailLb.text = @"";
        }
    }else if([self.keyWords isEqualToString:@"标签"]){
        if (self.detailArr.count >= indexPath.row + 1) {
            NSString *name = self.detailArr[indexPath.row];
            cell.detailLb.text = name;
        }else{
            cell.detailLb.text = @"";
        }
    }
    
    cell.detailLb.font = [UIFont systemFontOfSize:14];
    cell.detailLb.textColor = kRGB(51, 51, 51);
    cell.detailLb.userInteractionEnabled = YES;
    cell.detailLb.tag = indexPath.row + 1000;
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editClick:)];
    [cell.detailLb addGestureRecognizer:tap];
    
    UIView *line = [cell.contentView viewWithTag:999];
    if (line == nil) {
        line = [UIView new];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.bottom.equalTo(0);
            make.width.equalTo(kAppScreenWidth - 15);
            make.height.equalTo(1);
        }];
        line.backgroundColor = UIColorFromHex(0xf5f5f5);
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 25)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.text = [NSString stringWithFormat:@"你可以设置三个%@哦!",self.keyWords];
    label.textColor = kRGB(153, 153, 153);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(0);
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50 + 40 + 38;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    _addNickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 50 + 40 + 38)];
    _addNickView.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [UILabel new];
    lable.text = [NSString stringWithFormat:@"新%@",self.keyWords];
    lable.font = [UIFont systemFontOfSize:14 weight:0.4];
    lable.textColor = UIColorFromHex(0x999999);
    [_addNickView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(17);
        make.width.equalTo(60);
    }];
    _textFiled = [UITextField new];
    _textFiled.delegate = self;
    _textFiled.font = [UIFont systemFontOfSize:14];
    _textFiled.textColor = kRGB(51, 51, 51);
    _textFiled.placeholder = [NSString stringWithFormat:@"输入%@",self.keyWords];
    [_textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_addNickView addSubview:_textFiled];
    [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lable.mas_right).equalTo(10);
        make.top.equalTo(17);
        make.right.equalTo(-20);
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [_addNickView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(0);
        make.top.equalTo(52);
        make.height.equalTo(1);
    }];
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addNickView addSubview:_addButton];
    [_addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(90);
        make.centerX.equalTo(0);
    }];
    //灰色
    [_addButton setBackgroundImage:[UIImage imageNamed:@"user_add_nickName_gray"] forState:UIControlStateNormal];
    
    if (self.detailArr.count < 3) {
        [_textFiled becomeFirstResponder];
        _addNickView.hidden = NO;
    }else{
        _addNickView.hidden = YES;
    }
    return _addNickView;
}

-(void)addClick:(UIButton *)sender{

    if ([self.keyWords isEqualToString:@"昵称"]) {
        //发送添加昵称的请求
        NSDictionary *dic = @{@"name":_textFiled.text};
        
        __weak WYUserNickNameVC *weakSelf = self;
        
        //检查是否有字
        if (!(_textFiled.text.length > 0)) {
            return;
        }
        
        
        sender.enabled = NO;
        
        [WYNickNameApi postUserNickNameDetail:dic Block:^(WYNickName *nickName) {
            sender.enabled = YES;
            if (nickName) {
                //插入数据
                [weakSelf.detailArr addObject:nickName];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.detailArr.count - 1 inSection:0];
                [weakSelf.tableview beginUpdates];
                [weakSelf.tableview insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [weakSelf.tableview endUpdates];
                //将文本框内容清除
                weakSelf.textFiled.text = @"";
                //灰色
                [_addButton setBackgroundImage:[UIImage imageNamed:@"user_add_nickName_gray"] forState:UIControlStateNormal];
                weakSelf.doneClick(weakSelf.detailArr);
                
                /*如果已经有了 3个以上 提示无法添加更多昵称*/
                if (self.detailArr.count >= 3) {
                    _addNickView.hidden = YES;
                    [self.view endEditing:YES];
                }
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
        }];
    }else if ([self.keyWords isEqualToString:@"标签"]){
        //检查是否有字
        if (!(_textFiled.text.length > 0)) {
            return;
        }
        //插入数据
        [self.detailArr addObject:_textFiled.text];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.detailArr.count - 1 inSection:0];
        [self.tableview beginUpdates];
        [self.tableview insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableview endUpdates];
        //将文本框内容清除
        self.textFiled.text = @"";
        //灰色
        [_addButton setBackgroundImage:[UIImage imageNamed:@"user_add_nickName_gray"] forState:UIControlStateNormal];
        self.doneClick(self.detailArr);
        
        /*如果已经有了 3个以上 提示无法添加更多昵称*/
        if (self.detailArr.count >= 3) {
            _addNickView.hidden = YES;
            [self.view endEditing:YES];
            return;
        }
    }
}

-(void)editClick:(UITapGestureRecognizer *)sender{
    //弹出文本框
    _selectIndex = sender.view.tag - 1000;
    _selectedLb = (UILabel *)(sender.view);
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"修改%@",self.keyWords] message:[NSString stringWithFormat:@"输入%@",self.keyWords] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField  * textFiled =  [alertview textFieldAtIndex:0];
    textFiled.text = ((UILabel *)(sender.view)).text;
    [alertview show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *evaluate = [alertView textFieldAtIndex:0];//获取alertView的文本框
        //点击了确定按钮
        if ([self.keyWords isEqualToString:@"昵称"]) {
            WYNickName *MynickName = self.detailArr[_selectIndex];
            __weak WYUserNickNameVC *weakSelf = self;
            [WYNickNameApi patchNickNameDetail:MynickName.uuid Dic:@{@"name":evaluate.text} Block:^(WYNickName *nickName) {
                if (nickName){
                    [weakSelf.detailArr replaceObjectAtIndex:_selectIndex withObject:nickName];
                    weakSelf.selectedLb.text = nickName.name;
                    weakSelf.doneClick(weakSelf.detailArr);
                }
            }];
        }else if ([self.keyWords isEqualToString:@"标签"]){
            [self.detailArr replaceObjectAtIndex:_selectIndex withObject:evaluate.text];
            self.selectedLb.text = evaluate.text;
            self.doneClick(self.detailArr);
        }
    }
}

#pragma delegate

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
       return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak WYUserNickNameVC *weakSelf = self;
   
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if ([self.keyWords isEqualToString:@"昵称"]) {
            WYNickName *nickName = self.detailArr[indexPath.row];
            [WYNickNameApi deleteNickNameDetail:nickName.uuid Block:^(BOOL haveDelete) {
                if (haveDelete) {
                    [weakSelf.detailArr removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //删除操作后 想重置tag 防止数据错位和越界
                    [weakSelf.tableview reloadData];
                    weakSelf.doneClick(weakSelf.detailArr);
                    if (self.detailArr.count <3) {
                        _addButton.enabled = YES;
                        _addNickView.hidden = NO;
                    }
                }
            }];
        }else if ([self.keyWords isEqualToString:@"标签"]){
            [weakSelf.detailArr removeObjectAtIndex:indexPath.row];
            [weakSelf.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //删除操作后 想重置tag 防止数据错位和越界
            [weakSelf.tableview reloadData];
            weakSelf.doneClick(weakSelf.detailArr);
            if (self.detailArr.count <3) {
                _addButton.enabled = YES;
                _addNickView.hidden = NO;
            }
        }
    }
}


- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField.text.length > 0 && self.detailArr.count < 3) {
        [_addButton setBackgroundImage:[UIImage imageNamed:@"user_add_nickName"] forState:UIControlStateNormal];

    }else{
        //灰色
        [_addButton setBackgroundImage:[UIImage imageNamed:@"user_add_nickName_gray"] forState:UIControlStateNormal];
    }
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
