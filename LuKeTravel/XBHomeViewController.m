//
//  XBHomeViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#define kStatusHeight CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define kTabbarHeight CGRectGetHeight(self.tabBarController.tabBar.frame)
#import "XBHomeViewController.h"
#import "XBHome.h"
#import "XBGroup.h"
#import "XBGroupItem.h"
#import "XBInviation.h"
#import "XBHomeActivityCell.h"
#import "XBHomeInviationCell.h"
#import "XBStretchableTableHeaderView.h"
@interface XBHomeViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,XBHomeInviationCellDelegate>
@property (strong, nonatomic) UITableView   *tableView;
@property (strong, nonatomic) UIImageView   *bannerImageView;
@property (strong, nonatomic) XBHome        *home;
@property (strong, nonatomic) UIView        *statusView;
@property (strong, nonatomic) UIButton      *searchButton;
@property (strong, nonatomic) UILabel       *moreLabel;
@property (strong, nonatomic) UIImageView   *moreImageView;
@property (strong, nonatomic) XBStretchableTableHeaderView  *stretchHeaderView;
@end

static NSString *activityReuseIdentifier = @"XBHomeActivityCell";
static NSString *inviationReuseIdentifier = @"XBHomeInviationCell";
@implementation XBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self buildView];
    
    [self reloadData];
}

- (void)reloadData
{
    [[XBHttpClient shareInstance] getHomeWithLongitude:[XBUserDefaultsUtil currentLongitude] latitude:[XBUserDefaultsUtil currentLatitude] success:^(XBHome *home) {
        
        self.home = home;
        
        self.stretchHeaderView.titleLabel.text = self.home.name;
        
        self.stretchHeaderView.subTitleLabel.text = self.home.subName;
        
        //对结果进行倒序排序
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_type"ascending:YES];
        
        self.home.groups = [self.home.groups sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        DDLogDebug(@"error:%@",error);
    }];
}

- (void)buildView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kTabbarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
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
    
    self.moreImageView = [UIImageView new];
    self.moreImageView.image = [UIImage imageNamed:@"Klook_More"];
    
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
    
}

- (void)bannerStartAnimation
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = self.home.groups.count;
    
    count += self.home.inviation ? 1 : 0;
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.home.groups.count) {
        XBHomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:activityReuseIdentifier forIndexPath:indexPath];
        XBGroup *group = self.home.groups[indexPath.row];
        cell.titleLabel.text = group.className;
        if (![group.type isEqualToString:@"4"]) {
            cell.activities = group.items;
            cell.subTitleLabel.text = @"";
        } else {
            XBGroupItem *item = [group.items firstObject];
            cell.destination = group.items;
            cell.subTitleLabel.text = item.name;
        }
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
    if (indexPath.row < self.home.groups.count) {
        XBGroup *group = self.home.groups[indexPath.row];
        if (![group.type isEqualToString:@"4"]) {
            height = 290.f;
        } else {
            height = 245.f;
        }
    }
    height *= [Application isPlus] ? 1.2 : 1;
    return height;
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
    
}

#pragma mark -- XBHomeInviationCellDelegate
- (void)inviationCellDidSelectedClose
{
    self.home.inviation = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)inviationCellDidSelectedGo
{
    
}

#pragma mark -- public method
- (void)searchAction:(UIButton *)sender
{
    
}

@end
