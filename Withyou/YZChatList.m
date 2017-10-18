//
//  YZChatVC.m
//  Withyou
//
//  Created by ping on 2017/3/17.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZChatList.h"
#import <Masonry.h>
#import "YZChatViewController.h"
#import "YZChatCollectionViewCell.h"
#import "YZChat.h"
#import "WYPushMsgTool.h"
#import "YZSearchBar.h"
#import "NSString+WYStringEx.h"
#import "WYSelfFriendListsVC.h"
#import "WYChatApi.h"
#import "WYPlaceholderView.h"

#define searchBarHeight 30

@interface YZChatList ()<UIGestureRecognizerDelegate,EMChatManagerDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat previousX;
    BOOL chatViewShowed;
}
@property (nonatomic, weak) YZChatViewController *chatVC;
@property (nonatomic, weak) YZSearchBar *searchBar;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong) WYPlaceholderView *placeholderView;
@end

@implementation YZChatList

static NSString * headerViewIdentifier = @"headerViewIdentifier";

- (void)setBadgeValue:(int)badgeValue {
    _badgeValue = badgeValue;
    [self _setTabbarItemBadge];
}
- (instancetype)init {
    if(self = [super init]) {
        
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        /*
         发送的时候才通知后端 这个弃用了
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatBeginNotification:) name:kNotificationYZChatBegin object:nil];
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageNotification:) name:kNotificationYZChatSendMessage object:nil];
        
        // 从服务器更新聊天列表 设置badge
        [self initData];
    }
    return self;
}

- (NSMutableArray *)dataSource {
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNaviBar];
    [self setupCollectionView];
    [self setUpPlaceholderView];
    [self addCollectionViewHeaderRefresh];
}

-(void)addCollectionViewHeaderRefresh{
    [self.collectionView addHeaderRefresh:^{
        [self.dataSource removeAllObjects];
        [self initData];
    }];
}

- (void)initData {
    
    __weak YZChatList *weakSelf = self;
    // 先获取缓存列表
    [self.dataSource addObjectsFromArray:[YZChat getArchiverData]];
    // 更新数据
    [WYChatApi getChatList:^(NSArray *modals) {
        
        [weakSelf.collectionView endHeaderRefresh];
        
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.dataSource];
        
        NSInteger i = modals.count;
        int badgeValue = 0;
        // 倒叙遍历
        while (i--) {
            WYUser *user = modals[i];
            EMConversation * conversation = [[EMClient sharedClient].chatManager getConversation:user.easemob_username type:EMConversationTypeChat createIfNotExist:YES];
            badgeValue = badgeValue + [conversation unreadMessagesCount];

            BOOL exist = NO;
            for (WYUser *old in self.dataSource) {
                if([old.uuid isEqualToString:user.uuid]) {
                    // 更新用户信息
                    [temp replaceObjectAtIndex:[temp indexOfObject:old] withObject:user];
                    exist = YES;
                    break;
                }
            }
            // 如果不存在可能是最新的 加入到数组最前面
            if(exist == NO) {
                [temp insertObject:user atIndex:0];
            }
        }
        self.dataSource = temp;
        self.badgeValue = badgeValue;
        [self.collectionView reloadData];
    }];
}

- (void)setupCollectionView {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(chatItemW, chatItemH);
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(15 , 0, 15, 0);
    UICollectionView *collectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kAppScreenHeight - kDefaultBarHeight - kStatusAndBarHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = kRGB(232, 240, 244);
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [collectionView registerClass:[YZChatCollectionViewCell class] forCellWithReuseIdentifier:@"YZChatCollectionViewCell"];
    collectionView.alwaysBounceVertical =YES;
    self.collectionView = collectionView;
}

-(void)setUpPlaceholderView{
    _placeholderView = [[WYPlaceholderView alloc]initWithImage:@"chat_placeHolderView" msg:@"还没有聊天记录哦" imgW:75 imgH:70];
    _placeholderView.frame = self.collectionView.bounds;
    [self.collectionView addSubview:_placeholderView];
}

-(void)setNaviBar{

   UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"chatFriendlist"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(toFriendsListAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navi_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(toSearchAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)toSearchAction{
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSearchAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    YZSearchBar *searchBar = [[YZSearchBar alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth - 20, searchBarHeight)];
    [searchBar becomeFirstResponder];
    searchBar.placeholder = @"搜索好友";
    [searchBar addTarget:self action:@selector(onSearchBarChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBar addTarget:self action:@selector(onSearchBarReturenKeyClick:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.searchBar = searchBar;

    self.navigationItem.titleView = self.searchBar;
}

-(void)cancelSearchAction{
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
    [self.collectionView reloadData];
    self.navigationItem.titleView = nil;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navi_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(toSearchAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //结束搜索 恢复数据 如果不大于0 说明以及恢复过数据了
    if (self.searchArray && self.searchArray.count > 0) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:self.searchArray];
        self.searchArray = nil;
        [self.collectionView reloadData];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak YZChatList *weakSelf = self;
    YZChatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YZChatCollectionViewCell" forIndexPath:indexPath];
    WYUser *user = self.dataSource[indexPath.row];
    [cell rebuildWith:user];
    
    
    cell.removeMessageBlock = ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要删除该条会话吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[EMClient sharedClient].chatManager deleteConversation:@"8001" isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError){
                // 删除服务器上的消息后，本地的消息更新了
                [weakSelf reMoveUserToDataSource:user];
                [weakSelf.collectionView reloadData];
                
                [WYChatApi deleteUserChat:user.uuid Block:^(BOOL haveDelete) {
                    if (haveDelete) {
                    }else{
                    }
                }];
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.dataSource.count > 0) {
        _placeholderView.hidden = YES;
        self.collectionView.backgroundColor = kRGB(232, 240, 244);
    }else{
        _placeholderView.hidden = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return self.dataSource.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYUser *user = self.dataSource[indexPath.row];
    [self startChatWithUser:user pushBy:nil];
}

#pragma mark- NSUserNotification
/*
 发送的时候才通知后端 这个弃用了
 - (void)chatBeginNotification:(NSNotification *)noti {
 [self _inserUserToDataSource:noti.object];
 [self.collectionView reloadData];
 }
 */

//发送消息
- (void)sendMessageNotification:(NSNotification *)noti {
    [self _inserUserToDataSource:noti.object];
    [self.collectionView reloadData];
    [WYChatApi chatWithUser:noti.object];
}

#pragma mark- EMChatManagerDelegate
//收到消息
- (void)messagesDidReceive:(NSArray *)aMessages {
    UIViewController *vc = [WYUtility getCurrentVC];
    YZChatViewController *chatVC = nil;
    if([vc isKindOfClass:[YZChatViewController class]]) {
        chatVC = (YZChatViewController *)vc;
    }
    for (EMMessage *message in aMessages) {
        // 正在聊天的对象 不设置badge
        if([[chatVC.user.easemob_username uppercaseString] isEqualToString:[message.from uppercaseString]] == NO) {
            self.badgeValue = _badgeValue + 1;
        }
        // 发送本地通知后者振动一下
        [WYPushMsgTool handleActionOnReceiveMessage:message];
        //是否是 未聊过天的 对象发送而来
        BOOL isNewConversation = YES;
        for (WYUser *user in self.dataSource) {
            // 大小写可能不一致 需要转换
            if([[user.easemob_username uppercaseString] isEqualToString:[message.from uppercaseString]]) {
                isNewConversation = NO;
                
                //
                [WYChatApi chatWithUser:user];
                [self _inserUserToDataSource:user];
                break;
            }
        }
        
        if(isNewConversation == YES) {
            // 如果是未聊天过的 请求一下
            [WYUser getUserByEasemobName:[message.from uppercaseString] blcok:^(WYUser *user) {
                if(user) {
                    
                    //
                    [WYChatApi chatWithUser:user];
                    [self _inserUserToDataSource:user];
                    [self.collectionView reloadData];
                }
            }];
        }else {
            [self.collectionView reloadData];
        }
    }
}


#pragma mark- UITextFieldChange
- (void)onSearchBarReturenKeyClick:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (void)onSearchBarChange:(UITextField *)textField {
    // 先缓存所有数据
    if(self.searchArray == nil) {
        self.searchArray = [NSArray arrayWithArray:self.dataSource];
    }
    // 清空数据源
    [self.dataSource removeAllObjects];
    // 都转为小写 去匹配大小写
    NSString *lowerText = [textField.text lowercaseString];
    NSString *text = [lowerText chChangePin];
    
    if(text.length > 0) {
        NSMutableArray *tmp = [NSMutableArray array];
        // 遍历缓存的所有数据
        for (WYUser *user in self.searchArray) {
            if([[[user.fullName lowercaseString] chChangePin] containsString:text]) {
                [tmp addObject:user];
            }
        }
        [self.dataSource addObjectsFromArray:tmp];
    }else {
        // 从缓存中恢复所有数据
        [self.dataSource addObjectsFromArray:self.searchArray];
        self.searchArray = nil;
    }
    [self.collectionView reloadData];
}


- (void)startChatWithUser:(WYUser *)user pushBy:(UINavigationController *)nav {
    // 重新计算badge
    [self calculateUnreadMessagesCount:user];
    
//        [self startChatWithUser:user];
    YZChatViewController *chatVc = [[YZChatViewController alloc] initWithUser:user];
    chatVc.hidesBottomBarWhenPushed = YES;
    if(nav) {
        [nav pushViewController:chatVc animated:YES];
    }else {
        [self.navigationController pushViewController:chatVc animated:YES];
    }

    [self.collectionView reloadData];
}

- (void)calculateUnreadMessagesCount:(WYUser *)user {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int badgeValue = 0;
        for (WYUser *item in self.dataSource) {
            if([item.uuid isEqualToString:user.uuid]) {
                continue;
            }
            EMConversation * conversation = [[EMClient sharedClient].chatManager getConversation:item.easemob_username type:EMConversationTypeChat createIfNotExist:YES];
            badgeValue = badgeValue + [conversation unreadMessagesCount];
        }
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            self.badgeValue = badgeValue;
        });
    });
}

// 插入回话对象 到第一个,去除重复的
- (void)_inserUserToDataSource:(WYUser *)user {
    if(self.dataSource.count == 0) {
        [self.dataSource insertObject:user atIndex:0];
    }else {
        for (WYUser * u in self.dataSource) {
            if([user.uuid isEqualToString:u.uuid]) {
                [self.dataSource removeObject:u];
                break;
            }
        }
        [self.dataSource insertObject:user atIndex:0];
    }
    // 这里的list 一直是最新的更换了顺序的, 在这里缓存聊天列表
    [YZChat updateChatList:[self.dataSource copy]];
}
//删除会话
-(void)reMoveUserToDataSource:(WYUser *)user{
    [self.dataSource removeObject:user];
    // 这里的list 一直是最新的更换了顺序的, 在这里缓存聊天列表
    [YZChat updateChatList:[self.dataSource copy]];

}

- (void)_setTabbarItemBadge {
    RootTabBarController *tabbar = [WYUtility tabVC];
    UITabBarItem *item = tabbar.tabBar.items[3];
    if( _badgeValue <= 0) {
        [item setBadgeValue:nil];
    }else {
        [item setBadgeValue:[NSString stringWithFormat:@"%d",_badgeValue]];
    }
}

-(void)toFriendsListAction{
    WYSelfFriendListsVC *vc = [WYSelfFriendListsVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
