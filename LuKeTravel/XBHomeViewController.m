//
//  XBHomeViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#define kHeaderHeight 50.f
#define kStatusHeight   CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define kTabbarHeight   CGRectGetHeight(self.tabBarController.tabBar.frame)
#define kResetTabviewContentSize self.tableView.contentSize.height - CGRectGetHeight(self.navigationController.navigationBar.frame)

#import "XBHomeViewController.h"
#import "XBHome.h"
#import "XBGroup.h"
#import "XBGroupItem.h"
#import "XBInviation.h"
#import "XBHomeHeaderView.h"
#import "XBHomeActivityCell.h"
#import "XBHomeInviationCell.h"
#import "XBActivityViewController.h"
#import "XBCityViewController.h"
#import "XBStretchableTableHeaderView.h"
@interface XBHomeViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,XBHomeInviationCellDelegate,XBHomeActivityCellDelegate>
@property (strong, nonatomic) UITableView   *tableView;
@property (strong, nonatomic) UIImageView   *bannerImageView;
@property (strong, nonatomic) XBHome        *home;
@property (strong, nonatomic) UIView        *statusView;
@property (strong, nonatomic) UIButton      *searchButton;
@property (strong, nonatomic) UILabel       *logoLabel;
@property (strong, nonatomic) UIImageView   *logoImageView;
@property (strong, nonatomic) XBStretchableTableHeaderView  *stretchHeaderView;
@end

static NSString *activityReuseIdentifier = @"XBHomeActivityCell";
static NSString *inviationReuseIdentifier = @"XBHomeInviationCell";
@implementation XBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTranslucent];

    [self buildView];
    
    [self reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)reloadData
{
    
    [XBLoadingView showInView:self.tabBarController.view];
    
    [[XBHttpClient shareInstance] getHomeWithLongitude:[XBUserDefaultsUtil currentLongitude] latitude:[XBUserDefaultsUtil currentLatitude] success:^(XBHome *home) {
        
        self.home = home;
        
        self.stretchHeaderView.titleLabel.text = self.home.name;
        
        self.stretchHeaderView.subTitleLabel.text = self.home.subName;
        
        //对结果进行倒序排序
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_type"ascending:YES];
        
        self.home.groups = [self.home.groups sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        [self.tableView reloadData];
        
        self.tableView.contentSize = CGSizeMake(CGRectGetWidth(self.tableView.frame),kResetTabviewContentSize);
        
        [XBLoadingView hide];
        
    } failure:^(NSError *error) {
        
        DDLogDebug(@"error:%@",error);
        
        [XBLoadingView hide];
        
        [self showFail:@"加载失败!"];
        
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
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBActivityCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:activityReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeActivityCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:activityReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeInviationCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:inviationReuseIdentifier];
    [self.view addSubview:self.tableView];
    
    
    CGFloat height = CGRectGetHeight(self.view.frame) - kTabbarHeight;
    self.bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), height * 0.605)];
    self.bannerImageView.image = [UIImage imageNamed:@"banner1.jpg"];
    self.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bannerImageView.clipsToBounds = YES;
    
    
    self.stretchHeaderView = [XBStretchableTableHeaderView new];
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
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.home.groups.count + (self.home.inviation ? 1 : 0);
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.home.groups.count) {
        return 1;
    }
    return self.home.inviation ? 1 : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.home.groups.count) {
        XBGroup *group = self.home.groups[indexPath.section];
        XBHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:activityReuseIdentifier forIndexPath:indexPath];
        cell.groupItems = group.items;
        cell.delegate = self;
        return cell;
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
            height = 275.f;
        } else {
            height = 210.f;
        }
    }
    height *= [Application isPlus] ? 1.2 : 1;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section < self.home.groups.count ? kHeaderHeight : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    XBGroup *group = self.home.groups[section];
    XBHomeHeaderView *headerView = [[XBHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 50.f)];
    headerView.leftLabel.text = group.className;
    headerView.rightLabel.text = group.displayText;
    return headerView;
}

#pragma mark -- Table view data delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- XBHomeActivityCellDelegate
- (void)activityCell:(XBHomeActivityCell *)activityCell didSelectedWithGroupItem:(XBGroupItem *)groupItem
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:activityCell];
    XBGroup *group = self.home.groups[indexPath.section];
    
    if ([group.type isEqualToString:@"4"]) {
        
        XBCityViewController *desinationVC = [[XBCityViewController alloc] init];
        
        desinationVC.groupItem = groupItem;
        
        desinationVC.hidesBottomBarWhenPushed  = YES;
        
        desinationVC.view.backgroundColor = [UIColor whiteColor];
    
        [self.navigationController pushViewController:desinationVC animated:YES];
    
    } else {
        
        XBActivityViewController *activityVC = [[XBActivityViewController alloc] init];
        
        activityVC.groupItem = groupItem;
        
        activityVC.hidesBottomBarWhenPushed  = YES;
        
        [self.navigationController pushViewController:activityVC animated:YES];
        
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
    self.logoImageView.hidden = !isShowLogo;
    self.logoLabel.hidden  = !isShowLogo;
    
    
//    //section header 不悬浮
//    CGFloat sectionHeaderHeight = kHeaderHeight;
//    
//    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
//        
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        
//    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
//        
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        
//    }
    
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
    
}

#pragma mark -- public method
- (void)searchAction:(UIButton *)sender
{
    
}

- (void)setNavigationBarTranslucent
{
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 64.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setClipsToBounds:YES];
}

@end
