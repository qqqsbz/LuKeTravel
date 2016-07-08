//
//  XBDesinationViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDesinationViewController.h"
#import "XBCity.h"
#import "XBGroup.h"
#import "XBWeather.h"
#import "XBGroupItem.h"
#import "XBLoadingView.h"
#import "XBHomeActivityCell.h"
#import "XBHomeHeaderView.h"
#import "XBStretchableCityHeaderView.h"
@interface XBDesinationViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView   *tableView;
@property (strong, nonatomic) UIImageView   *coverImageView;
@property (strong, nonatomic) XBCity        *city;
@property (strong, nonatomic) NSMutableDictionary  *groupDic;
@property (strong, nonatomic) XBStretchableCityHeaderView  *stretchHeaderView;
@end

static NSString *const reuseIdentifier = @"XBHomeActivityCell";
@implementation XBDesinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)reloadData
{
    [XBLoadingView showInView:self.view];
    [[XBHttpClient shareInstance] getCitiesWithCityId:[self.groupItem.modelId integerValue] success:^(XBCity *city) {
        
        self.city = city;
        
        [XBLoadingView hide];
        
        self.stretchHeaderView.title = city.name;
        
        self.stretchHeaderView.levelOnes = self.city.levelOnes;
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.city.imageUrl]];
        
        [self soreGroups];
        
        [self loadWeather];
        
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#DCDFE0"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeActivityCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 185)];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    
    self.stretchHeaderView = [XBStretchableCityHeaderView new];
    [self.stretchHeaderView stretchHeaderForTableView:self.tableView withView:self.coverImageView];
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
    return 50.f;
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
