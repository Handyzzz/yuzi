//
//  WYMsgListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

//应用内评价的包
#import <StoreKit/StoreKit.h>

#import "WYMsgListVC.h"
#import "YZMessageCell.h"
#import "YZPostDetailVC.h"
#import "WYGroupDetailVC.h"
#import "WYSelfDetailEditing.h"
#import "WYAcceptInviteVC.h"
#import "YZMessageApi.h"
#import "WYHandleApplicationVC.h"
#import "WYWebViewVC.h"
#import "WYSubscribeVC.h"
#import "YZMessageApi.h"
#import <StoreKit/StoreKit.h>
#import "WYPlaceholderView.h"


@interface WYMsgListVC ()<UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate>
@property(nonatomic, strong)WYPlaceholderView *placeholderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *msgList;
@end

@implementation WYMsgListVC

-(NSMutableArray *)msgList{
    if (_msgList == nil) {
        _msgList = [NSMutableArray array];
    }
    return _msgList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.naviTitle;
    [self setNaviBar];
    [self setUpTableView];
    [self setUpPlaceholderView];
    [self initData];
}


-(void)initData{
    __weak WYMsgListVC *weakSelf = self;
    //[self.view showHUDNoHide];
    [YZMessageApi listMsgList:self.type oldTime:@(0) Block:^(NSArray *msgArr) {
        //[weakSelf.view hideAllHUD];
        if (msgArr) {
            if (msgArr.count > 0) {
                //拉出了数据才表示看过
                weakSelf.block(YES, weakSelf.type);
                [weakSelf.msgList addObjectsFromArray:msgArr];
                YZMessage *msg = msgArr.firstObject;
                [YZMessageApi updateLastTime:msg.created_at_float];
                [weakSelf reloadTableAndFooterView];
            }else{
                //显示占位图没有消息
            }
        }else{
            //显示占位图没有网络
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
    
    [self.tableView addFooterRefresh:^{
     
        YZMessage *msg = weakSelf.msgList.lastObject;
        NSNumber *time;
        if (msg) {
            time = msg.created_at_float;
        }else{
            time = @(0);
        }
        [YZMessageApi listMsgList:weakSelf.type oldTime:time Block:^(NSArray *msgArr) {
            if (msgArr) {
                if (msgArr.count > 0) {
                    [weakSelf.msgList addObjectsFromArray:msgArr];
                    [weakSelf reloadTableAndFooterView];
                    [weakSelf.tableView endFooterRefresh];
                }else{
                    [weakSelf.tableView endRefreshWithNoMoreData];
                }
            }else{
                //显示占位图没有网络
                [weakSelf.tableView endFooterRefresh];
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
        }];
    }];
}


-(void)setNaviBar{
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    if (self.type == 6) {
        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"messageSubscribeNote"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(subscribePostAction)];
        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[YZMessageCell class] forCellReuseIdentifier:@"YZMessageCell"];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)setUpPlaceholderView{
    if (self.msgList.count > 0) {
        if (self.placeholderView) {
            self.placeholderView = nil;
            self.tableView.tableFooterView = [UIView new];
        }
        
    }else{
        if (_placeholderView == nil) {
            _placeholderView = [[WYPlaceholderView alloc]initWithImage:@"msg_placehold_sofa" msg:@"暂时没有新消息哦" imgW:62 imgH:75];
        }
        self.tableView.tableFooterView = _placeholderView;
    }
}

-(void)reloadTableAndFooterView{
    [self.tableView reloadData];
    [self setUpPlaceholderView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YZMessage *msg = _msgList[indexPath.row];
    return [YZMessageCell fitHeight:msg];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YZMessageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YZMessage * msg = _msgList[indexPath.row];
    cell.msg = msg;
    __weak WYMsgListVC *weakSelf = self;
    
    cell.removeMessageBlock = ^(YZMessage *msg) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要删除该条消息吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [YZMessageApi removeMessage:msg.uuid Handler:^(BOOL result) {
                if (result) {
                    [_msgList removeObject:msg];
                    [weakSelf reloadTableAndFooterView];
                }else{
                    [OMGToast showWithText:@"网络不畅，请稍后再试."];
                }
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    //点击头像的事件
    cell.iconClick = ^(YZMessage *msg) {
        if([msg.author_uuid isEqualToString:kuserUUID])
        {
            WYUserVC *vc = [WYUserVC new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.user = kLocalSelf;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }
        else{
            WYUserVC *vc = [WYUserVC new];
            vc.hidesBottomBarWhenPushed = YES;
            WYUser *user = [[WYUser alloc] init];
            user.uuid = msg.author_uuid;
            vc.user = user;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    YZMessage * msg = _msgList[indexPath.row];
    debugLog(@"%@",msg.target_type_str);
    if([msg.target_type_str isEqualToString:@"post"])
    {
        [self postDetailNormalAction:msg.target_uuid];
    }
    else if([msg.target_type_str isEqualToString:@"group"])
    {
        [self groupDetailAction:msg.target_uuid];
    }
    else if([msg.target_type_str isEqualToString:@"group_invitation"])
    {
        [self groupInviteAction:msg.target_uuid];
    }
    else if ([msg.target_type_str isEqualToString:@"group_application"]){
        [self groupApplication:msg.target_uuid];
    }
    else if([msg.target_type_str isEqualToString:@"user"])
    {
        [self relationshipAction:msg.author_uuid];
    }
    else if([msg.target_type_str isEqualToString:@"link"])
    {
        //判断 url是否包含指定字符串
        if ([self checkContainsString:msg.target_url] == YES) {
            //检查版本是否能响应 requestReview 并且是包含@"itms-apps://itunes.apple.com"
            if ([msg.target_url containsString:@"itms-apps://itunes.apple.com"] && [SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
                [SKStoreReviewController requestReview];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:msg.target_url]];
            }
        }else{
            [self WebViewAction:msg.target_url];
        }
    }
    else if([msg.target_type_str isEqualToString:@"self"])
    {
        [self checkProfile];
    }else if([msg.target_type_str isEqualToString:@"post_private"])
    {
        [self postDetailPrivateAction:msg.target_uuid];
    }
}

#pragma checkStringAction
-(BOOL)checkContainsString:(NSString *)str{
    if ([str containsString:@"https://itunes.apple.com"]
        ||[str containsString:@"itms-apps://itunes.apple.com"]
        ||[str containsString:@"http://itunes.apple.com"]
        ) {
        return YES;
    }
    return NO;
}


#pragma msgAction
-(void)postDetailNormalAction:(NSString*)targetUuid{
    
    YZPostDetailVC *vc = [YZPostDetailVC new];
    vc.postUuid = targetUuid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)postDetailPrivateAction:(NSString*)targetUuid{
    YZPostDetailVC *vc = [YZPostDetailVC new];
    vc.postUuid = targetUuid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)groupDetailAction:(NSString*)targetUuid{
    //从消息页群详情进去的时候 要判断是否是群成员 再根据管理员对群组的一些设置来决定用户能够使用的功能
    WYGroupDetailVC *vc = [WYGroupDetailVC new];
    vc.groupUuid = targetUuid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)relationshipAction:(NSString *)authorUuid{
    //这里不需要包到里边 本地更新数据即可  不需要等数据
    WYUserVC *vc = [WYUserVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.userUuid = authorUuid;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)groupInviteAction:(NSString*)targetUuid{
    WYAcceptInviteVC *vc = [WYAcceptInviteVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.targetUuid = targetUuid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)groupApplication:(NSString *)targetUuid{
    WYHandleApplicationVC *vc = [WYHandleApplicationVC new];
    vc.targetUuid = targetUuid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)WebViewAction:(NSString*)url{
    WYWebViewVC *vc = [WYWebViewVC new];
    vc.targetUrl = url;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkProfile
{
    //去个人资料的编辑页面
    WYSelfDetailEditing *profile = [[WYSelfDetailEditing alloc] init];
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
}

#pragma Navi actions
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)subscribePostAction{
    WYSubscribeVC *vc = [WYSubscribeVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
