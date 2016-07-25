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
#import "XBActivityNavigationBar.h"
#import "XBActivityReviewMaskView.h"
#import "XBStretchableActivityView.h"
#import "XBActivityRecommendMaskView.h"
#import "XBActivityDetailViewController.h"
@interface XBActivityViewController () <SDCycleScrollViewDelegate,UIScrollViewDelegate,XBStretchableActivityViewDelegate>
@property (strong, nonatomic) UIScrollView   *scrollView;
@property (strong, nonatomic) XBActivity     *activity;
@property (strong, nonatomic) SDCycleScrollView  *bannerView;
@property (strong, nonatomic) XBActivityReviewMaskView    *reviewMaskView;
@property (strong, nonatomic) XBActivityRecommendMaskView *recommendMaskView;
@property (strong, nonatomic) XBActivityNavigationBar     *navigationBarView;
@property (strong, nonatomic) XBStretchableActivityView   *stretchHeaderView;
@end

static NSString *const reuseIdentifier = @"cell";
@implementation XBActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self builView];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    self.navigationController.navigationBarHidden = NO;
}

- (void)reloadData
{
    [self showLoadinngInView:self.view];
    [[XBHttpClient shareInstance] getActivitiesWithActivitiesId:[self.groupItem.modelId integerValue] success:^(XBActivity *activity) {
        
        [self hideLoading];
        
        self.activity = activity;
        
        self.stretchHeaderView.activity = activity;
        
        self.navigationBarView.titleLabel.text = activity.name;
        
        self.bannerView.imageURLStringsGroup = activity.images;
        
    
    } failure:^(NSError *error) {
    
        DDLogDebug(@"error:%@",error);
        
        [self hideLoading];
    }];
}

- (void)builView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];

    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), 260) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标
    
    self.stretchHeaderView = [[XBStretchableActivityView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), kBannerHeight)];
    self.stretchHeaderView.delegate = self;
    [self.stretchHeaderView stretchHeaderForScrollView:self.scrollView withView:self.bannerView];
    
    self.navigationBarView = [XBActivityNavigationBar new];
    self.navigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBarView];
    
    self.recommendMaskView = [[XBActivityRecommendMaskView alloc] initWithFrame:self.view.bounds];
    self.recommendMaskView.alpha = 0.f;
    [self.recommendMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
    [keyWindow addSubview:self.recommendMaskView];
    
    self.reviewMaskView = [[XBActivityReviewMaskView alloc] initWithFrame:self.view.bounds];
    self.reviewMaskView.alpha = 0.f;
    [self.reviewMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
    [keyWindow addSubview:self.reviewMaskView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.navigationBarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(-kActivityNavigationBarHeight);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kActivityNavigationBarHeight);
    }];
    
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.stretchHeaderView scrollViewDidScroll:scrollView];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= CGRectGetHeight(self.bannerView.frame) * 0.3) {
        
        if (self.navigationBarView.xb_y == - kActivityNavigationBarHeight) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.navigationBarView.xb_y = 0;
                
            } completion:nil];
            
        }
        
    } else {
        
        if (self.navigationBarView.xb_y == 0) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.navigationBarView.xb_y = -kActivityNavigationBarHeight;
                
            } completion:nil];
            
        }
        
    }
    
    self.navigationBarView.separatorView.hidden = offsetY < (CGRectGetHeight(self.bannerView.frame) - CGRectGetHeight(self.navigationBarView.frame));
    
}

#pragma mark -- XBStretchableActivityViewDelegate

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectLinkWithURL:(NSURL *)url
{
    DDLogDebug(@"%@",url);
}

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectRecommendWithText:(NSString *)text
{
    
    self.recommendMaskView.textLabel.text = text;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.recommendMaskView.alpha = 1.f;
        
    } completion:nil];
}


- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectDirectionWithParserContent:(NSArray<XBParserContent *> *)parserContents
{
    XBActivityDetailViewController *detailVC = [[XBActivityDetailViewController alloc] initWithParserContents:parserContents];
    
    detailVC.title = NSLocalizedString(@"activity-detail-particulars", @"activity-detail-particulars");
    
    detailVC.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectDetailWithParserContent:(NSArray<XBParserContent *> *)parserContents
{
    XBActivityDetailViewController *detailVC = [[XBActivityDetailViewController alloc] initWithParserContents:parserContents];
    
    detailVC.title = NSLocalizedString(@"activity-detail-strength", @"activity-detail-strength");
    
    detailVC.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectReviewWithReviewCount:(NSInteger)reviewCount
{
    
    self.reviewMaskView.activityId = [self.activity.modelId integerValue];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.reviewMaskView.alpha = 1.f;
        
    } completion:nil];
}

#pragma mark --  UIGestureRecognizer
- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        tapGesture.view.alpha = 0.f;
        
    } completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
