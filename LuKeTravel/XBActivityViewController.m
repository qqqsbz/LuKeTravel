//
//  XBActivityViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kBannerHeight CGRectGetHeight(self.view.frame) * 0.457

#import "XBActivityViewController.h"
#import "XBGroupItem.h"
#import "XBActivity.h"
#import "SDCycleScrollView.h"
#import "XBActivityView.h"
#import "XBStretchableActivityHeaderView.h"
@interface XBActivityViewController () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,XBActivityViewDelegate>
@property (strong, nonatomic) UITableView   *tableView;
@property (strong, nonatomic) XBActivity    *activity;
@property (strong, nonatomic) XBActivityView     *activityView;
@property (strong, nonatomic) SDCycleScrollView  *bannerView;
@property (strong, nonatomic) XBStretchableActivityHeaderView  *stretchHeaderView;
@end

static NSString *const reuseIdentifier = @"cell";
@implementation XBActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self builView];
    
    [self reloadData];
}

- (void)reloadData
{
    [self showLoadinngInView:self.view];
    [[XBHttpClient shareInstance] getActivitiesWithActivitiesId:[self.groupItem.modelId integerValue] success:^(XBActivity *activity) {
        
        [self hideLoading];
        
        self.activity = activity;
        
        self.activityView.activity = activity;
        
        self.bannerView.imageURLStringsGroup = activity.images;
        
        [self.tableView reloadData];
    
    } failure:^(NSError *error) {
    
        DDLogDebug(@"error:%@",error);
        
        [self hideLoading];
    }];
}

- (void)builView
{
    self.view.backgroundColor = [UIColor whiteColor];

    self.activityView = [[XBActivityView alloc] initWithFrame:CGRectMake(0, kBannerHeight, CGRectGetWidth(self.view.bounds), 2300)];
    self.activityView.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];


    // 网络加载 --- 创建带标题的图片轮播器
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 260) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标
    
    self.stretchHeaderView = [[XBStretchableActivityHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), kBannerHeight)];
    [self.stretchHeaderView stretchHeaderForTableView:self.tableView withView:self.bannerView];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.activityView];
        
    }
    
    return cell;
    
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(self.activityView.frame);
}

#pragma mark -- XBActivityViewDelegate
- (void)activityView:(XBActivityView *)activityView didSelectLinkWithURL:(NSURL *)url
{
    DDLogDebug(@"url:%@",url);
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.stretchHeaderView scrollViewDidScroll:scrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
