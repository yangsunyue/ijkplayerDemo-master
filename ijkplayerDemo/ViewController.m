//
//  ViewController.m
//  ijkplayerDemo
//
//  Created by lihongfeng on 16/4/22.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "AFNetworking.h"
#import "YsyLiveModel.h"
#import "YsyTableViewCell.h"
#import "LiveViewController.h"
#import "MJRefresh.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [_tableview.header beginRefreshing];
//    [self loadData];
}

- (void)loadData
{
    // 映客数据url
    NSString *urlStr = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    
    // 请求数据
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [mgr GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        NSLog(@"%@", responseObject[@"lives"]);
        NSArray *arr = responseObject[@"lives"];
        _dataArray = [NSMutableArray new];
        
        for (NSDictionary *dd in arr) {
            YsyLiveModel *model = [[YsyLiveModel alloc] initWithDictionary:dd error:nil];
            if (model.creator.portrait.length < 40) {
                model.creator.portrait = [NSString stringWithFormat:@"http://img2.inke.cn/%@", model.creator.portrait];
            }
            
            [_dataArray addObject:model];
        }
        
        [_tableview reloadData];
        [_tableview.header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [_tableview.header endRefreshing];
    }];
}

- (void)configView{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HIGHT - 20) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [UIView new];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSArray *imageArray = @[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    // Set the ordinary state of animated images
    [header setImages:imageArray forState:MJRefreshStateIdle];
    // Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    [header setImages:imageArray forState:MJRefreshStatePulling];
    // Set the refreshing state of animated images
    [header setImages:imageArray forState:MJRefreshStateRefreshing];
    
    self.tableview.header = header;
    [_tableview registerNib:[UINib nibWithNibName:@"YsyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
}

- (void)refresh{
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 450;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    YsyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    YsyLiveModel *model = _dataArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableview deselectRowAtIndexPath:indexPath animated:YES];
    YsyLiveModel *model = _dataArray[indexPath.row];
    LiveViewController *vc = [[LiveViewController alloc] init];
    vc.model = model;
    [self presentViewController:vc animated:YES completion:nil];
}

///**
// *  cell出场动画
// */
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //设置Cell的动画效果为3D效果
//    //设置x和y的初始值为0.1；
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    //x和y的最终值为1
//    [UIView animateWithDuration:1 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
//}






@end
