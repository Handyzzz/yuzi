//
//  WYQuitGroupVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYQuitGroupVC.h"
#import "WYTransferAdminVC.h"
#import "WYGroupsVC.h"
#import "WYGroupApi.h"

@interface WYQuitGroupVC ()
@property(nonatomic, strong)UILabel *titleLb;
@property(nonatomic, strong)UITextField *textFd;
@end

@implementation WYQuitGroupVC

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_textFd resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNaviItem];
    [self creatUI];
    
}
-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)creatUI{
    self.title = self.titleString;
    
    UIView *tipsView = [UIView new];
    tipsView.backgroundColor = UIColorFromHex(0x2BA1D4);
    [self.view addSubview:tipsView];
    [tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.right.equalTo(0);
        make.height.equalTo(50);
    }];
    
    _titleLb = [UILabel new];
    _titleLb.text = @"退出群组前，请输入群名称以完成验证";
    _titleLb.textColor = UIColorFromHex(0xffffff);
    _titleLb.font = [UIFont systemFontOfSize:15];
    [tipsView addSubview:_titleLb];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.bottom.right.equalTo(0);
        make.left.equalTo(15);
    }];
    
    _textFd = [UITextField new];
    _textFd.font = [UIFont systemFontOfSize:15];
    _textFd.placeholder = @"输入群组名称";
    _textFd.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_textFd];
    [_textFd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-20);
        make.top.equalTo(tipsView.mas_bottom).equalTo(0);
        make.height.equalTo(50);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(_textFd.mas_bottom).equalTo(0);
        make.height.equalTo(1);
    }];
    
}

-(void)rightBtnClick{
    [_textFd resignFirstResponder];
    __weak WYQuitGroupVC *weakSelf = self;
    [[[UIAlertView alloc] initWithTitle:@"退出群组"
                                message:@"退出群组后，你在群内的发帖仍然存在。\n可以在我的分享页找到所有自己发布的帖子并做处理。"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        return;
    }]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
        [weakSelf prepareQuitGroup];
    }], nil] show];
}

-(void)prepareQuitGroup{
    
    if ([_textFd.text isEqualToString:self.group.name]) {
        //1 先判断我是不是管理员
        BOOL isAdmin = [self.group checkUserIsAdminFromUserUuid:kuserUUID];
        if(isAdmin){
            //我是管理员 是否有其他管理员 这个时候只要arr.count大于等于2 就有其他的管理员
            if (self.group.adminList.count >= 2) {
                //还有其他管理员
                //退群
                [self quitGroup];
            }else{
                //没有其他的管理员了
                //判断还有群里还没有人
                if (self.group.member_num >= 2) {
                    //群里还有其他人
                    //转让
                    WYTransferAdminVC *vc = [WYTransferAdminVC new];
                    vc.includeAdminList = NO;
                    vc.group = self.group;
                    vc.group = self.group;
                    vc.needQuite = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    //群里没有其他人了
                    //退群
                    [self quitGroup];
                }
            }
            
        }else{
            //我不是管理员
            //直接退群
            [self quitGroup];
        }
    }else{
        [WYUtility showAlertWithTitle:@"群名称不正确"];
    }
}

-(void)quitGroup{
    __weak WYQuitGroupVC *weakSelf = self;
    [WYGroupApi requestQuitGroup:self.group.uuid groupName:self.textFd.text Block:^(long status) {
        if (status == 200) {
            //然后退回到groups页面
            //发通知更新内存数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kQuitGroup object:weakSelf userInfo:@{@"group":self.group}];
            
            //从各个入口可以退群 所以不能只退回到某个VC 退群 和转让退群 返回的层级不一样
            NSInteger index = [self.navigationController.viewControllers count] - 1;
            [self.navigationController popToViewController:self.navigationController.viewControllers[index - 3] animated:YES];
            [OMGToast showWithText:@"成功退出群组"];
            
        }else{
            [OMGToast showWithText:@"退出群组未成功！"];
        }
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textFd resignFirstResponder];
}

@end
