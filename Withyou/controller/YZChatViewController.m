//
//  YZChatViewController.m
//  Withyou
//
//  Created by ping on 2017/3/18.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZChatViewController.h"
#import "WYUserVC.h"
#import "YZChat.h"

@interface YZChatViewController ()<EaseMessageViewControllerDataSource,EMChatManagerDelegate, EaseMessageViewControllerDelegate>

@end

@implementation YZChatViewController
/*
 父类中实现了
 [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
 [self tableViewDidTriggerHeaderRefresh];
 */

- (id)initWithUser:(WYUser *)user {
    if(self = [super initWithConversationChatter:user.easemob_username conversationType:EMConversationTypeChat]) {
        self.user = user;
        self.dataSource = self;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];

    if(self.backClickBlock) {
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissChat:)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    self.title = self.user.fullName;
    self.showRefreshHeader = YES;
}

-(void)setNavigationBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}
-(void)dismissChat:(UIBarButtonItem *)btn {
    if(self.backClickBlock) {
        self.backClickBlock();
    }
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController canLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    //用户可以根据自己的用户体系，根据message设置用户昵称和头像
    id<IMessageModel> model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];//默认头像
    
    // 如果消息来源等于 聊天对象
    if(message.direction == EMMessageDirectionReceive) {
        model.avatarURLPath = self.user.icon_url;//头像网络地址
        model.nickname = self.user.fullName;//用户昵称
    }else {
        WYUser *user = kLocalSelf;
        model.avatarURLPath = user.icon_url;//头像网络地址
        model.nickname = user.fullName;//用户昵称
    }
    return model;
}


// 改动了 EMChatToolbarDelegate的源码  在搜索好友框弹出键盘的时候,禁止聊天窗口改变frame
- (BOOL)inputTextShouldChangeFrameOnKeyboardWillShow:(EaseTextView *)inputTextView {
    return self.isViewDidAppear;
}

//这个方法是重写了 环信的sendmsg中调用的一个方法
- (void)addMessageToDataSource:(EMMessage *)message progress:(id)progress {
    [super addMessageToDataSource:message progress:progress];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationYZChatSendMessage object:self.user];
}


# pragma mark -
- (void)checkUserDetail
{
    WYUserVC *vc = [WYUserVC new];
    vc.user = self.user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkSelfDetail
{
    WYUserVC *vc = [WYUserVC new];
    vc.user = kLocalSelf;
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark - delegate
// 点击消息的头像, 没成功
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel{
    
    if(messageModel.isSender)
        [self checkSelfDetail];
    else
        [self checkUserDetail];
}

- (void)avatarViewSelcted:(id<IMessageModel>)model {
    WYUser *user = nil;
    if(model.isSender) {
        user = kLocalSelf;
    } else{
        user = self.user;
    }
    WYUserVC *vc = [WYUserVC new];
    vc.user = user;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
