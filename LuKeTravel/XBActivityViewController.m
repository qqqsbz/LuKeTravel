//
//  XBActivityViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBActivityViewController.h"
#import "XBGroupItem.h"
#import "XBBannerView.h"
#import "XBActivity.h"
#import "XBStretchableScrollHeaderView.h"
@interface XBActivityViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) XBBannerView  *bannerView;
@property (strong, nonatomic) XBActivity    *activity;
@property (strong, nonatomic) XBStretchableScrollHeaderView  *stretchHeaderView;
@end

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
        
        self.bannerView.imageUrls = activity.images;
    
    } failure:^(NSError *error) {
    
        DDLogDebug(@"error:%@",error);
        
        [self hideLoading];
    }];
}

- (void)builView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.bannerView = [[XBBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), 260.f)];
    
    self.stretchHeaderView = [[XBStretchableScrollHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), 260)];
    [self.stretchHeaderView stretchHeaderForScrollView:self.scrollView withView:self.bannerView];
    
    self.scrollView.contentSize = CGSizeMake(320, 700);
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
