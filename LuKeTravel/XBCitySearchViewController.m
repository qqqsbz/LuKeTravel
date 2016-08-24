//
//  XBCitySearchViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCitySearchViewController.h"
#import "XBSearchItem.h"
#import "XBSearchHistory.h"
#import "XBSearchNoResultView.h"
#import "XBHomeSearchCityCell.h"
#import "XBSearchNavigationBar.h"
#import "XBHomeSearchHistoryCell.h"
#import "XBHomeSearchActivityCell.h"
#import "XBActivityViewController.h"
#import "XBHomeSearchHistoryHeaderView.h"
#import "XBHomeSearchActivityClickCell.h"
#import <MJRefresh/MJRefresh.h>
@interface XBCitySearchViewController () <XBSearchNavigationBarDelegate,XBHomeSearchActivityClickCellDelegate,UITableViewDelegate,UITableViewDataSource>
/** 搜索导航栏 */
@property (strong, nonatomic) XBSearchNavigationBar *navigationBar;
/** 毛玻璃 */
@property (strong, nonatomic) UIVisualEffectView *effectView;
/** 列表 */
@property (strong, nonatomic) UITableView *tableView;
/** 没有搜索结果 */
@property (strong, nonatomic) XBSearchNoResultView *noResultView;
/** 当前页数 */
@property (assign, nonatomic) NSInteger  page;
/** 是否点击 “搜索” */
@property (assign, nonatomic, getter=isSearchClicked) BOOL  searchClicked;
/** 搜索结果 */
@property (strong, nonatomic) NSArray<XBSearchItem *>       *searchItems;
/** 搜索历史 */
@property (strong, nonatomic) NSArray<XBSearchHistory *>    *searchHistorys;
/** 加载更多 */
@property (strong, nonatomic) MJRefreshAutoNormalFooter     *tableFooterView;
@end

static NSString *const homeSearchActivityReuseIdentifier = @"XBHomeSearchActivityCell";
static NSString *const homeSearchHistoryReuseIdentifier = @"XBHomeSearchHistoryCell";
static NSString *const homeSearchActivityClickReuseIdentifier = @"XBHomeSearchActivityClickCell";
@implementation XBCitySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    //加载搜索历史
    [self searchNavigationBarDidBeginEditing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (BOOL)becomeFirstResponder
{
    self.navigationBar.becomFirstreSpondent = YES;
    
    return self.navigationBar.becomFirstreSpondent;
}

- (void)buildView
{
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];

    self.navigationBar = [XBSearchNavigationBar new];
    self.navigationBar.becomFirstreSpondent = YES;
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.effectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.37f];
    [self.view addSubview:self.effectView];
    
    self.noResultView = [XBSearchNoResultView new];
    self.noResultView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.noResultView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeSearchHistoryCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:homeSearchHistoryReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeSearchActivityClickCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:homeSearchActivityClickReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeSearchActivityCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:homeSearchActivityReuseIdentifier];
    [self.view addSubview:self.tableView];
    
    self.tableFooterView = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self sendSearchRequestWithQuery:self.navigationBar.searchText isClicked:YES];
        
    }];
    
    self.tableFooterView.refreshingTitleHidden = YES;
    
    self.tableFooterView.hidden = YES;
    
    self.tableView.mj_footer = self.tableFooterView;
    
    [self.tableFooterView setTitle:@"" forState:MJRefreshStateIdle];
    
    [self.tableFooterView setTitle:@"" forState:MJRefreshStatePulling];
    
    [self.tableFooterView setTitle:@"" forState:MJRefreshStateRefreshing];
    
    [self.tableFooterView setTitle:@"" forState:MJRefreshStateNoMoreData];
    
    self.tableView.hidden = YES;
    
    self.noResultView.hidden = YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    [self.effectView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.navigationBar.bottom);
        make.bottom.equalTo(self.view);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.effectView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.noResultView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.effectView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


#pragma mark -- UITableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchItems.count > 0 ? self.searchItems.count : self.searchHistorys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchItems.count > 0) {
        
        XBSearchItem *firstItem = [self.searchItems firstObject];
        
        XBSearchItem *item = self.searchItems[indexPath.row];
        
        if (self.isSearchClicked && [firstItem.type isEqualToString:kTypeOfActivity]) {
            
            XBHomeSearchActivityClickCell *activityCell = [tableView dequeueReusableCellWithIdentifier:homeSearchActivityClickReuseIdentifier forIndexPath:indexPath];
            
            activityCell.searchItem = item;
            
            activityCell.delegate = self;
            
            return activityCell;
            
        } else {
            
            XBHomeSearchActivityCell *activityCell = [tableView dequeueReusableCellWithIdentifier:homeSearchActivityReuseIdentifier forIndexPath:indexPath];
            activityCell.searchItem = item;
            return activityCell;
        }
        
    }
    
    XBHomeSearchHistoryCell *searchHistoryCell = [tableView dequeueReusableCellWithIdentifier:homeSearchHistoryReuseIdentifier forIndexPath:indexPath];
    
    searchHistoryCell.searchHistory = self.searchHistorys[indexPath.row];
    
    return searchHistoryCell;
}

#pragma mark -- UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchHistorys.count > 0) {
        
        XBSearchHistory *searchHistory = self.searchHistorys[indexPath.row];
        
        [self.navigationBar setSearchText:searchHistory.name];
        
        [self sendSearchRequestWithQuery:searchHistory.name isClicked:NO];
        
    } else {
        
        XBSearchItem *searchItem = self.searchItems[indexPath.row];
        
        XBActivityViewController *activityVC = [[XBActivityViewController alloc] init];
        
        activityVC.activityId = [searchItem.modelId integerValue];
        
        [self.navigationController pushViewController:activityVC animated:YES];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchItems.count > 0) {
        
        CGFloat height = 0;
        
        XBSearchItem *firstItem = [self.searchItems firstObject];
        
        if (self.isSearchClicked && [firstItem.type isEqualToString:kTypeOfActivity]) {
            
            height = 240;
            
        } else {
            
            XBSearchItem *item = self.searchItems[indexPath.row];
            
            if ([item.type isEqualToString:kTypeOfCity]) {
                
                height = 45.f;
                
            } else if ([item.type isEqualToString:kTypeOfActivity]) {
                
                height = 60.f;
                
            }
        }
        
        
        return height;
    }
    
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.searchHistorys.count > 0 ? 30 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XBHomeSearchHistoryHeaderView *headerView = [[XBHomeSearchHistoryHeaderView alloc] initWithClearBlock:^{
        
        [[XBDBUtil shareDBUtil] removes:self.searchHistorys];
        
        self.searchHistorys = nil;
        
        [self.view bringSubviewToFront:self.effectView];
        
    }];
    
    headerView.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
    
    return headerView;
}

#pragma mark -- XBHomeSearchActivityClickCellDelegate
- (void)searchActivityClickCell:(XBHomeSearchActivityClickCell *)searchActivityClickCell didSelectFavorite:(XBSearchItem *)searchItem
{
    if (searchItem.favorite) {
        
        [[XBHttpClient shareInstance] deleteWisheWithActivityId:[searchItem.modelId integerValue] success:^(BOOL success) {
            
            searchItem.favorite = !success;
            
            searchActivityClickCell.favorite = !success;
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        [[XBHttpClient shareInstance] postWisheWithActivityId:[searchItem.modelId integerValue] success:^(BOOL success) {
            
            searchItem.favorite = success;
            
            searchActivityClickCell.favorite = success;
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}

#pragma mark -- XBSearchNavigationBarDelegate
- (void)searchNavigationBarDidSelectedCancle
{
    [UIView animateWithDuration:0.25 delay:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.navigationBar.becomFirstreSpondent = NO;
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }];
    
}

- (void)searchNavigationBarTextDidChange:(NSString *)text
{
    if ([text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        
        //初始化数据
        self.searchItems = nil;
        
        [self sendSearchRequestWithQuery:text isClicked:NO];
        
    } else {
        //显示历史记录
        
        [self searchNavigationBarDidBeginEditing];
        
    }
}

/** 查询搜索历史 */
- (void)searchNavigationBarDidBeginEditing
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchLimit = 1000000;
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
    
    [[XBDBUtil shareDBUtil] queryListWithEntityName:[XBSearchHistory managedObjectEntityName] fetchRequest:fetchRequest sortDescriptors:@[sortDesc] complete:^(NSArray *datas) {
        
        //是否存在历史记录
        if (datas.count > 0) {
            
            NSMutableArray *historys = [NSMutableArray arrayWithCapacity:datas.count];
            
            NSError *error;
            
            for (id model in datas) {
                
                XBSearchHistory *history = [MTLManagedObjectAdapter modelOfClass:[XBSearchHistory class] fromManagedObject:model error:&error];
                
                if (!error) {
                    [historys addObject:history];
                }
            }
            
            //不成为第一响应者 隐藏键盘
            self.navigationBar.becomFirstreSpondent = NO;
            
            [self.view bringSubviewToFront:self.tableView];
            
            self.searchHistorys = historys;
            
            self.searchItems = nil;
            
            self.tableView.backgroundColor = [UIColor whiteColor];
            
            [self.tableView reloadData];
            
            self.noResultView.hidden = YES;
            
            self.tableView.hidden = NO;
            
        } else {
            
            self.tableView.hidden = YES;
            
            self.noResultView.hidden = YES;
        }
        
    }];
}

- (void)searchNavigationBarSearchButtonClicked:(NSString *)text
{
    //初始化数据
    self.page = 1;
    
    self.searchItems = nil;
    
    [self sendSearchRequestWithQuery:text isClicked:YES];
    
    //保存搜索记录
    XBSearchHistory *history = [XBSearchHistory new];
    
    history.name = text;
    
    history.createdDate = [NSDate date];
    
    [[XBDBUtil shareDBUtil] add:history];
}

#pragma mark -- 关键字搜索
- (void)sendSearchRequestWithQuery:(NSString *)query isClicked:(BOOL)isClicked
{
    NSInteger limit = isClicked ? 0 : 5;        //如果按下搜索 则筛选相应的查询参数
    
    self.page = isClicked ? self.page : 1;      //如果按下搜索 则按页数显示
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[XBHttpClient shareInstance] getSearchWithQuery:query page:self.page limit:limit cityId:self.cityId success:^(NSArray<XBSearchItem *> *searchs) {
        
        if (searchs.count > 0) {
            
            self.searchClicked = isClicked;
            
            if (self.searchItems.count <= 0) {
                
                self.searchItems = searchs;
                
            } else {
                
                self.searchItems = [self.searchItems arrayByAddingObjectsFromArray:searchs];
                
                [self.tableFooterView endRefreshing];
                
            }
            
            self.searchHistorys = nil;
            
            [self.tableView reloadData];
            
            BOOL showClickCell = [[self.searchItems firstObject].type isEqualToString:kTypeOfActivity] && isClicked;
            
            //如果不是搜索tableView背景则显示白色
            self.tableView.backgroundColor = showClickCell ? [UIColor colorWithHexString:@"#F5F5F5"] : [UIColor whiteColor];
            
            //把tableview显示在最前面
            [self.view bringSubviewToFront:self.tableView];
            
            //如果是点击搜索则显示加载更多
            self.tableFooterView.hidden = !isClicked || searchs.count <= 0;
            
            //页数+1
            self.page += isClicked ? 1 : 0;
            
            self.noResultView.hidden = YES;
            
            self.tableView.hidden = NO;
            
        } else {
            
            if (self.searchItems.count > 0) {
                
                self.tableView.hidden = NO;
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
                [self.view bringSubviewToFront:self.tableView];
                
            } else {
                
                self.tableView.hidden = YES;
                
                self.noResultView.hidden = NO;
                
                [self.view bringSubviewToFront:self.noResultView];
            }
        }
        
        
    } failure:^(NSError *error) {
        
        [self showNoSignalAlert];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
