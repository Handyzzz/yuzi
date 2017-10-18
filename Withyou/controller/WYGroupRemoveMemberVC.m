//
//  WYGroupRemoveMemberVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/7.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupRemoveMemberVC.h"
#import "WYGroupRemoveCell.h"
#import "WYGroupApi.h"

@interface WYGroupRemoveMemberVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *delArr;
@property (nonatomic, strong)NSMutableArray *indexArr;
@property (nonatomic, strong)UILabel *titleLb;
@end

@implementation WYGroupRemoveMemberVC

-(NSMutableArray*)delArr{
    if (_delArr == nil) {
        _delArr = [NSMutableArray array];
    }
    return _delArr;
}

-(NSMutableArray*)indexArr{
    if (_indexArr == nil) {
        _indexArr = [NSMutableArray array];
    }
    return _indexArr;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"移除成员";
    self.tableView.editing = YES;
    [self creatHeader];
    [self setNaviItem];
}
-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    

    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];

    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick{
    if (self.delArr.count < 1) {
        [OMGToast showWithText:@"请选择群成员！"];
        return;
    }
    //将要移除的群成员移除
    NSMutableArray *delUidArr = [NSMutableArray array];
    for (WYUser*user in self.delArr) {
        
        [delUidArr addObject:user.uuid];
    }
    //点击后让btn失能
    self.navigationItem.rightBarButtonItem.enabled = NO;
    __weak WYGroupRemoveMemberVC *weakSelf = self;
    [WYGroupApi removeGroupMember:self.group.uuid RemoveList:[delUidArr copy] Block:^(NSArray *removedArr, NSArray *notInGroupArr) {
        
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        [weakSelf removeAllIndexesForCollectionView];

        NSString  *alertString = @"";
        NSString *allRemovedNames = [weakSelf namesFromArr:removedArr];
        NSString *allFailedNames = [weakSelf namesFromArr:notInGroupArr];
        
        
        if(removedArr.count == 0 && notInGroupArr.count == 0){
//            说明网络或者后端出错了，传回了至少一个nil值
            [WYUtility showAlertWithTitle:@"移出成员未成功，可能网络不通，请稍后再试"];
            return;
        }
        
        if(removedArr.count > 0 && notInGroupArr.count == 0){
            //正常合理的情况，都移出成功了，没有不成功的
            alertString = [NSString stringWithFormat:@"成功移出%@", allRemovedNames];
        }
        else if(removedArr.count > 0 && notInGroupArr.count > 0)
        {
//            有正常移出的，也有出了问题的
            alertString = [NSString stringWithFormat:@"成功移出%@\n移出%@未成功，他们可能已经不在群内或者是管理员", allRemovedNames, allFailedNames ];
        }
        else if(removedArr.count == 0 && notInGroupArr.count > 0){
            //没有成功移出任何一个，全部出错了
            alertString = [NSString stringWithFormat:@"移出%@未成功，他们可能已经不在群内或者是管理员", allFailedNames ];
        }
        else if(removedArr.count == 0 && notInGroupArr.count == 0)
        {
//            没有成功的，也没有失败的，说明之前可能传的是空数组
            alertString = [NSString stringWithFormat:@"未成功移出任何成员"];
        }
        
        [WYUtility showAlertWithTitle:@"提示" Msg:alertString];
        
        if(removedArr.count > 0){
            //只要有成功移出的成员，就应该更新数据源
        
            //删除的成员 可能是下拉后的成员 group的partial_member_list中可能没有
            NSMutableArray *mutablePartialMemberList = [self.group.partial_member_list mutableCopy];
            
            
            //在for in执行时 增删计数器不会改变 需要break
            /*
             解决方案 
             1.对副本进行遍历 删除原数组
             2.普通for循环
             3.break
             */
            for (NSDictionary *removeUser in removedArr) {
                for (WYUser *user in mutablePartialMemberList) {
                    if ([user.uuid isEqualToString:[removeUser objectForKey:@"uuid"]]) {
                        //将user从partial_member_list中移除
                        [mutablePartialMemberList removeObject:user];
                        break;
                    }
                }
            }
            weakSelf.group.partial_member_list = mutablePartialMemberList;
            weakSelf.group.member_num = weakSelf.group.member_num - (int)removedArr.count;
            
            //发送通知，回传群组
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateGroupDataSource object:weakSelf userInfo:@{@"group":self.group}];
            
            //更新列表视图
                for (NSDictionary *removeUser in removedArr) {
                    for(WYUser *user in weakSelf.resultList){
                        if ([user.uuid isEqualToString:[removeUser objectForKey:@"uuid"]]) {
                            [weakSelf.resultList removeObject:user];
                            break;
                        }
                    }
                }
            [weakSelf.tableView reloadData];
        }
    }];
}
//从带有uuid和name的字典中，把name拿出来，拼接起来，并去掉最后的逗号
- (NSString *)namesFromArr:(NSArray *)arr{
    
    __block NSString *string = @"";
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            string = [string stringByAppendingString:[obj objectForKey:@"name"]];
        }else{
            string = [string stringByAppendingString:@","];
            string = [string stringByAppendingString:[obj objectForKey:@"name"]];
        }
    }];
    return string;
}


- (void)removeAllIndexesForCollectionView
{
    [self.indexArr removeAllObjects];
    [self.delArr removeAllObjects];
    [self updateHeigh];
    [self.collectionView reloadData];
}
-(void)creatHeader{
    self.tableView.tableHeaderView = self.collectionView;
    _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 200, 20)];
    _titleLb.text = @"将要移除的群成员";
    _titleLb.font = [UIFont systemFontOfSize:13];
    _titleLb.textColor = [UIColor lightGrayColor];
    [self.collectionView addSubview:_titleLb];
}

-(UICollectionView*)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(30, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat width = (long)(([UIScreen mainScreen].bounds.size.width)/4.0);
        layout.itemSize = CGSizeMake(width, width);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 0) collectionViewLayout:layout];
        [_collectionView registerClass:[WYGroupRemoveCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
    }
    return _collectionView;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.delArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WYGroupRemoveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    WYUser *user = self.delArr[indexPath.row];
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
    cell.nameLb.text = user.fullName;
    
    return cell;
}



-(void)updateCellContent:(NSIndexPath *)indexPath{
    //遍历indexArr 将对应的位置选中
    if (_indexArr.count > 0) {
        for (NSIndexPath *index in self.indexArr) {
            if ([index isEqual:indexPath]) {
                [self.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.indexArr addObject:indexPath];
    [self.delArr addObject:self.resultList[indexPath.row]];
    [self updateHeigh];
    [self.collectionView reloadData];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.indexArr removeObject:indexPath];
    [self.delArr removeObject:self.resultList[indexPath.row]];
    [self updateHeigh];
    [self.collectionView reloadData];
}

-(void)updateHeigh{
    CGFloat heigh;
    CGFloat width = (long)(([UIScreen mainScreen].bounds.size.width)/4.0);
    if (self.delArr.count >0) {
        heigh = ((self.delArr.count-1)/4 +1)*width+30;
    }else{
        heigh = 0;
    }
    self.collectionView.frame = CGRectMake(0, 0, kAppScreenWidth, heigh);
    [self.tableView reloadData];
}

// 选择模式
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

@end
