//
//  YZPrivilegeVC.m
//  Withyou
//
//  Created by CH on 2017/6/10.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPrivilegeVC.h"
#import "WYGroupApi.h"
@interface YZPrivilegeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *titles;
@property (nonatomic, strong)UIView *groupIntroductionView;

@end

@implementation YZPrivilegeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setNaviItem];
    [self creatTabView];
}
-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)titles{
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

-(void)initData{
    self.title = @"权限管理";
    _titles = [@[@"公开群",@"关闭后，所建群组为私密群，仅群成员可以进入，非群成员无法搜索到。",@"允许成员添加及邀请新成员"] mutableCopy];
    
}


-(void)creatTabView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}



#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YZNewGroupPermissionCell"];
    }
    NSString *title = self.titles[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:15];

    if (indexPath.row == 0 || indexPath.row == 2) {
        
        cell.textLabel.textColor = UIColorFromHex(0x333333);
        
        UISwitch *sw = [[UISwitch alloc] init];
        sw.onTintColor = UIColorFromHex(0x2BA1D4);
        cell.accessoryView = sw;
        [sw addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        sw.tag = indexPath.row;
        if (indexPath.row == 0) {
            sw.on = self.group.public_visible.boolValue;
        }else if (indexPath.row == 2){
            sw.on = self.group.allow_member_invite.boolValue;
        }
    }else{
        cell.textLabel.textColor = kRGB(153, 153, 153);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        UIView *lineView = [cell.contentView viewWithTag:1001];
        if (lineView == nil) {
            lineView = [UIView new];
            lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
            lineView.tag = 1001;
            [cell.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.right.equalTo(0);
                make.bottom.equalTo(0);
                make.height.equalTo(1);
            }];
        }
        
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)switchChange:(UISwitch *)sw {
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    if(sw.tag == 0) {
        [md setObject:@([@(sw.on) intValue])  forKey:@"public_visible"];
    }
    else if (sw.tag == 2) {
        [md setObject:@([@(sw.on) intValue])  forKey:@"allow_member_invite"];
    }
    
    [WYGroupApi changeGroupDetail:self.group.uuid dic:md Block:^(WYGroup *group) {
        if(group){
            switch (sw.tag) {
                case 0:
                {
                    self.group.public_visible = group.public_visible;
                    break;
                }
                case 2:
                {
                    self.group.allow_member_invite = group.allow_member_invite;
                    break;
                }
                default:
                    break;
            }
            [self.tableView reloadData];
        }
        else{
            [OMGToast showWithText:@"更新未成功！"];
        }
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
