
//
//  WYDescoverSearchVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYDescoverSearchVC.h"
#import "WYSearchFriendCollectionViewCell.h"
#import "WYUserVC.h"
#import "WYReccomendUser.h"
#import "WYFollow.h"
#import "WYAddFriendVC.h"
#import "WYSelfDetailEditing.h"
#import "YZLocalPhoneTipVC.h"
#import "WYRecommendUserApi.h"

@interface WYDescoverSearchVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *ReccomendUserArr;
@property(nonatomic, strong)NSMutableArray *searchArr;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;
@property(nonatomic, strong)UIView *searchView;
@end

@implementation WYDescoverSearchVC

#define itemW ((kAppScreenWidth - 15)/2)
#define itemH (itemW + 48)
#define ksearchBarHeight 80

-(NSMutableArray *)ReccomendUserArr{
    if (_ReccomendUserArr == nil) {
        _ReccomendUserArr = [NSMutableArray array];
    }
    return _ReccomendUserArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBar];
    [self setUpCollectionView];
    [self initData];
}

-(void)setNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"查找好友";
    self.navigationItem.titleView = label;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
}



-(void)initData{
    
    __weak WYDescoverSearchVC *weakSelf = self;
    _page = 1;
    [WYRecommendUserApi listRecommendFriendsPage:self.page Block:^(NSArray *recommendArr, BOOL hasMore) {
        if (recommendArr) {
            weakSelf.page += 1;
            weakSelf.hasMore = hasMore;
            [weakSelf.ReccomendUserArr addObjectsFromArray:recommendArr];
            [weakSelf.collectionView reloadData];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
    
    [self.collectionView addFooterRefresh:^{
        
        if (!weakSelf.hasMore){
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [WYRecommendUserApi listRecommendFriendsPage:weakSelf.page Block:^(NSArray *recommendArr, BOOL hasMore) {
            if (recommendArr.count > 0) {
                weakSelf.page += 1;
                weakSelf.hasMore = hasMore;
                [weakSelf.ReccomendUserArr addObjectsFromArray:recommendArr];
                [weakSelf.collectionView reloadData];
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            [weakSelf.collectionView endFooterRefresh];
        }];
    }];
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        //设置view 不自定义只适合一个分区的情况
        
        UIView *view = [header viewWithTag:1000];
        if (view == nil) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 265)];
            [self addContent:view];
            view.tag = 1000;
            [header addSubview:view];
        }
        return header;
    }
    //如果底部视图if([kind isEqualToString:UICollectionElementKindSectionFooter])
    return nil;
}

-(void)addContent:(UIView *)view{
    
    //searchBar
    _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, ksearchBarHeight)];
    _searchView.layer.cornerRadius = 4;
    _searchView.clipsToBounds = YES;
    _searchView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [view addSubview:_searchView];
    
    
    UIView *groundView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, kAppScreenWidth - 30, ksearchBarHeight - 30)];
    groundView.backgroundColor = [UIColor whiteColor];
    groundView.layer.cornerRadius = 4;
    groundView.clipsToBounds = YES;
    [_searchView addSubview:groundView];
    
    
    UILabel *label = [UILabel new];
    label.text = @"通过手机号、用户名搜索好友";
    label.textColor = UIColorFromHex(0xc5c5c5);
    label.font = [UIFont systemFontOfSize:14];
    label.userInteractionEnabled = YES;
    [_searchView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo((12 + 7)/2.0);
        make.centerY.equalTo(0);
    }];
    
    
    UIImageView * leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_friendsearch_search"]];
    [_searchView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.right.equalTo(label.mas_left).equalTo(-7);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_searchView addGestureRecognizer:tap];
    
    //cell1
    UITableViewCell *cell1 = [UITableViewCell new];
    [view addSubview:cell1];
    [cell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchView.mas_bottom).equalTo(20);
        make.left.equalTo(0);
        make.right.equalTo(-8);
        make.height.equalTo(50);
    }];
    cell1.imageView.image = [UIImage imageNamed:@"friend search page_address list"];
    cell1.textLabel.text = @"查看通讯录中的朋友";
    cell1.textLabel.font = [UIFont systemFontOfSize:14];
    cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell1.selectionStyle =UITableViewCellSelectionStyleNone;
    //line
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 150, kAppScreenWidth - 30, 1)];
    lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [view addSubview:lineView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(findFriendsFromLocalContacts)];
    [cell1 addGestureRecognizer:tap1];

    //cell2
    UITableViewCell *cell2 = [UITableViewCell new];
    [view addSubview:cell2];
    [cell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).equalTo(12);
        make.left.equalTo(0);
        make.right.equalTo(-8);
        make.height.equalTo(50);
    }];
    cell2.imageView.image = [UIImage imageNamed:@"friend search page_share card"];
    cell2.textLabel.text = @"邀请新朋友";
    cell2.textLabel.font = [UIFont systemFontOfSize:14];
    cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell2.selectionStyle =UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendInvitationLink)];
    [cell2 addGestureRecognizer:tap2];
    
    
    //labelView
    UIView *labelView  = [[UIView alloc]initWithFrame:CGRectMake(0, 220, kAppScreenWidth, 30)];
    labelView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [view addSubview:labelView];
    UILabel *titleLb = [UILabel new];
    [labelView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    titleLb.textColor = UIColorFromHex(0xc5c5c5);
    titleLb.font = [UIFont systemFontOfSize:12];
    titleLb.text = @"你可能感兴趣的人";
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = UIColorFromHex(0xc5c5c5);
    [labelView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.right.equalTo(titleLb.mas_left).equalTo(-6);
        make.height.equalTo(1);
        make.width.equalTo(20);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = UIColorFromHex(0xc5c5c5);
    [labelView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(titleLb.mas_right).equalTo(6);
        make.height.equalTo(1);
        make.width.equalTo(20);
    }];
    
}

-(void)setUpCollectionView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //创建CollectionView
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = YES;
    
    [collectionView registerClass:[WYSearchFriendCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
}


#pragma collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.ReccomendUserArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     WYSearchFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    WYReccomendUser *reccomendUser = self.ReccomendUserArr[indexPath.row];
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:reccomendUser.user.icon_url]];
    cell.nameLb.text = reccomendUser.user.fullName;
    cell.commonLb.text = reccomendUser.recommend_reason;
    /*1 相互关注
     2 我关注这个人
     3 我查看的这个人关注我
     4 是我本身
     
     5 是二度朋友
     6 是三度朋友
     7 我们同在某个群组
     100 我们之间没有联系
     */

    if (reccomendUser.rel_to_me == 1 || reccomendUser.rel_to_me == 2) {
        cell.addIV.image = [UIImage imageNamed:@"friendsearchpage_attentioned"];
        cell.addIV.userInteractionEnabled = NO;
    }else{
        cell.addIV.image = [UIImage imageNamed:@"friendsearchpage_attention"];
        cell.addIV.userInteractionEnabled = YES;
    }
    __weak WYDescoverSearchVC *weakSelf = self;
    __weak WYSearchFriendCollectionViewCell *weakCell = cell;
    cell.addViewClick = ^{
      //发送添加关注请求
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYFollow addFollowToUuid:reccomendUser.user.uuid Block:^(WYFollow *follow,NSInteger status) {
                if (follow) {
                    //修改内存中的关系数据
                    WYReccomendUser *reccomendUser = weakSelf.ReccomendUserArr[indexPath.row];
                    if (reccomendUser.rel_to_me == 3) {
                        reccomendUser.rel_to_me = 1;
                        
                    }else if (reccomendUser.rel_to_me == 100){
                        reccomendUser.rel_to_me = 2;
                    }
                    //将图片修改
                    weakCell.addIV.image = [UIImage imageNamed:@"friendsearchpage_attentioned"];
                    weakCell.addIV.userInteractionEnabled = NO;
                    [weakSelf.collectionView reloadData];
                }else{
                    [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
                }
            }];

        } navigationController:self.navigationController];
    };
    
    return cell;
}



-(void)goToSelfEditing{
    WYSelfDetailEditing *vc = [WYSelfDetailEditing new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  FlowLayoutDelegate

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(itemW, itemH);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return  CGSizeMake(kAppScreenWidth, 265);
}

//设置分区边界, 具体看下图
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return  UIEdgeInsetsMake(15, 0, 15, 0);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
   
    return 20;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 15;
}

//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WYReccomendUser *reccomendUser = self.ReccomendUserArr[indexPath.row];
    WYUserVC *vc = [WYUserVC new];
    vc.user = reccomendUser.user;
    [self.navigationController pushViewController:vc animated:YES]; 
}

//cell反选时被调用(多选时才生效)
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark- click
-(void)tapClick{
    WYAddFriendVC *vc = [[WYAddFriendVC alloc]init];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}


#pragma actions

- (void)findFriendsFromLocalContacts{
    
    YZLocalPhoneTipVC *vc = [YZLocalPhoneTipVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)sendInvitationLink{
    __weak WYDescoverSearchVC *weakSelf = self;
    [WYUtility requireSetAccountNameOrAlreadyHasName:^{
        
        [weakSelf.view showHUDNoHide];
        [[WYHttpClient sharedClient] GET:@"api/v1/get_web_invitation_link/" parameters:nil showToastError:YES callback:^(id responseObject) {
            [weakSelf.view hideAllHUD];
            if(responseObject){
                //icon
                NSURL *iconUrl = [NSURL URLWithString:kLocalSelf.icon_url];
                NSData *data = [NSData dataWithContentsOfURL:iconUrl];
                UIImage *image = [UIImage imageWithData:data];
                //标题
                NSString *title = [NSString stringWithFormat:@"%@邀请你加入与子",kLocalSelf.fullName];
                //url
                NSString *url = [responseObject objectForKey:@"url"];
                NSURL *urlToShare = [NSURL URLWithString:url];
                
                NSArray *activityItems = @[title,urlToShare,image];
                
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint,]; //UIActivityTypePostToTwitter, UIActivityTypePostToWeibo
                [weakSelf presentViewController:activityVC animated:TRUE completion:nil];
            }else{
                [OMGToast showWithText:@"网络不给力,请检查网络设置！"];
            }
        }];
    } navigationController:self.navigationController];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
