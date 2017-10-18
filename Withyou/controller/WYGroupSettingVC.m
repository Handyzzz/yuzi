//
//  WYGroupSettingVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupSettingVC.h"
#import "WYGroupEditVC.h"
#import "WYQuitGroupVC.h"
#import "YZGroupSettingTableViewCell.h"
#import "UIImageView+EMWebCache.h"
#import "WYGroupRemoveMemberVC.h"
#import "YZPrivilegeVC.h"
#import "WYTransferAdminVC.h"
#import "WYSelectPostVC.h"
#import "WYGroupApi.h"
#import "WYSelectGroupCategoryVC.h"
#import "WYUserNickNameVC.h"


@interface WYGroupSettingVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *actionArr;
@property (nonatomic, assign)BOOL isAdmin;
@property (nonatomic, assign)CGFloat contentHeight;
@property (nonatomic, strong) NSMutableArray *tagsDetailArr;

@end

@implementation WYGroupSettingVC



#pragma lazy
-(NSMutableArray *)titles{
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}
-(NSMutableArray *)actionArr{
    if (_actionArr == nil) {
        _actionArr = [NSMutableArray array];
    }
    return _actionArr;
}

-(NSMutableArray *)tagsDetailArr{
    if (_tagsDetailArr == nil) {
        if (self.group.tags.length > 0) {
            _tagsDetailArr = [[self.group.tags componentsSeparatedByString:@","] mutableCopy];
        }else{
            _tagsDetailArr = [NSMutableArray array];
        }
    }
    return _tagsDetailArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviItem];
    //本地数据
    [self initData];
    [self creatTabView];
    
    //观察群组资料有没有改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupDatasource:) name:kUpdateGroupDataSource object:nil];
    
}

-(void)setNaviItem{
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.subviews[0].alpha = 1;
}

//群组资料改变
-(void)updateGroupDatasource:(NSNotification *)noti{
    
    WYGroup *group = [noti.userInfo objectForKey:@"group"];
    self.group = group;
    [self refreshAdimin];
    [self.tableView reloadData];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateGroupDataSource object:nil];
}

-(void)initData{
    self.title = @"设置";
    
    [self refreshAdimin];
    
    CGFloat maxWidth = self.view.frame.size.width - 140;
    self.contentHeight = [self.group.introduction sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(maxWidth, MAXFLOAT) minimumLineHeight:2].height;
    if (self.contentHeight < 50) {
        self.contentHeight = 50;
    }else if (self.contentHeight > 95){
        self.contentHeight = 95;
    }
}

-(void)refreshAdimin{
    self.isAdmin = [self.group meIsAdmin];
    
    if (_isAdmin) {
        _titles = [@[
                     @[@"群组名称", @"群组介绍",@"群组类型",@"群组标签",@"群组头像",],
                     @[@"群内搜索"],
                     @[@"群内有新帖推送给我"],
                     @[@"星标"],
                     @[@"对外展示我是群成员"],
                     @[@"权限管理", @"移除群成员", @"转让管理员权限"],
                     @[@"退出群组"]
                     ] mutableCopy];
        
        _actionArr = [@[
                        @[@"editNameAction", @"editIntroductionAction", @"editCategoryAction",@"editTagsAction",@"editIconAction"],
                        @[@"searchAction"],
                        @[@""],
                        @[@""],
                        @[@""],
                        @[@"privilegeAction", @"memberAction", @"attornAction"],
                        @[@"exitAction"]
                        ] mutableCopy];
        
    }else{
        _titles = [@[
                     @[@"群组名称", @"群组介绍",@"群组类型",@"群组标签"],
                     @[@"群内搜索"],
                     @[@"群内有新帖推送给我"],
                     @[@"星标"],
                     @[@"对外展示我是群成员"],
                     @[@"举报"],
                     @[@"退出群组"]
                     ] mutableCopy];
        
        _actionArr = [@[
                        @[@"editNameAction", @"editIntroductionAction",@"",@""],
                        @[@"searchAction"],
                        @[@""],
                        @[@""],
                        @[@""],
                        @[@"reportBtnClick"],
                        @[@"exitAction"]
                        ] mutableCopy];
    }
}


-(void)creatTabView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[YZGroupSettingTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

- (NSMutableAttributedString *)aStringText:(NSString *)text lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:text.length > 0 ? text : @" "];
    NSRange range = NSMakeRange(0, aString.length);
    [aString addAttribute:NSFontAttributeName value:font range:range];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [aString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return aString;
}

#pragma mark - Action
-(void)exitAction{
    
    WYQuitGroupVC *VC = [WYQuitGroupVC new];
    VC.group = self.group;
    VC.titleString = @"退出群组";
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)reportBtnClick{
    
    //举报后做的事情
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"举报该群组" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    __weak WYGroupSettingVC *weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"泄露隐私" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf reportAction:1];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"人身攻击" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf reportAction:2];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"色情文字" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf reportAction:3];
        
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"违反法律" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf reportAction:4];
        
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"垃圾信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf reportAction:5];
        
    }];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf reportAction:6];
        
    }];
    [actionSheet addAction:cancel];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    [actionSheet addAction:action5];
    [actionSheet addAction:action6];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

-(void)reportAction:(int)type{
    [WYGroupApi reportGroup:self.group.uuid type:@(type) Block:^(long status) {
        if (status == 200) {
            [WYUtility showAlertWithTitle:@"举报成功,感谢您对社区的贡献!"];
        }else{
            [WYUtility showAlertWithTitle:@"举报失败"];
        }
    }];
}

//修改名字
- (void)editNameAction{
    WYGroupEditVC *vc = [WYGroupEditVC new];
    vc.type = 0;
    vc.group = self.group;
    vc.key = @"name";
    vc.labelString = self.titles[0][0];
    vc.textFieldString = self.group.name;
    
    [self.navigationController pushViewController:vc animated:YES];
}
//修改简介
- (void)editIntroductionAction{
    WYGroupEditVC *vc = [WYGroupEditVC new];
    vc.type = 1;
    vc.group = self.group;
    vc.key = @"introduction";
    vc.labelString = self.titles[0][1];
    vc.textFieldString = self.group.introduction;
    [self.navigationController pushViewController:vc animated:YES];
}
//修改头像
- (void)editIconAction{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"请选择" message:@"获取头像" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseImage:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    [actionSheet addAction:cancel];
    [actionSheet addAction:camera];
    [actionSheet addAction:photoLibrary];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)chooseImage:(UIImagePickerControllerSourceType)type {
    //创建图片编辑控制器
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    //设置编辑类型
    imagePickerController.sourceType = type;
    //允许编辑器编辑图片
    imagePickerController.allowsEditing = YES;
    //设置代理
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


//群内搜索
- (void)searchAction{
    WYSelectPostVC *vc = [WYSelectPostVC new];
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}
//权限管理
- (void)privilegeAction{
    YZPrivilegeVC *vc = [YZPrivilegeVC new];
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}
//成员管理
- (void)memberAction{
    WYGroupRemoveMemberVC *vc= [WYGroupRemoveMemberVC new];
    vc.includeAdminList = NO;
    vc.group = self.group;
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}
//转让权限
- (void)attornAction{
    WYTransferAdminVC *vc = [WYTransferAdminVC new];
    vc.includeAdminList = NO;
    vc.group = self.group;
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}
//选择类型
-(void)editCategoryAction{
    __weak WYGroupSettingVC *weakSelf = self;
    WYSelectGroupCategoryVC *vc = [WYSelectGroupCategoryVC new];
    vc.selectedClick = ^(WYGroupCategory *tags) {
        //先修改
        weakSelf.group.category_name = tags.name;
        [weakSelf.tableView reloadData];
        //再发通知
        NSDictionary *dic = @{@"category":@(tags.category)};
        [WYGroupApi changeGroupDetail:self.group.uuid dic:dic Block:^(WYGroup *group) {
            if (group) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateGroupDataSource object:self userInfo:@{@"group":group}];
            }
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//修改标签
-(void)editTagsAction{
    __weak WYGroupSettingVC *weakSelf = self;
    WYUserNickNameVC *vc = [WYUserNickNameVC new];
    vc.keyWords = @"标签";
    [vc.detailArr addObjectsFromArray:self.tagsDetailArr];
    vc.doneClick = ^(NSMutableArray *detailArr) {
        [weakSelf.tagsDetailArr removeAllObjects];
        [weakSelf.tagsDetailArr addObjectsFromArray:detailArr];
        weakSelf.group.tags = [self tranArrToStringWithComma:weakSelf.tagsDetailArr];
        [weakSelf.tableView reloadData];
        
        NSDictionary *dic = @{@"tags":[self tranArrToStringWithComma:weakSelf.tagsDetailArr]};
        [WYGroupApi changeGroupDetail:self.group.uuid dic:dic Block:^(WYGroup *group) {
            if (group) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateGroupDataSource object:self userInfo:@{@"group":group}];
            }
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSString *)tranArrToStringWithComma:(NSArray *)arr{
    NSMutableString *ms = [NSMutableString string];
    if (arr && arr.count > 0) {
        for (int i = 0; i < arr.count; i++) {
            NSString *s = arr[i];
            NSString *temp;
            if (i < arr.count -1) {
                temp = [NSString stringWithFormat:@"%@,",s];
            }else{
                temp = [NSString stringWithFormat:@"%@",s];
            }
            [ms appendString:temp];
        }
        return ms;
        
    }else{
        return @"";
    }
}

-(void)switchAction:(UISwitch*)sender{
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    switch (sender.tag) {
        case 2:
        {
            [md setObject:@([@(sender.on) intValue])  forKey:@"new_post"];
            break;
        }
        case 3:
        {
            //星标
            [md setObject:@([@(sender.on) intValue])  forKey:@"starred"];
            break;
        }
        case 4:
        {
            //公开显示
            [md setObject:@([@(sender.on) intValue])  forKey:@"display"];
            break;
        }
        default:
            break;
    }

    
    [WYGroupApi patchUpdateGroupNotiForSetting:self.group.uuid Param:md Block:^(WYGroup *group) {
        if(group){
            
            //不用发送通知 和相邻页面用的是 同一块内存（group）改这个页面的group即可同步
            
            switch (sender.tag) {
                case 2:
                {
                    self.group.notif_new_post = group.notif_new_post;
                    break;
                }
                case 3:
                {
                    //星标
                    self.group.starred = group.starred;
                    break;
                }
                case 4:
                {
                    //公开显示
                    self.group.display = group.display;
                    break;
                }
                default:
                    break;
            }
          [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateGroupDataSource object:self userInfo:@{@"group":group}];
            [self.tableView reloadData];
        }
        else{
            [OMGToast showWithText:@"更新未成功"];
        }
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.titles[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return self.contentHeight + 30;
    }else if (indexPath.section == 0 && indexPath.row == 4){
        return 90;
    }else if (indexPath.section == self.titles.count - 1){
        return 84;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    else if(section == 4)
    {
        return 30;
    }
    else{
        return 12;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZGroupSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryView = nil;
    
    NSArray *arr = self.titles[indexPath.section];
    NSString *title = arr[indexPath.row];
    
    if (indexPath.section == 0) {
        cell.exitButton.hidden = YES;
        cell.textLabel.text = title;
        cell.textLabel.textColor = UIColorFromHex(0x999999);
        cell.textLabel.font = kFont_14;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
            {
                cell.iconIV.hidden = YES;
                cell.contentLb.hidden = NO;
                cell.contentLb.attributedText = [[NSAttributedString alloc] initWithString:self.group.name];
                cell.contentLb.numberOfLines = 1;
                [cell.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(0);
                    make.height.equalTo(50);
                    make.left.equalTo(90);
                    make.right.equalTo(-40);
                }];
            }
                break;
            case 1:
            {
                cell.iconIV.hidden = YES;
                cell.contentLb.hidden = NO;
                cell.contentLb.attributedText = [self aStringText:self.group.introduction lineSpacing:2 font:cell.contentLb.font];
                cell.contentLb.numberOfLines = 0;
                [cell.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(15);
                    make.height.equalTo(self.contentHeight);
                    make.left.equalTo(90);
                    make.width.equalTo(self.view.frame.size.width - 140);
                }];

            }
                break;
            case 2:
            {
                cell.iconIV.hidden = YES;
                cell.contentLb.hidden = NO;
                cell.contentLb.attributedText = [self aStringText:self.group.category_name lineSpacing:2 font:cell.contentLb.font];
                cell.contentLb.numberOfLines = 1;
                [cell.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(0);
                    make.height.equalTo(50);
                    make.left.equalTo(90);
                    make.right.equalTo(-40);
                }];
                if (self.isAdmin == NO) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
                break;
            case 3:
            {
                cell.iconIV.hidden = YES;
                cell.contentLb.hidden = NO;
                cell.contentLb.attributedText = [self aStringText:self.group.tagsString lineSpacing:2 font:cell.contentLb.font];
                cell.contentLb.numberOfLines = 1;
                [cell.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(0);
                    make.height.equalTo(50);
                    make.left.equalTo(90);
                    make.right.equalTo(-40);
                }];
                if (self.isAdmin == NO) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
                break;
            case 4:
            {
                cell.iconIV.hidden = NO;
                cell.contentLb.hidden = YES;
                
                [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:self.group.group_icon]];
            }
                break;
                
            default:
                break;
        }
    
    }
    else if (indexPath.section == self.titles.count - 1) {
        //退出群组
        cell.contentLb.hidden = YES;
        cell.iconIV.hidden = YES;
        cell.exitButton.hidden = NO;
        
        [cell.exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.height.equalTo(44);
            make.left.equalTo(15);
            make.width.equalTo(self.view.frame.size.width - 30);
        }];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        
        cell.contentLb.hidden = YES;
        cell.iconIV.hidden = YES;
        cell.exitButton.hidden = YES;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.text = title;
        cell.textLabel.textColor = kGrayColor85;
        cell.textLabel.font = kFont_15;
      
        if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4){
            UISwitch *notiType = [UISwitch new];
            notiType.onTintColor = UIColorFromHex(0x2BA1D4);
            notiType.tag = indexPath.section;
            cell.accessoryView = notiType;
            [notiType addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            if (indexPath.section == 2) {
                //如果内存中有 就用 没有就设为YES
                if (self.group.notif_new_post) {
                    notiType.on = self.group.notif_new_post.boolValue;
                }else{
                    notiType.on = YES;
                }
            }else if(indexPath.section == 3){
                if (self.group.starred) {
                    notiType.on = self.group.starred.boolValue;
                }else{
                    notiType.on = YES;
                }
            }else{
                if (self.group.public_visible){
                    if (self.group.display) {
                        notiType.on = self.group.display.boolValue;
                    }else{
                        notiType.on = YES;
                    }
                }else{
                    notiType.on = NO;
                    notiType.enabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
    }
    
    if (arr.count > 1 && indexPath.row != arr.count - 1) {
        cell.lineView.hidden = NO;
    }else{
        cell.lineView.hidden = YES;
    }
    
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 4)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, [self tableView:tableView heightForHeaderInSection:section])];
        view.backgroundColor = UIColorFromHex(0xf5f5f5);
        
        UILabel *titleLb = [UILabel new];
        [view addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(view.frame.size.height);
        }];
        titleLb.textColor = UIColorFromHex(0xC5C5C5);
        titleLb.font = [UIFont systemFontOfSize:14];
        if ([self.group.public_visible boolValue] == YES) {
            titleLb.text = @"打开此项设置，他人会知道你是本群成员";
        }else{
            titleLb.text = @"私密群默认关闭，他人不知道你在本群内";
        }
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, [self tableView:tableView heightForHeaderInSection:section])];
        view.backgroundColor = UIColorFromHex(0xf5f5f5);
        return view;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *s = _actionArr[indexPath.section][indexPath.row];
    if (s.length > 0) {
        if([self respondsToSelector:NSSelectorFromString(s)]){
            [self performSelector:NSSelectorFromString(s) withObject:indexPath];
        }
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    __weak WYGroupSettingVC *weakSelf = self;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *chosenImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        __block PHAssetChangeRequest *_mChangeRequest = nil;
        __block PHObjectPlaceholder *assetPlaceholder;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            _mChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:chosenImage];
            assetPlaceholder = _mChangeRequest.placeholderForCreatedAsset;
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetPlaceholder.localIdentifier] options:nil];
                
                [WYGroupApi changeGroup:self.group.uuid ImageWith:[result firstObject] callback:^(WYGroup *group) {
                    if (group) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateGroupDataSource object:weakSelf userInfo:@{@"group":group}];
                    }else{
                        [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
                    }
                }];
                
            }
            else {
                NSLog(@"write error : %@",error);
                [OMGToast showWithText:@"更换头像失败，请稍后再试！"];
                return;
                
            }
        }];
    }
    else
    {
        NSURL *alAssetUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[alAssetUrl] options:nil];
        
        
        [WYGroupApi changeGroup:self.group.uuid ImageWith:[fetchResult firstObject] callback:^(WYGroup *group) {
            if (group) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateGroupDataSource object:weakSelf userInfo:@{@"group":group}];
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

@end
