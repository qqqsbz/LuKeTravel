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
#import "UIImage+Util.h"
#import "XBSearchView.h"
#import "XBLoadingView.h"
#import "XBHomeHeaderView.h"
#import "XBHomeActivityCell.h"
#import "XBCityPushTransition.h"
#import "XBDesinationFooterView.h"
#import "XBStretchableCityHeaderView.h"
@interface XBCityViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView   *tableView;
@property (strong, nonatomic) XBCity        *city;
@property (strong, nonatomic) UIView        *navigationView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UIButton      *backButton;
@property (strong, nonatomic) UIButton      *searchButton;
@property (strong, nonatomic) XBSearchView  *searchView;
@property (strong, nonatomic) NSMutableDictionary           *groupDic;
@property (strong, nonatomic) XBDesinationFooterView        *footerView;
@property (strong, nonatomic) XBStretchableCityHeaderView   *stretchHeaderView;
@end

static NSString *const reuseIdentifier = @"XBHomeActivityCell";
@implementation XBCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    //如果为普通类型则默认加载数据 
    if (self.type == XBCityViewControllerTypeNormal) {
        [self reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)reloadData
{
    [XBLoadingView showInView:self.view];
    [[XBHttpClient shareInstance] getCitiesWithCityId:[self.groupItem.modelId integerValue] success:^(XBCity *city) {
        
        self.city = city;
        
        self.stretchHeaderView.levelOneTableView.hidden = NO;
        
        [XBLoadingView hide];
        
        self.stretchHeaderView.title = city.name;
        
        self.stretchHeaderView.levelOnes = self.city.levelOnes;
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.city.imageUrl]];
        
        [self soreGroups];
        
        [self loadWeather];
        
        self.tableView.tableFooterView = self.footerView;
        
        [self.stretchHeaderView startAnimation];
        
    } failure:^(NSError *error) {
    
        DDLogDebug(@"error:%@",error);
        
        [XBLoadingView hide];
   
    }];
}

//获取城市天气信息
- (void)loadWeather
{
    [[XBHttpClient shareInstance] getWeatherWithCityId:[self.groupItem.modelId integerValue] success:^(XBWeather *weather) {
        
        self.stretchHeaderView.temperatureLabel.text = [NSString stringWithFormat:@"%@ °C",[NSIntegerFormatter formatToNSString:weather.temperature]];
        
        self.stretchHeaderView.temperatureImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"weather%@",weather.type]];;
        
    } failure:^(NSError *error) {
        
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
    self.searchView =  [XBSearchView new];
    [self.view addSubview:self.searchView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
//    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#DCDFE0"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeActivityCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 185)];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    
    self.stretchHeaderView = [XBStretchableCityHeaderView new];
    [self.stretchHeaderView stretchHeaderForTableView:self.tableView withView:self.coverImageView];
    self.stretchHeaderView.levelOneTableView.hidden = YES;
    
    self.footerView = [[XBDesinationFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 100) title:NSLocalizedString(@"desination-viewall", @"desination-viewall") didSelectedBlock:^{
        DDLogDebug(@"view all");
    }];
    
    self.navigationItem.hidesBackButton = YES;

    self.navigationView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self.view addSubview:self.navigationView];

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.alpha = 0.f;
    self.titleLabel.font  = [UIFont systemFontOfSize:19.f];
    self.titleLabel.textColor = [UIColor colorWithRed:28.f/255.f green:28.f/255.f blue:28.f/255.f alpha:1.f];
    self.titleLabel.text = self.groupItem.name;
    [self.view addSubview:self.titleLabel];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];

    [self addConstraint];
}

- (void)addConstraint
{
    [self.searchView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.navigationView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(25);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(35);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.backButton);
    }];
    
    [self.searchButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.centerY.equalTo(self.backButton);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
}

- (void)buttonAction:(UIButton *)sender
{
    if (sender == self.backButton) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        [self.view bringSubviewToFront:self.searchView];
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
    return headerView;
}

#pragma mark -- UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.stretchHeaderView scrollViewDidScroll:scrollView];
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    CGFloat alpha = contentOffsetY - kThreshold;
    
    self.navigationView.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha/50];
    
    self.titleLabel.alpha = alpha;
    
    BOOL changeIcon = contentOffsetY > 0 && contentOffsetY > kThreshold;
    
    [self.backButton setImage:[UIImage imageNamed:changeIcon ? @"backArrow" : @"Back_Arrow"] forState:UIControlStateNormal];
    
    [self.searchButton setImage:changeIcon ? [[UIImage imageNamed:@"search"] imageContentWithColor:[UIColor colorWithHexString:kDefaultColorHex]] : [UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    
    [[UIApplication sharedApplication] setStatusBarStyle:changeIcon ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent];
    
    //section header 不悬浮
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
// 
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [XBCityPushTransition transitionWithTransitionType:operation == UINavigationControllerOperationPush ? XBCityPushTransitionTypePush : XBCityPushTransitionTypePop];
}

#pragma mark -- private method
- (NSMutableDictionary *)groupDic
{
    if (!_groupDic) {
        _groupDic = [NSMutableDictionary dictionary];
    }
    return _groupDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
