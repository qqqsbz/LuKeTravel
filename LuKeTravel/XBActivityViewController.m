//
//  XBActivityViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kBannerHeight CGRectGetHeight(self.view.frame) * 0.457

#import "XBActivityViewController.h"
#import "XBHome.h"
#import "XBCity.h"
#import "XBGroup.h"
#import "XBActivity.h"
#import "XBWishlist.h"
#import "XBGroupItem.h"
#import "XBGroupItem.h"
#import "XBShareView.h"
#import "XBSearchItem.h"
#import "SDCycleScrollView.h"
#import "XBWebViewController.h"
#import "XBHomeViewController.h"
#import "XBCityViewController.h"
#import "XBBookOrderTransition.h"
#import "XBActivityPackageView.h"
#import "XBActivityNavigationBar.h"
#import "XBWishlistViewController.h"
#import "XBActivityReviewMaskView.h"
#import "XBStretchableActivityView.h"
#import "XBHomeSearchViewController.h"
#import "XBOrderNavigationController.h"
#import "XBActivityRecommendMaskView.h"
#import "XBWeChatLoginViewController.h"
#import "XBOrderCalendarViewController.h"
#import "XBActivityDetailViewController.h"


@interface XBActivityViewController () <SDCycleScrollViewDelegate,UIScrollViewDelegate,
XBStretchableActivityViewDelegate,XBActivityPackageViewDelegate,UIViewControllerTransitioningDelegate>
/** 数据对象 */
@property (strong, nonatomic) XBActivity                  *activity;
/** 分享界面 */
@property (strong, nonatomic) XBShareView                 *shareView;
/** 分享按钮 */
@property (strong, nonatomic) UIButton                    *shareButton;
/** 滚动view */
@property (strong, nonatomic) UIScrollView                *scrollView;
/** 横幅 */
@property (strong, nonatomic) SDCycleScrollView           *bannerView;
/** 选择套餐 */
@property (strong, nonatomic) XBActivityPackageView       *packageView;
/** 评论 */
@property (strong, nonatomic) XBActivityReviewMaskView    *reviewMaskView;
/** 导航栏 */
@property (strong, nonatomic) UINavigationController      *bookOrderNavigationController;
/** 滚动超过横幅出现的导航栏 */
@property (strong, nonatomic) XBActivityNavigationBar     *navigationBarView;
/** 处理横幅拉伸 */
@property (strong, nonatomic) XBStretchableActivityView   *stretchHeaderView;
/** 体验师推荐 */
@property (strong, nonatomic) XBActivityRecommendMaskView *recommendMaskView;
/** 用户登录成功前是否进行收藏操作 */
@property (assign, nonatomic) BOOL  isFavorite;
/** 进行下单的数据 */
@property (strong, nonatomic) XBPackage *orderPackage;

@end

static NSString *const reuseIdentifier = @"cell";
@implementation XBActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self builView];
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction) name:kUserLoginSuccessNotificaton object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    self.navigationItem.rightBarButtonItem.enabled = self.activity != nil;
    
    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:0];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)reloadData
{
    [self showLoadinngInView:self.view];
    [[XBHttpClient shareInstance] getActivitiesWithActivitiesId:self.activityId success:^(XBActivity *activity) {
        
        [self hideLoading];
        
        self.activity = activity;
        
        self.stretchHeaderView.activity = activity;
        
        self.navigationBarView.titleLabel.text = activity.name;
        
        self.bannerView.imageURLStringsGroup = activity.images;
        
        self.packageView.packages = activity.packages;
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    
    } failure:^(NSError *error) {
    
        DDLogDebug(@"error:%@",error);
        
        [self hideLoading];
    }];
}

- (void)builView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"activity_share_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(shareAction)];
    
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
        
        [self navigationBarAnimation:YES complete:nil];
        
    } else {
        
        [self navigationBarAnimation:NO complete:nil];
        
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
    XBActivityDetailViewController *detailVC = [[XBActivityDetailViewController alloc] initWithParserContents:parserContents navigationTitle:[XBLanguageControl localizedStringForKey:@"activity-detail-particulars"]];
    
    detailVC.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectDetailWithParserContent:(NSArray<XBParserContent *> *)parserContents
{
    XBActivityDetailViewController *detailVC = [[XBActivityDetailViewController alloc] initWithParserContents:parserContents navigationTitle:[XBLanguageControl localizedStringForKey:@"activity-detail-strength"]];
    
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
    self.isFavorite = YES;

    [self checkUserIfLogin];
    
    [self toggleFavorite];
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
    [self navigationBarAnimation:NO complete:nil];
}

- (void)activityPackageView:(XBActivityPackageView *)activityPackageView didHidePackageWithButton:(UIButton *)btn
{
    [self navigationBarAnimation:YES complete:nil];
}

- (void)activityPackageView:(XBActivityPackageView *)activityPackageView didSelectPackageWithPackage:(XBPackage *)package
{
    self.isFavorite = NO;
    
    [self checkUserIfLogin];
    
    self.orderPackage = package;
    
    [self placeAnOrder];
    
}

- (void)navigationBarAnimation:(BOOL)isShow complete:(dispatch_block_t)complete
{
    if (isShow) {
        
        if (self.navigationBarView.xb_y == - kActivityNavigationBarHeight && !self.navigationBarView.animationing) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.navigationBarView.xb_y = 0;
                
                self.navigationBarView.animationing = YES;
                
            } completion:^(BOOL finished) {
                
                self.navigationBarView.animationing = NO;
                
                if (complete) {
                    
                    complete();
                }
                
            }];
            
        } else {
            
            if (complete) {
                
                complete();
            }
        }
        
    } else {
        
        if (self.navigationBarView.xb_y == 0 && !self.navigationBarView.animationing) {
            
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.navigationBarView.xb_y = -kActivityNavigationBarHeight;
                
                self.navigationBarView.animationing = YES;
                
            } completion:^(BOOL finished) {
                
                self.navigationBarView.animationing = NO;
                
                if (complete) {
                    
                    complete();
                }
                
            }];
            
        } else {
            
            if (complete) {
                
                complete();
            }
        }
    }
}

#pragma mark -- user operation
/** 登录成功后进行的操作 */
- (void)loginSuccessAction
{
    if (self.isFavorite) {
        
        [self toggleFavorite];
        
    } else {
        
        self.navigationController.navigationBarHidden = YES;
        
        [self placeAnOrder];
        
    }
}

/** 提交订单 */
- (void)placeAnOrder
{
    
    self.packageView.hideMenu = YES;
    
    [self navigationBarAnimation:YES complete:^{
        
        XBOrderCalendarViewController *bookOrderVC = [[XBOrderCalendarViewController alloc] init];
        
        bookOrderVC.package = self.orderPackage;
        
        XBOrderNavigationController *navigationController = [[XBOrderNavigationController alloc] initWithRootViewController:bookOrderVC];
        
        navigationController.transitioningDelegate = self;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }];
    
}

/** 自定义转场动画 */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [XBBookOrderTransition transitionWithTransitionType:XBBookOrderTransitionTypePresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [XBBookOrderTransition transitionWithTransitionType:XBBookOrderTransitionTypeDismiss];
}

/** 检查是否登录 */
- (void)checkUserIfLogin
{
    if (![XBUserDefaultsUtil userInfo]) {
        
        [self presentToLoginViewController];
        
        return;
    }
}

/** 跳转到登录界面 */
- (void)presentToLoginViewController
{
    XBWeChatLoginViewController *loginViewController = [[XBWeChatLoginViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    navigationController.navigationBarHidden = YES;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

/** 根据情况切换收藏 或者取消 */
- (void)toggleFavorite
{
    //取消收藏
    if (self.activity.isFavourite) {
        
        [[XBHttpClient shareInstance] deleteWisheWithActivityId:[self.activity.modelId integerValue] success:^(BOOL success) {
            
            self.stretchHeaderView.favorite = NO;
            
            [self fillParentData:NO];
            
        } failure:^(NSError *error) {
            
            if (error.code == kUserUnLoginCode) {
                
                [self presentToLoginViewController];
            }
            
        }];
        
    } else {
        
        [[XBHttpClient shareInstance] postWisheWithActivityId:[self.activity.modelId integerValue] success:^(BOOL success) {
            
            self.stretchHeaderView.favorite = YES;
            
            [self fillParentData:YES];
            
        } failure:^(NSError *error) {
            
            if (error.code == kUserUnLoginCode) {
                
                [self presentToLoginViewController];
            }
            
        }];
        
    }

}

/** 更新首页收藏状态 */
- (void)fillParentData:(BOOL)isFavorite
{
    NSMutableArray<UIViewController *> *childViewControllers = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
    
    [childViewControllers removeLastObject];
    
    UIViewController *vc = [childViewControllers lastObject];
    
    if ([vc isKindOfClass:[XBHomeViewController class]]) {
        
        XBHomeViewController *homeVC = (XBHomeViewController *)vc;
        
        
        [self replactGroupItemWithGroups:homeVC.home.groups tableView:homeVC.tableView isFavorite:isFavorite];
        
    } else if ([vc isKindOfClass:[XBCityViewController class]]) {
    
        XBCityViewController *cityVC = (XBCityViewController *)vc;
        
        [self replactGroupItemWithGroups:cityVC.city.groups tableView:cityVC.tableView isFavorite:isFavorite];
    
    } else if ([vc isKindOfClass:[XBWishlistViewController class]]) {
        
        XBWishlistViewController *wishlistVC = (XBWishlistViewController *)vc;
        
        XBWishlist *wishlist;
        
        NSMutableArray<XBWishlist *> *wishlists = [NSMutableArray arrayWithArray:wishlistVC.datas];
        
        for (NSInteger i = 0; i < wishlists.count; i ++ ) {
            
            wishlist = wishlists[i];
            
            if ([wishlist.modelId integerValue] == self.activityId) {
                
                wishlist.isFavourite = isFavorite;
                
                [wishlistVC.tableView reloadData];
                
                break;
                
            }
            
        }
        
    } else if ([vc isKindOfClass:[XBHomeSearchViewController class]]) {
        
        XBHomeSearchViewController *homeSearchVC = (XBHomeSearchViewController *)vc;
        
        XBSearchItem *searchItem;
        
        NSMutableArray<XBSearchItem *> *searchItems = [NSMutableArray arrayWithArray:homeSearchVC.searchItems];
        
        for (NSInteger i = 0; i < searchItems.count; i ++ ) {
            
            searchItem = searchItems[i];
            
            if ([searchItem.modelId integerValue] == self.activityId) {
                
                searchItem.favorite = isFavorite;
                
                [homeSearchVC.tableView reloadData];
                
                break;
                
            }
            
        }

    }
    
}

- (void)replactGroupItemWithGroups:(NSArray<XBGroup *> *)groups tableView:(UITableView *)tableView isFavorite:(BOOL)isFavorite
{
    XBGroup *group;
    
    XBGroupItem *groupItem;
    
    for (NSInteger i = 0; i < groups.count; i ++) {
        
        group = groups[i];
        
        for (NSInteger j = 0; j < group.items.count; j ++) {
            
            groupItem = group.items[j];
            
            if ([groupItem.modelId integerValue] == self.activityId) {
                
                groupItem.favorite = isFavorite;
                
                NSMutableArray<XBGroupItem *> *items = [NSMutableArray arrayWithArray:group.items];
                
                [items replaceObjectAtIndex:j withObject:groupItem];
                
                group.items = items;
                
                [tableView reloadData];
                
                break;
                
            }
        }
    }
}

#pragma mark --  XBShareView
- (XBShareView *)shareView
{
    if (!_shareView) {
        _shareView = [[XBShareView alloc] initWithFrame:self.view.bounds shareActivity:self.activity.shareActivity targetViewController:self dismissBlock:^{
            
            self.navigationController.navigationBarHidden = NO;
            
        }];
        
        _shareView.title = [XBLanguageControl localizedStringForKey:@"activity-share-title"];
        
        _shareView.alpha = 0.f;
        
        [self.view addSubview:_shareView];
    }
    return _shareView;
}

#pragma mark --  navigation action
- (void)shareAction
{
    [self.shareView toggle];
    
    //当显示分享页面时 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
