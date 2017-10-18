//
//  WYArticleDetailVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYArticleDetailVC.h"
#import "YZCommentCell.h"
#import "WYArticleDetailHeaderView.h"
#import "WYArticleAPI.h"
#import <WebKit/WebKit.h>
#import "WYArticleCommentStarVC.h"
#import "WYBaseMentionTextVC.h"
#import "WYUserVC.h"
#import "YZMapViewController.h"
#import "WYPostApi.h"

@interface WYArticleDetailVC ()<UITableViewDelegate, UITableViewDataSource, YZCommentCellDelegate, WKNavigationDelegate, WKUIDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)WYArticleDetailHeaderView *headerView;
@property(nonatomic, strong)NSMutableArray *commentList;
@property(nonatomic, strong)NSMutableArray *starList;
@property(nonatomic, strong)UIButton *commentNumBtn;
@property(nonatomic, strong)UIButton *starNumBtn;
@property(nonatomic, strong)UIButton *loadMoreBtn;
@property(nonatomic, assign)BOOL hasMoreComments;
@end

@implementation WYArticleDetailVC
/*
 when onLeft value changed should reloadData
 return commentCell or starCell
 */

-(NSMutableArray *)commentList{
    if (!_commentList) {
        _commentList = [NSMutableArray array];
    }
    return _commentList;
}

-(NSMutableArray *)starList{
    if (!_starList) {
        _starList = [NSMutableArray array];
    }
    return _starList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    [self setUpTableView];
    [self setUpTableHeaderView];
    [self setUpTabBar];
    [self initData];
}

-(void)initData{
    _hasMoreComments = NO;
    __weak WYArticleDetailVC *weakSelf = self;
    [WYArticleAPI requestArticleDetail:self.article.uuid callBack:^(NSArray *starList, NSArray *commentList) {
        if (starList)       [weakSelf.starList addObjectsFromArray:starList];
        if (commentList)    [weakSelf.commentList addObjectsFromArray:[weakSelf invertedOrder:commentList]];
        if (commentList.count >= 10) {
            weakSelf.hasMoreComments = YES;
        }
        if(starList || commentList) [weakSelf.tableView reloadData];
    }];
}

-(void)loadMoreAction{
    __weak WYArticleDetailVC *weakSelf = self;
    YZPostComment *comment = [self.commentList firstObject];
    [WYArticleAPI listCommentListWithArticle:self.article.uuid time:comment.created_at_float callback:^(NSArray *commentList, BOOL hasMore) {
        weakSelf.hasMoreComments = hasMore;
        if (commentList) {
            NSMutableArray *tempArr = [NSMutableArray array];
            [tempArr addObjectsFromArray:[weakSelf invertedOrder:commentList]];
            [tempArr addObjectsFromArray:weakSelf.commentList];
            weakSelf.commentList = [tempArr mutableCopy];
            [weakSelf.tableView reloadData];
        }
    }];
}

-(void)setNavigationBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight - 50) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)setUpTableHeaderView{
    _headerView = [[WYArticleDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 0)];
    _headerView.webView.UIDelegate = self;
    _headerView.webView.navigationDelegate = self;
    [_headerView setHeaderView:self.article];
    self.tableView.tableHeaderView = _headerView;
}

-(void)setUpTabBar{
    UIToolbar *toobar = [[UIToolbar alloc]init];
    toobar.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:toobar];
    [toobar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(50);
    }];
    
    UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.article.starred) {
        starBtn.selected = YES;
    }
    [toobar addSubview:starBtn];
    starBtn.frame = CGRectMake(0, 0, kAppScreenWidth/2.0, 50);
    [starBtn setImage:[UIImage imageNamed:@"mediaDetailArticleStar"] forState:UIControlStateNormal];
    [starBtn setImage:[UIImage imageNamed:@"mediaDetailArticleStarHighlight"] forState:UIControlStateSelected];
    [starBtn addTarget:self action:@selector(starClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toobar addSubview:commentBtn];
    commentBtn.frame = CGRectMake(kAppScreenWidth/2.0, 0, kAppScreenWidth/2.0, 50);
    [commentBtn setImage:[UIImage imageNamed:@"mediaDetailArticleComment"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.hasMoreComments) {
        return 80;
    }
    return 40.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WYArticle *article = self.article;
    NSString *commentTitle = [NSString stringWithFormat:@"评论 %d",article.comment_num];
    NSString *starTitle = [NSString stringWithFormat:@"星标 %d",article.star_num];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 40)];
    [view addSubview:topView];
    [topView setBackgroundColor:UIColorFromHex(0xf5f5f5)];
    _commentNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentNumBtn setTitle:commentTitle forState:UIControlStateNormal];
    _commentNumBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:0.4];
    [_commentNumBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    [_commentNumBtn addTarget:self action:@selector(commentNumClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_commentNumBtn];
    [_commentNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(0);
        make.height.equalTo(40);
    }];
    
    _starNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_starNumBtn setTitle:starTitle forState:UIControlStateNormal];
    _starNumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_starNumBtn setTitleColor:kRGB(153, 153, 153) forState:UIControlStateNormal];
    [_starNumBtn addTarget:self action:@selector(starNumClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_starNumBtn];
    [_starNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_commentNumBtn.mas_right).equalTo(20);
        make.top.equalTo(0);
        make.height.equalTo(40);
    }];
    
    if (self.hasMoreComments){
        view.height = 80;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"加载更多评论" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(40);
            make.height.equalTo(40);
        }];
    }
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YZPostComment *postComment = self.commentList[indexPath.row];
    YZCommentFrame *frame = [[YZCommentFrame alloc]initWithComment:postComment];
    return frame.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YZCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"YZCommentCell"];
    if (commentCell == nil) {
        commentCell = [[YZCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YZCommentCell"];
    }
    YZPostComment *postComment = self.commentList[indexPath.row];
    YZCommentFrame *frame = [[YZCommentFrame alloc]initWithComment:postComment];
    commentCell.delegate = self;
    commentCell.comment = frame;
    debugLog(@"%@",frame.comment.uuid);
    return commentCell;
}

#pragma item actions
-(void)starClick:(UIButton *)sender{
    if (sender.selected == YES) {
        sender.selected = NO;
        [WYArticleAPI cancelStarToArticle:self.article.uuid callback:^(NSInteger status) {
            if (status == 204) {
                sender.selected = NO;
                debugLog(@"cancel success");
            }else{
                sender.selected = YES;
                debugLog(@"cancel fail %ld",status);
            }
        }];
    }else{
        sender.selected = YES;
        [WYArticleAPI addStarToArticle:self.article.uuid callback:^(NSInteger status) {
            if (status == 201) {
                sender.selected = YES;
                debugLog(@"add success");
            }else{
                sender.selected = NO;
                debugLog(@"add fail %ld",status);
            }
        }];
    }
    
}

-(void)commentClick:(UIButton *)sender{
    WYBaseMentionTextVC *vc = [WYBaseMentionTextVC new];
    vc.navigationTitle = @"添加评论";

    __weak WYArticleDetailVC *weakSelf = self;
    vc.myBlock = ^(NSAttributedString *text, NSArray *mention) {
        [WYArticleAPI addCommentToArticle:weakSelf.article.uuid content:text.string reply:nil replyAuthorUuid:nil callback:^(YZPostComment *comment) {
            if (comment) {
                [weakSelf.commentList addObject:comment];
                [weakSelf.tableView reloadData];
            }
        }];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)commentNumClick:(UIButton *)sender{
    
}

-(void)starNumClick:(UIButton *)sender{
    WYArticleCommentStarVC *vc = [WYArticleCommentStarVC new];
    vc.tempList = [self.starList copy];
    vc.article = self.article;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSArray *)invertedOrder:(NSArray *)arr{
    NSMutableArray *ma = [NSMutableArray array];
    long len = arr.count - 1;
    for (long i = len; i >= 0; i --) {
        [ma addObject:arr[i]];
    }
    return [ma copy];
}

// reset height
#pragma mark -
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {

    [webView evaluateJavaScript:@"document.body.offsetHeight"
              completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                  if (!error) {
                      //webView height
                      CGFloat webViewH = [result floatValue];
                      [webView mas_makeConstraints:^(MASConstraintMaker *make) {
                          make.height.equalTo(webViewH);
                      }];
                      
                      _headerView.height += webViewH;
                      [_tableView beginUpdates];
                      self.tableView.tableHeaderView = _headerView;
                      [_tableView endUpdates];
                  }
      }];
}


//个人
- (void)onIconClick: (YZPostComment *)comment{

}
//回复
- (void)replyComment: (YZPostComment *)comment{
    WYBaseMentionTextVC *vc = [WYBaseMentionTextVC new];
    vc.navigationTitle = @"添加评论";
    
    __weak WYArticleDetailVC *weakSelf = self;
    vc.myBlock = ^(NSAttributedString *text, NSArray *mention) {
        [WYArticleAPI addCommentToArticle:weakSelf.article.uuid content:text.string reply:comment.uuid replyAuthorUuid:comment.author.uuid callback:^(YZPostComment *comment) {
            if (comment) {
                [weakSelf.commentList addObject:comment];
                [weakSelf.tableView reloadData];
            }
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)atStringClick:(YZMarkText *)mark {
    if(mark.content_type == 1) {
        
        WYUserVC *vc = [WYUserVC new];
        
        if([mark.content_uuid isEqualToString:kuserUUID])
        {
            vc.user = kLocalSelf;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            WYUserVC *vc = [WYUserVC new];
            WYUser *user = [WYUser queryUserWithUuid:mark.content_uuid];
            if(user) {
                vc.user = user;
            }else {
                vc.userUuid = mark.content_uuid;
            }
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(mark.content_type == 2) {
        // 打开地图
        YZMapViewController *map = [[YZMapViewController alloc] init];
        map.latitude = mark.lat;
        map.longitude = mark.lng;
        map.pointName = mark.content_name;
        map.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:map animated:YES];
    }
    
}
//删除评论 或者举报评论
-(void)showAlertAction:(YZPostComment *)comment{
    
    //如果是自己的帖子 或者是自己的评论 可以删除 之外的显示举报
    if ([comment.author.uuid isEqualToString:kuserUUID]) {
        
        //删除
        __weak WYArticleDetailVC *weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要删除该条评论吗?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf deleteYZCommentFrameFromArr:weakSelf.commentList comment:comment];

        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        //举报
        __weak WYArticleDetailVC *weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要举报该条评论吗?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"举报该评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf reportPostComement:comment];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//给评论加星标
-(void)starCommentAction:(YZPostComment *)comment starBtn:(UIButton *)btn starCountLb:(UILabel *)starCountLb{
    __weak WYArticleDetailVC *weakSelf = self;
    if (comment.starred == YES) {
        //去星标
        btn.selected = NO;
        starCountLb.textColor = UIColorFromHex(0x999999);
        
        if (comment.star_num -1 > 0) {
            starCountLb.text = [NSString stringWithFormat:@"%d",comment.star_num - 1];
        }else{
            starCountLb.text = @"";
        }
        
        [WYPostApi cancelStarToCommentUUid:comment.uuid Block:^(NSInteger status) {
            
            if (status == 204) {
                //去星标成功
                for (int i = 0; i < weakSelf.commentList.count; i ++) {
                    YZPostComment *currentComment = weakSelf.commentList[i];
                    if ([currentComment.uuid isEqualToString:comment.uuid]) {
                        comment.star_num -=1;
                        comment.starred = NO;
                        [weakSelf.commentList replaceObjectAtIndex:i withObject:comment];
                        [weakSelf.tableView reloadData];
                        break;
                    }
                }
            }else if (status == 290){
                btn.selected = YES;
                starCountLb.text = [NSString stringWithFormat:@"%d",comment.star_num];
                starCountLb.textColor = UIColorFromHex(0x00B2E1);
                
            }else{
                btn.selected = YES;
                starCountLb.text = [NSString stringWithFormat:@"%d",comment.star_num];
                starCountLb.textColor = UIColorFromHex(0x00B2E1);
                
            }
        }];
        
    }else{
        //加星标
        btn.selected = YES;
        starCountLb.text = [NSString stringWithFormat:@"%d",comment.star_num + 1];
        starCountLb.textColor = UIColorFromHex(0x00B2E1);
        
        [WYPostApi addStarToCommentUUid:comment.uuid author_uuid:kuserUUID Block:^(NSInteger status) {
            
            if (status == 201) {
                //加星标成功
                for (int i = 0; i < weakSelf.commentList.count; i ++) {
                    YZPostComment *currentComment = weakSelf.commentList[i];
                    if ([currentComment.uuid isEqualToString:comment.uuid]) {
                        comment.starred = YES;
                        comment.star_num +=1;
                        [weakSelf.commentList replaceObjectAtIndex:i withObject:comment];
                        [self.tableView reloadData];
                        break;
                    }
                }
            }else{
                //提示 其他问题
                btn.selected = NO;
                starCountLb.text = [NSString stringWithFormat:@"%d",comment.star_num];
                starCountLb.textColor = UIColorFromHex(0x999999);
                
            }
        }];
    }
}

-(void)reportPostComement:(YZPostComment*)comment{
    
    NSArray *titleArr = @[@"泄露隐私", @"人身攻击", @"色情文字", @"违反法律", @"垃圾信息", @"其他",@"取消"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"举报分类" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < titleArr.count; i ++) {
        if (i < titleArr.count -1) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:titleArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [YZPostComment reportPostComment:comment.uuid type:@(i + 1)];
            }];
            [alert addAction:action];
        }else{
            //取消
            UIAlertAction *action = [UIAlertAction actionWithTitle:titleArr[i] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:action];
        }
    }
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)deleteYZCommentFrameFromArr:(NSMutableArray *)mutArr comment:(YZPostComment *)comment{
    
    [YZPostComment deletePostComment:comment.uuid Block:^(long status) {
        if (status == 204) {
            for (int i = 0; i < mutArr.count; i ++) {
                YZPostComment *currentComment = mutArr[i];
                if ([currentComment.uuid isEqualToString:comment.uuid]) {
                    [mutArr removeObjectAtIndex:i];
                    [self.tableView reloadData];
                    break;
                }
            }
        }else{
            [WYUtility showAlertWithTitle:@"未成功删除"];
        }
    }];
}
@end
