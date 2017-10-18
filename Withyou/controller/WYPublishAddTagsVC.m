//
//  WYPublishAddTagsVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/19.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPublishAddTagsVC.h"
#import "WYPublishTagListCell.h"
#import "WYPublishTagListSimilarCell.h"
#import "WYPostTagApi.h"
#import "WYRecommendPostTagView.h"
#import "WYPublishAddTagsTool.h"

/**
 用isSearch 来决定显示那种数据源 以及是否开启删除模式
 _textFiled.text 不能为nil 初始化的时候给了@"" 每次使用置空的时候也给@""
 */
@interface WYPublishAddTagsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, assign)AddPostTagType type;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UITextField *textFiled;
@property(nonatomic, assign)BOOL isSearch;
@property(nonatomic, strong)WYRecommendPostTagView *recommendView;
//从分享页过来的
@property(nonatomic, strong)NSMutableArray *tagObjectArr;
//类似标签
@property(nonatomic, strong)NSMutableArray *similarArr;
//推荐标签
@property(nonatomic, strong)NSMutableArray *recommendArr;
@end

@implementation WYPublishAddTagsVC

-(instancetype)initWithType:(AddPostTagType)Type{
    if (self = [super init]) {
        self.type = Type;
    }
    return self;
}

-(NSMutableArray *)recommendArr{
    if (_recommendArr == nil) {
        _recommendArr = [NSMutableArray array];
    }
    return _recommendArr;
}

-(NSMutableArray *)tagStrArr{
    if (_tagStrArr == nil) {
        _tagStrArr = [NSMutableArray array];
    }
    return _tagStrArr;
}
//二维数组
-(NSMutableArray *)tagObjectArr{
    if (_tagObjectArr == nil) {
        _tagObjectArr = [NSMutableArray array];
    }
    return _tagObjectArr;
}

-(NSMutableArray *)similarArr{
    if (_similarArr == nil) {
        _similarArr = [NSMutableArray array];
    }
    return _similarArr;
}

-(void)initData{
    NSString *str;
    if (self.type == AddTagFromPublish) {
        if (self.contentStr) {
            str = self.contentStr;
        }else{
            self.contentStr = @"";
        }
    }else{
        NSMutableArray *canRemoveArr = [NSMutableArray array];
        NSMutableArray *notCanRemoveArr = [NSMutableArray array];
        
        if ([self.post.author.uuid isEqualToString:kuserUUID]) {
            [canRemoveArr addObjectsFromArray:self.post.tag_list];
        }else{
            for (int i = 0; i < self.post.tag_list.count; i ++) {
                WYTag *tag = self.post.tag_list[i];
                if ([tag.author_uuid isEqualToString:kuserUUID]) {
                    [canRemoveArr addObject:tag];
                }else{
                    [notCanRemoveArr addObject:tag];
                }
            }
        }
        //保证二位数组的外层为2
        [self.tagObjectArr addObject:canRemoveArr];
        [self.tagObjectArr addObject:notCanRemoveArr];
        
        str = self.post.content;
    }
    
    //请求推荐标签
    __weak WYPublishAddTagsVC *weakSelf = self;
    [WYPostTagApi recommendPostTag:str Block:^(NSArray *recommendStrArr) {
        if (recommendStrArr.count > 0) {
            weakSelf.recommendView = [weakSelf myrecommendView:recommendStrArr];
            [weakSelf.recommendArr addObjectsFromArray:recommendStrArr];
            [weakSelf.tableView reloadData];
        }
    }];
}

//需要提前算出来 因为heigh for section header 比 view for section Header 先执行
-(WYRecommendPostTagView*)myrecommendView:(NSArray *)tagArr{
    WYRecommendPostTagView *view = [[WYRecommendPostTagView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 0) title:@"推荐标签" TagsArr:tagArr];
    __weak WYPublishAddTagsVC *weakSelf = self;
    view.buttonSelectedClick = ^(NSInteger index) {
        NSString *tempStr = tagArr[index];

        //防止有重复的标签
        NSMutableArray *tempArr;
        if (self.type == AddTagFromPublish) {
            tempArr = self.tagStrArr;
        }else{
            NSMutableArray *ma = [NSMutableArray array];
            for (int i = 0; i < self.tagObjectArr.count; i++) {
                [ma addObjectsFromArray:self.tagObjectArr[i]];
            }
            tempArr = ma;
        }
        if ([WYPublishAddTagsTool strIsRepeated:tempStr arr:tempArr] || tempArr.count >= 10) {
            return;
        }
        
        //可以添加
        if (weakSelf.type == AddTagFromPublish) {
            [self.tagStrArr addObject:tempStr];
            _textFiled.text = @"";
            [_textFiled resignFirstResponder];
            [self.tableView reloadData];
        }else{
            //将对应的标签 添加进来
            [WYPostTagApi addPostTag:self.post.uuid tags:@[tempStr] Block:^(NSArray *addedArr) {
                if (addedArr) {
                    if ([self.post.author.uuid isEqualToString:kuserUUID]) {
                        [weakSelf.tagObjectArr[0] addObjectsFromArray:addedArr];
                    }else{
                        for (int i = 0; i < addedArr.count; i++) {
                            WYTag *tag = addedArr[i];
                            if ([tag.author_uuid isEqualToString:kuserUUID]) {
                                [weakSelf.tagObjectArr[0] addObject:tag];
                            }else{
                                [weakSelf.tagObjectArr[1] addObject:tag];
                            }
                        }
                    }
                    //发送通知 让所有的post页面 添加这个标签
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (int i = 0; i < weakSelf.tagObjectArr.count; i ++) {
                        [tempArr addObjectsFromArray:weakSelf.tagObjectArr[i]];
                    }
                    weakSelf.post.tag_list = tempArr;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":weakSelf.post}];
                    weakSelf.textFiled.text = @"";
                    [weakSelf.textFiled resignFirstResponder];
                    [weakSelf.tableView reloadData];
                }
            }];
        }
    };
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加标签";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self setNaviItem];
    [self setUpTableView];
    [self setUpHeaderView];
    [self registerNoti];
}

-(void)registerNoti{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
   
    if (self.publishTagsClick) {
        if (self.type == AddTagFromPublish) {
            self.publishTagsClick([self.tagStrArr                                                                                                                                                                                                                                                                                copy]);
        }else{
            self.publishTagsClick([self.tagObjectArr                                                                                                                                                                                                                                                                                copy]);
        }
    }
}

-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[WYPublishTagListCell class] forCellReuseIdentifier:@"WYPublishTagListCell"];
    [_tableView registerClass:[WYPublishTagListSimilarCell class] forCellReuseIdentifier:@"WYPublishTagListSimilarCell"];

    [self.view addSubview:_tableView];
}

-(void)setUpHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 70)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, kAppScreenWidth - 15 - 20 - 90, 40)];
    [view addSubview:borderView];
    borderView.layer.cornerRadius = 4;
    borderView.clipsToBounds = YES;
    borderView.layer.borderWidth = 1;
    borderView.layer.borderColor = kRGB(197, 197, 197).CGColor;

    _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, kAppScreenWidth - 15 - 20 - 90 - 5, 40)];
    _textFiled.placeholder = @"总共能添加10个标签哦";
    _textFiled.text = @"";
    [borderView addSubview:_textFiled];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 4;
    button.clipsToBounds = YES;
    button.backgroundColor = kRGB(43, 161, 212);
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(kAppScreenWidth - 90, 15, 75, 40);
    //点击事件
    [button addTarget:self action:@selector(addTagAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    self.tableView.tableHeaderView = view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //有分区 就一定给了 header 没有header 分区也没有给 高度这里是不用再细分了
    if (!_isSearch) {
        if (self.recommendArr.count > 0) {
            if (section == 0) {
                return _recommendView.height;
            }else{
                return 30;
            }
        }else{
            return 30;
        }
    }else{
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger i = 0;
    if (!_isSearch) {
        if (self.recommendArr.count > 0) {
            i = i + 1;
        }
        if (self.type == AddTagFromPublish) {
            if (self.tagStrArr.count >0) {
                i = i + 1;
            }
        }else{
            if ([self.tagObjectArr[0] count] > 0) {
                i = i + 1;
            }
            if ([self.tagObjectArr[1] count]) {
                i = i + 1;
            }
        }
    }else{
        if (self.similarArr.count > 0) {
            i = i + 1;
        }
    }
    return i;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!_isSearch) {
        if (self.type == AddTagFromPublish) {
            if (self.recommendArr.count > 0) {
                if (section == 0) {
                    return self.recommendView;
                }else{
                    if (self.tagStrArr.count > 0) {
                        return [self tagViewWithText:@"我的标签"];
                    }
                }
            }else{
                if (section == 0) {
                    if (self.tagStrArr.count > 0) {
                        return [self tagViewWithText:@"我的标签"];
                    }
                }
            }
        }else{
            if (self.recommendArr.count > 0) {
                if (section == 0) {
                    return self.recommendView;
                }else{
                    if ([self.tagObjectArr[0] count] > 0) {
                        if (section == 1) {
                            return [self tagViewWithText:@"我的标签"];
                        }else{
                            return [self tagViewWithText:@"TA的标签"];
                        }
                    }else{
                        if (self.tagObjectArr[1] > 0) {
                            return [self tagViewWithText:@"TA的标签"];
                        }
                    }
                }
            }else{
                if ([self.tagObjectArr[0] count] > 0) {
                    if (section == 0) {
                        return [self tagViewWithText:@"我的标签"];
                    }else{
                        return [self tagViewWithText:@"TA的标签"];
                    }
                }else{
                    if (self.tagObjectArr[1] > 0) {
                        return [self tagViewWithText:@"TA的标签"];
                    }
                }
            }
        }
    }else{
        if (self.similarArr.count > 0) {
            return [self tagViewWithText:@"相关标签"];
        }
    }
    return [UIView new];
}

-(UIView *)tagViewWithText:(NSString *)text{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 30)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    UILabel *titleLb = [UILabel new];
    titleLb.font = [UIFont systemFontOfSize:12];
    titleLb.textColor = kRGB(153, 153, 153);
    [view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(8);
    }];
    titleLb.text = text;
    return view;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isSearch) {
        return self.similarArr.count;
    }else{
        if (self.type == AddTagFromPublish) {
            if (self.recommendArr.count > 0) {
                if (section == 0) {
                    return 0;
                }else{
                    if (self.tagStrArr.count > 0) {
                        return self.tagStrArr.count;
                    }
                }
            }else{
                if (self.tagStrArr.count > 0) {
                    return self.tagStrArr.count;
                }
            }
        }else{
            if (self.recommendArr.count > 0) {
                if (section == 0) {
                    return 0;
                }else{
                    if ([self.tagObjectArr[0] count] > 0) {
                        if (section == 1) {
                            return [self.tagObjectArr[0] count];
                        }else{
                            return [self.tagObjectArr[1] count];
                        }
                    }else{
                        if (self.tagObjectArr[1] > 0) {
                            return [self.tagObjectArr[1] count];
                        }
                    }
                }
            }else{
                if ([self.tagObjectArr[0] count] > 0) {
                    if (section == 0) {
                        return [self.tagObjectArr[0] count];
                    }else{
                        return [self.tagObjectArr[1] count];
                    }
                }else{
                    if (self.tagObjectArr[1] > 0) {
                        return [self.tagObjectArr[1] count];
                    }
                }
            }
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSearch) {

        WYPublishTagListSimilarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYPublishTagListSimilarCell" forIndexPath:indexPath];
        cell.iconIV.image = [UIImage imageNamed:@"publishTag"];
        NSDictionary *dic = self.similarArr[indexPath.row];
        cell.titleLb.text = [dic objectForKey:@"name"];
        [cell lineView];
        return cell;

    }else{
        WYPublishTagListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYPublishTagListCell" forIndexPath:indexPath];
        //不是搜索的时候没有点击事件
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconIV.image = [UIImage imageNamed:@"publishTag"];
        
        NSString *tempStr;
        if (self.type == AddTagFromPublish) {
            //这里不用分 推荐的分区里边 没有row
            tempStr = self.tagStrArr[indexPath.row];
        }else{
            
            WYTag *tag;
            if (self.recommendArr.count > 0) {
                if ([self.tagObjectArr[0] count] > 0) {
                    //0分区没有cell
                    if (indexPath.section == 1) {
                        tag = self.tagObjectArr[0][indexPath.row];
                    }else{
                        tag = self.tagObjectArr[1][indexPath.row];
                    }
                }else{
                    if (self.tagObjectArr[1] > 0) {
                        tag = self.tagObjectArr[1][indexPath.row];
                    }
                }
            }else{
                if ([self.tagObjectArr[0] count] > 0) {
                    if (indexPath.section == 0) {
                        tag = self.tagObjectArr[0][indexPath.row];
                    }else{
                        tag = self.tagObjectArr[1][indexPath.row];
                    }
                }else{
                    if (self.tagObjectArr[1] > 0) {
                        tag = self.tagObjectArr[1][indexPath.row];
                    }
                }
            }
            tempStr = tag.tag_name;
        }

        cell.titleLb.text = tempStr;
        [cell lineView];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isSearch) {
        _isSearch = NO;
        //将对应的数据源添加到 我的标签中
        NSDictionary *dic = self.similarArr[indexPath.row];
        NSString *s = [dic objectForKey:@"name"];
        
        //防止有重复的标签
        NSMutableArray *tempArr;
        if (self.type == AddTagFromPublish) {
            tempArr = self.tagStrArr;
        }else{
            NSMutableArray *ma = [NSMutableArray array];
            for (int i = 0; i < self.tagObjectArr.count; i++) {
                [ma addObjectsFromArray:self.tagObjectArr[i]];
            }
            tempArr = ma;
        }
        if ([WYPublishAddTagsTool strIsRepeated:s arr:tempArr] || tempArr.count >= 10) {
            _textFiled.text = @"";
            [self.tableView reloadData];
            return;
        }
        
        //可以添加
        if (self.type == AddTagFromPublish) {
            [self.tagStrArr addObject:s];
            _textFiled.text = @"";
            [_textFiled resignFirstResponder];
            [self.tableView reloadData];

        }else{
            __weak WYPublishAddTagsVC *weakSelf = self;
            [WYPostTagApi addPostTag:self.post.uuid tags:@[s] Block:^(NSArray *addedArr) {
                if (addedArr) {
                    if ([self.post.author.uuid isEqualToString:kuserUUID]) {
                        [weakSelf.tagObjectArr[0] addObjectsFromArray:addedArr];
                    }else{
                        for (int i = 0; i < addedArr.count; i++) {
                            WYTag *tag = addedArr[i];
                            if ([tag.author_uuid isEqualToString:kuserUUID]) {
                                [weakSelf.tagObjectArr[0] addObject:tag];
                            }else{
                                [weakSelf.tagObjectArr[1] addObject:tag];
                            }
                        }
                    }
                    weakSelf.textFiled.text = @"";
                    [weakSelf.textFiled resignFirstResponder];
                    [weakSelf.tableView reloadData];
                    
                    //发送通知 让所有的post页面 添加这个标签
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (int i = 0; i < weakSelf.tagObjectArr.count; i ++) {
                        [tempArr addObjectsFromArray:weakSelf.tagObjectArr[i]];
                    }
                    weakSelf.post.tag_list = tempArr;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":weakSelf.post}];
                }
            }];
        }
    }else{
        //不可以点击
    }
}

#pragma cell delete
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_isSearch) {
        if (self.type == AddTagFromPublish) {
            return UITableViewCellEditingStyleDelete;
        }else{
            if (self.recommendArr.count > 0) {
                if (indexPath.section == 1) {
                    if ([self.tagObjectArr[0] count] > 0) {
                        return UITableViewCellEditingStyleDelete;
                    }
                }
            }else{
                if (indexPath.section == 0) {
                    if ([self.tagObjectArr[0] count] > 0) {
                        return UITableViewCellEditingStyleDelete;
                    }
                }
            }
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    __weak WYPublishAddTagsVC *weakSelf = self;
    NSArray *caurrentArr;

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.type == AddTagFromPublish) {
            caurrentArr = self.tagStrArr;
            [self.tagStrArr removeObjectAtIndex:indexPath.row];
        }else{
            
            //不等待同步是确保 删除不会延迟
            WYTag *tag;
            if (self.recommendArr.count > 0) {
                if ([self.tagObjectArr[0] count] > 0) {
                    if (indexPath.section == 1) {
                        caurrentArr = self.tagObjectArr[0];
                        tag = self.tagObjectArr[0][indexPath.row];
                        [self.tagObjectArr[0] removeObjectAtIndex:indexPath.row];
                    }else{
                        caurrentArr = self.tagObjectArr[1];
                        tag = self.tagObjectArr[1][indexPath.row];
                        [self.tagObjectArr[1] removeObjectAtIndex:indexPath.row];
                    }
                }else{
                    caurrentArr = self.tagObjectArr[1];
                    tag = self.tagObjectArr[1][indexPath.row];
                    [self.tagObjectArr[1] removeObjectAtIndex:indexPath.row];
                }
            }else{
                if ([self.tagObjectArr[0] count] > 0) {
                    if (indexPath.section == 0) {
                        caurrentArr = self.tagObjectArr[0];
                        tag = self.tagObjectArr[0][indexPath.row];
                        [self.tagObjectArr[0] removeObjectAtIndex:indexPath.row];
                    }else{
                        caurrentArr = self.tagObjectArr[1];
                        tag = self.tagObjectArr[1][indexPath.row];
                        [self.tagObjectArr[1] removeObjectAtIndex:indexPath.row];
                    }
                }else{
                    caurrentArr = self.tagObjectArr[1];
                    tag = self.tagObjectArr[1][indexPath.row];
                    [self.tagObjectArr[1] removeObjectAtIndex:indexPath.row];
                }
            }
            
            
            [WYPostTagApi removePostTag:self.post.uuid tags:@[tag.tag_name] Block:^(NSArray *removedArr) {
                //发送通知 让所有的post页面 删除这个标签
                NSMutableArray *tempArr = [NSMutableArray array];
                for (int i = 0; i < weakSelf.tagObjectArr.count; i ++) {
                    [tempArr addObjectsFromArray:weakSelf.tagObjectArr[i]];
                }
                weakSelf.post.tag_list = tempArr;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":weakSelf.post}];
            }];
        }
        //如果分区中只有一个元素 只能删除分区 不能删除cell
        //因为已经移除掉了 所以用0
        [tableView beginUpdates];

        if (caurrentArr.count > 0) {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationNone];
        }
        [tableView endUpdates];
    }
}

-(void)addTagAction{
    
    __weak WYPublishAddTagsVC *weakSelf = self;
    if (_textFiled.text.length > 0) {
        
        _isSearch = NO;
        //防止有重复的标签
        NSMutableArray *tempArr;
        if (self.type == AddTagFromPublish) {
            tempArr = self.tagStrArr;
        }else{
            NSMutableArray *ma = [NSMutableArray array];
            for (int i = 0; i < self.tagObjectArr.count; i++) {
                [ma addObjectsFromArray:self.tagObjectArr[i]];
            }
            tempArr = ma;
        }
        if ([WYPublishAddTagsTool strIsRepeated:_textFiled.text arr:tempArr] || tempArr.count >= 10) {
            return;
        }
        
        //可以添加
        [self.similarArr removeAllObjects];
        if (self.type == AddTagFromPublish) {
            [self.tagStrArr addObject:_textFiled.text];
            _textFiled.text = @"";
            [_textFiled resignFirstResponder];
            [self.tableView reloadData];

        }else{

            [WYPostTagApi addPostTag:self.post.uuid tags:@[_textFiled.text] Block:^(NSArray *addedArr) {
                if (addedArr) {
                    if ([self.post.author.uuid isEqualToString:kuserUUID]) {
                        [weakSelf.tagObjectArr[0] addObjectsFromArray:addedArr];
                    }else{
                        for (int i = 0; i < addedArr.count; i++) {
                            WYTag *tag = addedArr[i];
                            if ([tag.author_uuid isEqualToString:kuserUUID]) {
                                [weakSelf.tagObjectArr[0] addObject:tag];
                            }else{
                                [weakSelf.tagObjectArr[1] addObject:tag];
                            }
                        }
                    }
                    weakSelf.textFiled.text = @"";
                    [weakSelf.textFiled resignFirstResponder];
                    [weakSelf.tableView reloadData];
                    
                    //发送通知 让所有的post页面 添加这个标签
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (int i = 0; i < weakSelf.tagObjectArr.count; i ++) {
                        [tempArr addObjectsFromArray:weakSelf.tagObjectArr[i]];
                    }
                    weakSelf.post.tag_list = tempArr;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":weakSelf.post}];
                }
            }];
        }
       
    }
}

-(void)textFiledDidChanged{
    
    __weak WYPublishAddTagsVC *weakSelf = self;
    if (self.textFiled.text.length >=2) {
        [WYPostTagApi recommendPostTagOnSearch:self.textFiled.text Block:^(NSArray *recommendStrArr) {
            weakSelf.isSearch = YES;
            [weakSelf.similarArr removeAllObjects];
            if (recommendStrArr) {
                [weakSelf.similarArr addObjectsFromArray:recommendStrArr];
            }
            [weakSelf.tableView reloadData];
        }];
    }else{
        _isSearch = NO;
        [weakSelf.similarArr removeAllObjects];
        [weakSelf.tableView reloadData];
    }
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
