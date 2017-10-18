//
//  WYSelfPrivacyVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/6.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSelfPrivacyVC.h"
#import "WYUserApi.h"
#import "WYSelfPrivacy.h"

@interface WYSelfPrivacyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *textArr;
@property (nonatomic, strong)WYSelfPrivacy *privacy;
@end

@implementation WYSelfPrivacyVC

-(NSMutableArray* )textArr{
    if (_textArr == nil) {
        _textArr = [NSMutableArray array];
    }
    return _textArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    [self creatTabView];
    [self initData];
}
-(void)setNavigationBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}


-(void)initData{
    self.title = @"设置";
    _textArr = [@[@"通过手机号可以搜索到我",
                  @"通过姓名可以搜索到我"
                  ] mutableCopy];
    
    __weak WYSelfPrivacyVC *weakSelf = self;
    [WYUserApi retrieveSelfGlobalPrivacyWithDict:nil Block:^(WYSelfPrivacy *privacy){
        if(privacy){
            weakSelf.privacy = privacy;
            [weakSelf.tableView reloadData];
        }else{
            [OMGToast showWithText:@"获取隐私设置未成功"];
        }
    }];
}

-(void)creatTabView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _textArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _textArr[indexPath.row];
    UISwitch * sw = [UISwitch new];
    sw.on = YES;
    sw.tag = 1000 + indexPath.row;
    [sw addTarget:self action:@selector(swichClick:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    if (self.privacy) {
        if (indexPath.row == 0) {
            sw.on = self.privacy.allow_search_by_phone;
        }else{
            sw.on = self.privacy.allow_search_by_name;
        }
    }
    return cell;
}

-(void)swichClick:(UISwitch*)sender{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (sender.tag == 1000 + 0) {
        [dict setObject:@(sender.on) forKey:@"allow_search_by_phone"];
    }else{
        [dict setObject:@(sender.on) forKey:@"allow_search_by_name"];
    }
    
    [WYUserApi updateSelfGlobalPrivacyWithDict:dict Block:^(NSDictionary *response){
        if(response){
            //do nothing
        }else{
            //修改未成功取反
            sender.on = !sender.on;
            [OMGToast showWithText:@"修改未成功"];
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
