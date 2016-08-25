//
//  XBDesinationViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kHeaderHeight 50.f
#define kThreshold    75.f
#import "XBCityViewController.h"
#import "XBCity.h"
#import "XBGroup.h"
#import "XBWeather.h"
#import "XBGroupItem.h"
#import "XBSearchItem.h"
#import "UIImage+Util.h"
#import "XBLoadingView.h"
#import "XBFavoriteTemp.h"
#import "XBHomeHeaderView.h"
#import "XBHomeActivityCell.h"
#import "XBCityPushTransition.h"
#import "XBNavigationController.h"
#import "XBDesinationFooterView.h"
#import "XBCitySearchTransition.h"
#import "XBActivityViewController.h"
#import "XBHomeActivityContentCell.h"
#import "XBCitySearchViewController.h"
#import "XBStretchableCityHeaderView.h"
#import "XBWeChatLoginViewController.h"
#import "XBMoreActivityViewController.h"

@interface XBCityViewController () <UITableViewDelegate,UITableViewDataSource,XBHomeActivityCellDelegate,UIViewControllerTransitioningDelegate>
/** 数据列表 */
@property (strong, nonatomic) UITableView   *tableView;
/** 城市数据 */
@property (strong, nonatomic) XBCity        *city;
/** 返回按钮 */
@property (strong, nonatomic) UIButton      *backButton;
/** 搜索按钮 */
@property (strong, nonatomic) UIButton      *searchButton;
/** 分组头部view */
@property (strong, nonatomic) NSMutableArray                *sectionHeaderViews;
/** 分组数据 */
@property (strong, nonatomic) NSMutableDictionary           *groupDic;
/** 存放登录前的收藏信息 */
@property (strong, nonatomic) XBFavoriteTemp                *favoriteTemp;
/** 底部view */
@property (strong, nonatomic) XBDesinationFooterView        *footerView;
/** 处理封面拉伸 */
@property (strong, nonatomic) XBStretchableCityHeaderView   *stretchHeaderView;
@end

static NSString *const reuseIdentifier = @"XBHomeActivityCell";
@implementation XBCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self buildView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kUserLoginSuccessNotificaton object:nil];
    
    //如果为普通类型则默认加载数据 
    if (self.type == XBCityViewControllerTypeNormal) {
        [self reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:[[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha == 1 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent];

    [self setNavigationAlphaWithScrollView:self.tableView];
    
    self.backButton = self.navigationItem.leftBarButtonItem.customView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:0];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:79.f/255.f green:79.f/255.f blue:79.f/255.f alpha:1]};
}

- (void)reloadData
{
    [XBLoadingView showInView:self.view];
    
    [[XBHttpClient shareInstance] getCitiesWithCityId:self.cityId success:^(XBCity *city) {
        
        [XBLoadingView hide];
        
        self.city = city;
        
        self.stretchHeaderView.levelOneTableView.hidden = NO;
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        self.title = city.name;
        
        self.stretchHeaderView.title = city.name;
        
        self.stretchHeaderView.levelOnes = self.city.levelOnes;
        
        self.view.userInteractionEnabled = YES;
        
        [self soreGroups];
        
        [self loadWeather];
        
        [self startStretchableHeaderAnimation];
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.city.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
        
        self.tableView.tableFooterView = self.footerView;
        
    } failure:^(NSError *error) {
    
        DDLogDebug(@"error:%@",error);
        
        [XBLoadingView hide];
        
        [self showNoSignalAlert];
   
    }];
}

//获取城市天气信息
- (void)loadWeather
{
    [[XBHttpClient shareInstance] getWeatherWithCityId:self.cityId success:^(XBWeather *weather) {
        
        self.stretchHeaderView.temperatureLabel.text = [NSString stringWithFormat:@"%@ °C",[NSIntegerFormatter formatToNSString:weather.temperature]];
        
        self.stretchHeaderView.temperatureImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"weather%@",weather.type]];;
        
        [self.stretchHeaderView startWeatherAnimationWithComplete:^{
            
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)startStretchableHeaderAnimation
{
    NSArray *visibleCells = [self.tableView visibleCells];
    
    for (UITableViewCell *cell in visibleCells) {
        cell.alpha = 0.f;
    }
    
    for (XBHomeHeaderView *headerView in self.sectionHeaderViews) {
        headerView.alpha = 0;
    }
    
    [self.stretchHeaderView startLevelOneAnimationWithComplete:^{
        
        [UIView animateWithDuration:0.4 delay:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            for (UITableViewCell *cell in visibleCells) {
                cell.alpha = 1.f;
            }
            
            for (XBHomeHeaderView *headerView in self.sectionHeaderViews) {
                headerView.alpha = 1.f;
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

- (void)soreGroups
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_type"ascending:YES];
    
    self.city.groups = [self.city.groups sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    for (XBGroup  *group in self.city.groups) {
        
        if ([self.groupDic objectForKey:group.type]) {
            
            NSMutableArray *datas = [self.groupDic objectForKey:group.type];
            
            [datas addObject:group];
            
        } else {
            
            NSMutableArray *datas = [NSMutableArray arrayWithObject:group];
            
            [self.groupDic setObject:datas forKey:group.type];
            
        }
    }
    
    [self.tableView reloadData];
    
}

- (void)buildView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#DCDFE0"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeActivityCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 185)];
    self.coverImageView.image = [UIImage imageNamed:@"placeholder_image"];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    
    self.stretchHeaderView = [XBStretchableCityHeaderView new];
    [self.stretchHeaderView stretchHeaderForTableView:self.tableView withView:self.coverImageView];
    self.stretchHeaderView.levelOneTableView.hidden = YES;
    
    self.footerView = [[XBDesinationFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 100) title:[XBLanguageControl localizedStringForKey:@"destination-browse-all"] didSelectedBlock:^{
        
        XBMoreActivityViewController *moreActivityVC = [[XBMoreActivityViewController alloc] initWithCityId:self.cityId];
        
        moreActivityVC.view.backgroundColor = [UIColor whiteColor];
    
        [self.navigationController pushViewController:moreActivityVC animated:YES];
    
    }];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:28.f/255.f green:28.f/255.f blue:28.f/255.f alpha:0]};
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.enabled = NO;
    self.searchButton.frame = CGRectMake(0, 0, 23, 23);
    self.searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    
    self.view.userInteractionEnabled = NO;
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender == self.backButton) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        XBCitySearchViewController *citySearchVC = [[XBCitySearchViewController alloc] init];
        
        citySearchVC.cityId = self.cityId;
        
        XBNavigationController *navigationController = [[XBNavigationController alloc] initWithRootViewController:citySearchVC];
        
        navigationController.navigationBarHidden = YES;
        
        [[[navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
        
        navigationController.transitioningDelegate = self;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groupDic allKeys].count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key  = [self.groupDic allKeys][section];
    
    NSArray *datas = [self.groupDic objectForKey:key];
    
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key  = [self.groupDic allKeys][indexPath.section];
    
    NSArray *datas = [self.groupDic objectForKey:key];
    
    XBGroup *group = datas[indexPath.row];
    
    XBHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.groupItems = group.items;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return kHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key  = [self.groupDic allKeys][section];
    
    NSArray *datas = [self.groupDic objectForKey:key];
    
    XBGroup *group = [datas firstObject];
    
    XBHomeHeaderView *headerView = [[XBHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 50.f)];
    
    headerView.leftLabel.text = group.className;
    
    headerView.rightLabel.text = group.displayText;
    
    [self.sectionHeaderViews addObject:headerView];
    
    return headerView;
}

#pragma mark -- XBHomeActivityCellDelegate
- (void)homeActivityCell:(XBHomeActivityCell *)activityCell didSelectWithGroupItem:(XBGroupItem *)groupItem
{
    
    if (groupItem.hotState.length <= 0) {
        
        XBMoreActivityViewController *moreActivityVC = [[XBMoreActivityViewController alloc] initWithCityId:self.cityId];
        
        moreActivityVC.view.backgroundColor = [UIColor whiteColor];
        
        [self.navigationController pushViewController:moreActivityVC animated:YES];
        
    } else {
        
        XBActivityViewController *activityVC = [[XBActivityViewController alloc] init];
        
        activityVC.activityId = [groupItem.modelId integerValue];
        
        [self.navigationController pushViewController:activityVC animated:YES];
        
    }
    
}

- (void)homeActivityCell:(XBHomeActivityCell *)activityCell homeActivityContentCell:(XBHomeActivityContentCell *)homeActivityContentCell didSelectFavoriteAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:activityCell];
    
    NSString *key  = [self.groupDic allKeys][indexPath.section];
    
    XBGroup *group = [[self.groupDic objectForKey:key] objectAtIndex:indexPath.row];
    
    XBGroupItem *groupItem = [group.items objectAtIndex:index];
    
    //取消收藏
    if (groupItem.favorite) {
        
        [[XBHttpClient shareInstance] deleteWisheWithActivityId:[groupItem.modelId integerValue] success:^(BOOL success) {
            
            groupItem.favorite = NO;
            
            homeActivityContentCell.favorite = NO;
            
        } failure:^(NSError *error) {
            
            if (error.code == kUserUnLoginCode) {
                
                self.favoriteTemp = [XBFavoriteTemp favoriteTempWithHomeActivityCell:activityCell homeActivityContentCell:homeActivityContentCell index:index];
                
                [self presentToLoginVC];
            }
            
        }];
        
    } else {
        
        [[XBHttpClient shareInstance] postWisheWithActivityId:[groupItem.modelId integerValue] success:^(BOOL success) {
            
            groupItem.favorite = YES;
            
            homeActivityContentCell.favorite = YES;
            
        } failure:^(NSError *error) {
            
            if (error.code == kUserUnLoginCode) {
                
                self.favoriteTemp = [XBFavoriteTemp favoriteTempWithHomeActivityCell:activityCell homeActivityContentCell:homeActivityContentCell index:index];
                
                [self presentToLoginVC];
            }
            
        }];
        
    }
    
}

#pragma mark -- UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.stretchHeaderView scrollViewDidScroll:scrollView];
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    [self setNavigationAlphaWithScrollView:scrollView];
    
    BOOL changeIcon = contentOffsetY > 0 && contentOffsetY > kThreshold;
    
    [self.backButton setImage:[UIImage imageNamed:changeIcon ? @"backArrow" : @"Back_Arrow"] forState:UIControlStateNormal];
    
    [self.searchButton setImage:changeIcon ? [[UIImage imageNamed:@"search"] imageContentWithColor:[UIColor colorWithHexString:kDefaultColorHex]] : [UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    
    [[UIApplication sharedApplication] setStatusBarStyle:changeIcon ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent];
    
    //section header 不悬浮
    CGFloat sectionHeaderHeight = kHeaderHeight;
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
 
}


/** 转场动画-push */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    NSString *moreActivityVC = NSStringFromClass([XBMoreActivityViewController class]);
    
    NSString *activityVC = NSStringFromClass([XBActivityViewController class]);
    
    if ([NSStringFromClass([fromVC class]) isEqualToString:moreActivityVC] || [NSStringFromClass([toVC class]) isEqualToString:moreActivityVC]) {
        
        return nil;
        
    } else if ([NSStringFromClass([fromVC class]) isEqualToString:activityVC] || [NSStringFromClass([toVC class]) isEqualToString:activityVC]) {
        
        return nil;
    }
    
    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:0];
    
    return [XBCityPushTransition transitionWithTransitionType:operation == UINavigationControllerOperationPush ? XBCityPushTransitionTypePush : XBCityPushTransitionTypePop];
}

/** 转场动画-present */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [XBCitySearchTransition transitionWithTransitionType:XBCitySearchTransitionTypePresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [XBCitySearchTransition transitionWithTransitionType:XBCitySearchTransitionTypeDismiss];
}

- (void)setNavigationAlphaWithScrollView:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    CGFloat alpha = contentOffsetY - kThreshold;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha/50];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:28.f/255.f green:28.f/255.f blue:28.f/255.f alpha:alpha/50]};
}

/** 跳转到登录界面 */
- (void)presentToLoginVC
{
    XBWeChatLoginViewController *weChatLoginVC = [[XBWeChatLoginViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:weChatLoginVC];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

/** 登录成功后的操作 */
- (void)loginSuccess
{
    [self.favoriteTemp.homeActivityContentCell startFavoriteAnimation];
    
    [self homeActivityCell:self.favoriteTemp.homeActivityCell homeActivityContentCell:self.favoriteTemp.homeActivityContentCell didSelectFavoriteAtIndex:self.favoriteTemp.index];
}

#pragma mark -- private method
- (NSMutableDictionary *)groupDic
{
    if (!_groupDic) {
        
        _groupDic = [NSMutableDictionary dictionary];
    }
    return _groupDic;
}

- (NSMutableArray *)sectionHeaderViews
{
    if (!_sectionHeaderViews) {
        
        _sectionHeaderViews = [NSMutableArray array];
    }
    return _sectionHeaderViews;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
