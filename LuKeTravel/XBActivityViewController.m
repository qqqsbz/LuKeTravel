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
#import "XBShareView.h"
#import "SDCycleScrollView.h"
#import "XBWebViewController.h"
#import "XBActivityPackageView.h"
#import "XBActivityNavigationBar.h"
#import "XBActivityReviewMaskView.h"
#import "XBStretchableActivityView.h"
#import "XBActivityRecommendMaskView.h"
#import "XBActivityDetailViewController.h"
@interface XBActivityViewController () <SDCycleScrollViewDelegate,UIScrollViewDelegate,XBStretchableActivityViewDelegate,XBActivityPackageViewDelegate>
@property (strong, nonatomic) XBActivity                  *activity;
@property (strong, nonatomic) XBShareView                 *shareView;
@property (strong, nonatomic) UIScrollView                *scrollView;
@property (strong, nonatomic) SDCycleScrollView           *bannerView;
@property (strong, nonatomic) XBActivityPackageView       *packageView;
@property (strong, nonatomic) XBActivityReviewMaskView    *reviewMaskView;
@property (strong, nonatomic) XBActivityNavigationBar     *navigationBarView;
@property (strong, nonatomic) XBStretchableActivityView   *stretchHeaderView;
@property (strong, nonatomic) XBActivityRecommendMaskView *recommendMaskView;
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
    
    self.navigationView.backgroundColor = [UIColor clearColor];
    
    self.navigationSeparatorView.hidden = YES;
    
    self.navigationRightButton.enabled = self.activity != nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
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
        
        self.packageView.packages = activity.packages;
        
        self.navigationRightButton.enabled = YES;
    
    } failure:^(NSError *error) {
    
        DDLogDebug(@"error:%@",error);
        
        [self hideLoading];
    }];
}

- (void)builView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kActivityToolBarHeight)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];

    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), 260) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.currentPageDotColor = [UIColor whiteColor];
    
    self.stretchHeaderView = [[XBStretchableActivityView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), kBannerHeight)];
    self.stretchHeaderView.delegate = self;
    [self.stretchHeaderView stretchHeaderForScrollView:self.scrollView withView:self.bannerView];
    
    self.navigationBarView = [[XBActivityNavigationBar alloc] initWithFrame:CGRectMake(0, -kActivityNavigationBarHeight, CGRectGetWidth(self.view.frame), kActivityNavigationBarHeight)];
    self.navigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBarView];
    
    self.packageView = [[XBActivityPackageView alloc] initWithFrame:self.view.bounds];
    self.packageView.maxTop = kBannerHeight;
    self.packageView.delegate = self;
    [self.view insertSubview:self.packageView belowSubview:self.scrollView];
    
    self.recommendMaskView = [[XBActivityRecommendMaskView alloc] initWithFrame:self.view.bounds];
    self.recommendMaskView.alpha = 0.f;
    [self.recommendMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
    [keyWindow addSubview:self.recommendMaskView];
    
    self.reviewMaskView = [[XBActivityReviewMaskView alloc] initWithFrame:self.view.bounds];
    self.reviewMaskView.alpha = 0.f;
    [self.reviewMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
    [keyWindow addSubview:self.reviewMaskView];
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.stretchHeaderView scrollViewDidScroll:scrollView];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= CGRectGetHeight(self.bannerView.frame) * 0.3) {
        
        [self navigationBarAnimation:YES];
        
    } else {
        
        [self navigationBarAnimation:NO];
        
    }
    
    self.navigationBarView.separatorView.hidden = offsetY < (CGRectGetHeight(self.bannerView.frame) - CGRectGetHeight(self.navigationBarView.frame));
    
}

#pragma mark -- XBStretchableActivityViewDelegate

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectLinkWithURL:(NSURL *)url
{
    XBWebViewController *webVC = [[XBWebViewController alloc] init];
    
    webVC.webUrl = url;
    
    webVC.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:webVC animated:YES];
    
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
    XBActivityDetailViewController *detailVC = [[XBActivityDetailViewController alloc] initWithParserContents:parserContents navigationTitle:NSLocalizedString(@"activity-detail-particulars", @"activity-detail-particulars")];
    
    detailVC.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectDetailWithParserContent:(NSArray<XBParserContent *> *)parserContents
{
    XBActivityDetailViewController *detailVC = [[XBActivityDetailViewController alloc] initWithParserContents:parserContents navigationTitle:NSLocalizedString(@"activity-detail-strength", @"activity-detail-strength")];
    
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

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectFavoriteWithActivity:(XBActivity *)activity
{
    DDLogDebug(@"favorite activity........");
}

#pragma mark --  UIGestureRecognizer
- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        tapGesture.view.alpha = 0.f;
        
    } completion:nil];
}

#pragma mark -- XBActivityPackageViewDelegate
- (void)activityPackageView:(XBActivityPackageView *)activityPackageView didShowPackageWithButton:(UIButton *)btn
{
    [self navigationBarAnimation:NO];
}

- (void)activityPackageView:(XBActivityPackageView *)activityPackageView didHidePackageWithButton:(UIButton *)btn
{
    [self navigationBarAnimation:YES];
}

- (void)activityPackageView:(XBActivityPackageView *)activityPackageView didSelectPackageWithPackage:(XBPackage *)package
{
    DDLogDebug(@"提交订单:%@",package);
}

- (void)navigationBarAnimation:(BOOL)isShow
{
    if (isShow) {
        
        if (self.navigationBarView.xb_y == - kActivityNavigationBarHeight && !self.navigationBarView.animationing) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.navigationBarView.xb_y = 0;
                
                self.navigationBarView.animationing = YES;
                
            } completion:^(BOOL finished) {
                
                self.navigationBarView.animationing = NO;
            
            }];
        }
        
    } else {
        
        if (self.navigationBarView.xb_y == 0 && !self.navigationBarView.animationing) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.navigationBarView.xb_y = -kActivityNavigationBarHeight;
                
                self.navigationBarView.animationing = YES;
                
            } completion:^(BOOL finished) {
                
                self.navigationBarView.animationing = NO;
                
            }];
            
        }
    
    }
}

#pragma mark --  XBShareView
- (XBShareView *)shareView
{
    if (!_shareView) {
        _shareView = [[XBShareView alloc] initWithFrame:self.view.bounds shareActivity:self.activity.shareActivity targetViewController:self];
        
        _shareView.alpha = 0.f;
        
        [self.view addSubview:_shareView];
    }
    return _shareView;
}

#pragma mark -- XBBasicViewController navigation action
- (void)rightButtonAction
{
    [self.shareView toggle];
    
    //当显示分享页面时 隐藏导航栏
    self.navigationView.hidden = self.shareView.alpha == 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
