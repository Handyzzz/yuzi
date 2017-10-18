//
//  WYEditPlaceViewController.m
//  Withyou
//
//  Created by Handyzzz on 2017/3/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//


#import "WYEditPlaceViewController.h"
#import "WYEditPlaceCell.h"

@interface WYEditPlaceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *selectArr;
@end

@implementation WYEditPlaceViewController

-(NSMutableArray*)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近";
    [self creatTableView];
    [self setNaviBar];
}
-(void)setNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIBarButtonItem *doneBtn= [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(RightClick)];
    self.navigationItem.rightBarButtonItem=doneBtn;
}

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//点击完成发通知
-(void)RightClick{
    //获取所有选中的cell的index
    NSArray * indexsArr=[_tableView.indexPathsForSelectedRows copy];
    for (NSIndexPath *index in indexsArr) {
        WYEditPlaceCell *cell = [_tableView cellForRowAtIndexPath:index];
        _response.pois[index.row].name = cell.textFd.text;
        [self.selectArr addObject:_response.pois[index.row]];
    }

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_selectArr,kAMapPOIAroundSearchReponse, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAMapPOIAroundSearchReponse object:nil userInfo:dic];
    //然后回到前两个
    NSInteger index = [self.navigationController.viewControllers count] - 1;
    [self.navigationController popToViewController:self.navigationController.viewControllers[index - 2] animated:YES];
}
-(void)creatTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.sectionIndexColor = [UIColor blueColor];
    self.tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 70.f;
    
    // 编辑模式
    self.tableView.editing = YES;
    // 允许多选
    self.tableView.allowsMultipleSelection = YES;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[WYEditPlaceCell class] forCellReuseIdentifier:@"WYEditPlaceCell"];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.response.pois.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WYEditPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYEditPlaceCell" forIndexPath:indexPath];
    cell.textFd.text = ((AMapPOI*)_response.pois[indexPath.row]).name;
    cell.desLb.text = ((AMapPOI*)_response.pois[indexPath.row]).address;
        if (((AMapPOI*)_response.pois[indexPath.row]).images[0].url) {
            NSString *imageUrl = ((AMapPOI*)_response.pois[indexPath.row]).images[0].url;
            [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        }else{
            cell.iconIV.image = [UIImage imageNamed:@"poiImg"];
        }
    return cell;
}

//选择的样式
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
