//
//  XBHomeViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#define kHeaderHeight 50.f
#define kDuration 0.7
#define kStatusHeight   CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define kTabbarHeight   CGRectGetHeight(self.tabBarController.tabBar.frame)
#define kResetTabviewContentSize self.tableView.contentSize.height - CGRectGetHeight(self.navigationController.navigationBar.frame)

#import "XBHomeViewController.h"
#import "XBHome.h"
#import "XBGroup.h"
#import "XBGroupItem.h"
#import "XBInviation.h"
#import "XBGuideView.h"
#import "XBFavoriteTemp.h"
#import "XBHomeHeaderCell.h"
#import "XBHomeHeaderView.h"
#import "XBHomeActivityCell.h"
#import "XBHomeInviationCell.h"
#import "XBCityViewController.h"
#import "XBNavigationController.h"
#import "XBActivityViewController.h"
#import "XBHomeActivityContentCell.h"
#import "XBPromotionsViewController.h"
#import "XBHomeSearchViewController.h"
#import "XBWeChatLoginViewController.h"
#import "XBStretchableTableHeaderView.h"
#import "XBMoreActivityViewController.h"

@interface XBHomeViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,XBHomeInviationCellDelegate,XBHomeActivityCellDelegate,XBHomeHeaderCellDelegate>
/** 数据列表 */
@property (strong, nonatomic) UITableView   *tableView;
/** 横幅图片 */
@property (strong, nonatomic) UIImageView   *bannerImageView;
/** 数据 */
@property (strong, nonatomic) XBHome        *home;
/** 状态栏view */
@property (strong, nonatomic) UIView        *statusView;
/** 搜索按钮 */
@property (strong, nonatomic) UIButton      *searchButton;
/** logo文字 */
@property (strong, nonatomic) UILabel       *logoLabel;
/** logo图片 */
@property (strong, nonatomic) UIImageView   *logoImageView;
/** 定时器 */
@property (strong, nonatomic) NSTimer       *timer;
/** 存放登录前的收藏信息 */
@property (strong, nonatomic) XBFavoriteTemp *favoriteTemp;
/** 未登陆前的操作 YES:收藏  NO:优惠码 */
@property (assign, nonatomic) BOOL  loginState;
/** 处理横幅图片拉伸 */
@property (strong, nonatomic) XBStretchableTableHeaderView  *stretchHeaderView;
@end

static NSInteger bannerIndex;
static NSString *activityReuseIdentifier = @"XBHomeActivityCell";
static NSString *inviationReuseIdentifier = @"XBHomeInviationCell";
static NSString *headerReuseIdentifier = @"XBHomeHeaderCell";
@implementation XBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavigationBarTranslucent];

    [self buildView];
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kUserLoginSuccessNotificaton object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //如果用户切换过语言 则重新加载数据
    if (self.home && ![self.home.modelLanguage isEqualToString:[XBUserDefaultsUtil currentLanguage]]) {
        
        [self reloadData];
        
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)reloadData
{
    
    [XBLoadingView showInView:self.navigationController.view];
    
    [[XBHttpClient shareInstance] getHomeWithLongitude:[XBUserDefaultsUtil currentLongitude] latitude:[XBUserDefaultsUtil currentLatitude] success:^(XBHome *home) {
        
        self.home = home;
        
        self.stretchHeaderView.titleLabel.hidden = NO;

        self.stretchHeaderView.subTitleLabel.hidden = NO;

        self.stretchHeaderView.titleLabel.text = self.home.name;
        
        self.stretchHeaderView.subTitleLabel.text = self.home.subName;
        
        //对结果进行倒序排序
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_type"ascending:YES];
        
        self.home.groups = [self.home.groups sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        [self.tableView reloadData];
        
        self.tableView.contentSize = CGSizeMake(CGRectGetWidth(self.tableView.frame),kResetTabviewContentSize);
        
        bannerIndex = 0;
        
        [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:[self.home.bannerImages firstObject]] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
        
        [self.timer setFireDate:[NSDate date]];
        
        [XBLoadingView hide];
        
    } failure:^(NSError *error) {
        
        DDLogDebug(@"error:%@",error);
        
        [XBLoadingView hide];
        
        [self showNoSignalAlert];
        
    }];
}

- (void)buildView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kTabbarHeight + 20)];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeActivityCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:activityReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeInviationCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:inviationReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeHeaderCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:headerReuseIdentifier];
    [self.view addSubview:self.tableView];
    
    
    CGFloat height = CGRectGetHeight(self.view.frame) - kTabbarHeight;
    self.bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), height * 0.605)];
    self.bannerImageView.contentMode = UIViewContentModeScaleAspectFill ;
    self.bannerImageView.clipsToBounds = YES;
    
    
    self.stretchHeaderView = [XBStretchableTableHeaderView new];
    self.stretchHeaderView.titleLabel.hidden = YES;
    self.stretchHeaderView.subTitleLabel.hidden = YES;
    [self.stretchHeaderView stretchHeaderForTableView:self.tableView withView:self.bannerImageView];
    
    self.statusView = [UIView new];
    self.statusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.statusView];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton setImage:[UIImage imageNamed:@"searchCircle"] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
    
    self.logoLabel = [UILabel new];
    self.logoLabel.hidden = YES;
    self.logoLabel.font   = [UIFont systemFontOfSize:14.f];
    self.logoLabel.text   = NSLocalizedString(@"logo-title", @"logo-title");
    self.logoLabel.textColor = [UIColor colorWithHexString:@"#C0C2C2"];
    [self.tableView insertSubview:self.logoLabel atIndex:0];
    
    self.logoImageView = [UIImageView new];
    self.logoImageView.image  = [UIImage imageNamed:@"Klook_More"];
    self.logoImageView.hidden = YES;
    [self.tableView insertSubview:self.logoImageView atIndex:1];
    
    //创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kDuration * 7 target:self selector:@selector(bannerStartAnimation) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    
    [self addConstraint];

}

- (void)addConstraint
{
    [self.statusView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-kStatusHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kStatusHeight);
    }];
    
    [self.searchButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-kSpace);
        make.top.equalTo(self.view).offset(kSpace * 3);
    }];
    
    [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(- (kSpace + kTabbarHeight));
    }];
    
    [self.logoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logoImageView);
        make.bottom.equalTo(self.logoImageView.top).offset(-kSpace);
    }];
    
}

- (void)bannerStartAnimation
{
    CATransition *animation = [CATransition animation];
    
    animation.duration = kDuration;
    
    animation.type = kCATransitionFade;
    
    animation.subtype = kCATransitionFromTop;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.bannerImageView.layer addAnimation:animation forKey:@"TransitionAnimation"];
    
    if (bannerIndex < self.home.bannerImages.count - 1) {
        
        bannerIndex ++;
    
    } else {
     
        bannerIndex = 0;
    }
    
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:self.home.bannerImages[bannerIndex]] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger count = self.home.groups.count + (self.home.inviation && self.home.inviation.visable ? 1 : 0);
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section < self.home.groups.count) {
        
        return 2;
    }
    
    return self.home.inviation ? 1 : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < self.home.groups.count) {
        
        if (indexPath.row <= 0) {
            
            XBHomeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerReuseIdentifier forIndexPath:indexPath];
            
            cell.group = self.home.groups[indexPath.section];
            
            cell.delegate = self;
            
            return cell;
            
        } else {
            
            XBGroup *group = self.home.groups[indexPath.section];
            
            XBHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:activityReuseIdentifier forIndexPath:indexPath];
            
            cell.groupItems = group.items;
            
            cell.delegate = self;
            
            return cell;

        }
        
        
    }
    
    XBHomeInviationCell *cell = [tableView dequeueReusableCellWithIdentifier:inviationReuseIdentifier forIndexPath:indexPath];
    
    cell.inviation = self.home.inviation;
    
    cell.delegate  = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 230.f;
    
    if (indexPath.section < self.home.groups.count) {
        
        XBGroup *group = self.home.groups[indexPath.section];
        
        if (![group.type isEqualToString:@"4"]) {
            
            height = indexPath.row == 0 ? kHeaderHeight : 275.f;
            
        } else {
            
            height = indexPath.row == 0 ? kHeaderHeight : 210.f;
            
        }
        
    }
    
    height *= [XBApplication isPlus] ? 1.2 : 1;
    
    return height;
}

#pragma mark -- Table view data delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- XBHomeActivityCellDelegate
- (void)homeActivityCell:(XBHomeActivityCell *)activityCell didSelectWithGroupItem:(XBGroupItem *)groupItem
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:activityCell];
    
    XBGroup *group = self.home.groups[indexPath.section];
    
    if ([group.type isEqualToString:@"4"]) {
        
        [self pushToCityVCWithCityId:[groupItem.modelId integerValue]];
    
    } else {
        
        XBActivityViewController *activityVC = [[XBActivityViewController alloc] init];
        
        activityVC.activityId = [groupItem.modelId integerValue];
        
        activityVC.hidesBottomBarWhenPushed  = YES;
        
        [self.navigationController pushViewController:activityVC animated:YES];
        
    }

}

- (void)homeActivityCell:(XBHomeActivityCell *)activityCell homeActivityContentCell:(XBHomeActivityContentCell *)homeActivityContentCell didSelectFavoriteAtIndex:(NSInteger)index {
    
    self.loginState = YES;
    
    if (![XBUserDefaultsUtil userInfo]) {
        
        self.favoriteTemp = [XBFavoriteTemp favoriteTempWithHomeActivityCell:activityCell homeActivityContentCell:homeActivityContentCell index:index];
        
        [self presentToLoginVC];
        
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:activityCell];
    
    XBGroup *group = self.home.groups[indexPath.section];
    
    XBGroupItem *groupItem = group.items[index];
    
    //取消收藏
    if (groupItem.favorite) {
        
        [[XBHttpClient shareInstance] deleteWisheWithActivityId:[groupItem.modelId integerValue] success:^(BOOL success) {
            
            groupItem.favorite = NO;
            
            homeActivityContentCell.favorite = NO;
            
        } failure:^(NSError *error) {
            
            self.favoriteTemp = [XBFavoriteTemp favoriteTempWithHomeActivityCell:activityCell homeActivityContentCell:homeActivityContentCell index:index];
            
            if (error.code == kUserUnLoginCode) {
                
                [self presentToLoginVC];
            }
            
        }];
        
    } else {
        
        [[XBHttpClient shareInstance] postWisheWithActivityId:[groupItem.modelId integerValue] success:^(BOOL success) {
            
            groupItem.favorite = YES;
            
            homeActivityContentCell.favorite = YES;
            
        } failure:^(NSError *error) {
            
            self.favoriteTemp = [XBFavoriteTemp favoriteTempWithHomeActivityCell:activityCell homeActivityContentCell:homeActivityContentCell index:index];
            
            if (error.code == kUserUnLoginCode) {
                
                [self presentToLoginVC];
            }
            
        }];
        
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.stretchHeaderView scrollViewDidScroll:scrollView];
    
    //显示、隐藏状态栏-view
    BOOL isShowStatus = fabs(scrollView.contentOffset.y) >= CGRectGetHeight(self.bannerImageView.frame) * 0.5;
    if (isShowStatus) {
        if (self.statusView.xb_y == -kStatusHeight) {
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
                self.statusView.xb_y = 0;
        
            } completion:nil];
        }
    } else {
        if (self.statusView.xb_y == 0) {
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.statusView.xb_y = - kStatusHeight;
                
            } completion:nil];
        }
    }
    
    //显示底部logo
    BOOL isShowLogo = (scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame)) > (scrollView.contentSize.height + kSpace);
    
//    DDLogDebug(@"contentOffsetY:%f    logoY:%f",scrollView.contentOffset.y,self.logoImageView.xb_maxY);
    
    self.logoImageView.hidden = !isShowLogo;
    
    self.logoLabel.hidden  = !isShowLogo;
    
}

#pragma mark -- XBHomeInviationCellDelegate
- (void)inviationCellDidSelectedClose
{
    self.home.inviation = nil;
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.home.groups.count] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.tableView endUpdates];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    });
    
}

- (void)inviationCellDidSelectedGo
{
    if ([XBUserDefaultsUtil userInfo]) {
        
        XBPromotionsViewController *promotionsVC = [[XBPromotionsViewController alloc] init];
        
        promotionsVC.couponCode = self.home.inviation.code;
        
        promotionsVC.hidesBottomBarWhenPushed = YES;
        
        [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:1];
        
        [self.navigationController pushViewController:promotionsVC animated:YES];
        
    } else {
        
        self.loginState = NO;
        
        [self presentToLoginVC];
    }
}

#pragma mark -- XBHomeHeaderCellDelegate
- (void)homeHeaderCell:(XBHomeHeaderCell *)homeHeaderCell didSelectCityWithCityId:(NSInteger)cityId
{
    [self pushToCityVCWithCityId:cityId];
}


#pragma mark -- public method
- (void)searchAction:(UIButton *)sender
{
    XBHomeSearchViewController *searchVC = [[XBHomeSearchViewController alloc] init];
    
    searchVC.hidesBottomBarWhenPushed = YES;
    
    searchVC.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

/** 用户未登录跳转到登录页 登录后进行的操作 */
- (void)loginSuccess
{
    if (!self.loginState) {
        
        [self inviationCellDidSelectedGo];
    
    } else {
        
        [self homeActivityCell:self.favoriteTemp.homeActivityCell homeActivityContentCell:self.favoriteTemp.homeActivityContentCell didSelectFavoriteAtIndex:self.favoriteTemp.index];
        
        [self.favoriteTemp.homeActivityContentCell startFavoriteAnimation];
    }
}

- (void)presentToLoginVC
{
    XBWeChatLoginViewController *weChatLoginVC = [[XBWeChatLoginViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:weChatLoginVC];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)pushToCityVCWithCityId:(NSInteger)cityId
{
    XBCityViewController *cityVC = [[XBCityViewController alloc] init];
    
    cityVC.cityId = cityId;
    
    cityVC.hidesBottomBarWhenPushed  = YES;
    
    cityVC.view.backgroundColor = [UIColor whiteColor];
    
    XBNavigationController *navigationController = (XBNavigationController *)self.navigationController;
    
    navigationController.backStateNormal = YES;
    
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)setNavigationBarTranslucent
{
    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:0];
}

@end
