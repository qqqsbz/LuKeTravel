//
//  XBHomeSearchViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/13.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeSearchViewController.h"
#import "XBSearch.h"
#import "XBSearchHot.h"
#import "XBGroupItem.h"
#import "XBSearchItem.h"
#import "XBSearchView.h"
#import "NSString+Util.h"
#import "XBSearchHistory.h"
#import "XBHomeSearchCell.h"
#import "XBSearchHeaderView.h"
#import "XBCityViewController.h"
#import "XBHomeSearchCityCell.h"
#import "XBHomeSearchFlowLayout.h"
#import "XBHomeSearchHistoryCell.h"
#import "XBHomeSearchActivityCell.h"
#import "XBHomeSearchActivityClickCell.h"
#import "XBHomeSearchHistoryHeaderView.h"
#import <MJRefresh/MJRefresh.h>
@interface XBHomeSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,XBSearchViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (assign, nonatomic) NSInteger     page;
@property (strong, nonatomic) XBSearchView  *searchView;
@property (strong, nonatomic) XBSearchHot   *searchHot;
@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) UICollectionView  *collectionView;
@property (strong, nonatomic) NSArray<XBSearchItem *>       *searchItems;
@property (strong, nonatomic) NSArray<XBSearchHistory *>    *searchHistorys;
@property (assign, nonatomic, getter=isSearchClicked) BOOL  searchClicked;
@property (strong, nonatomic) MJRefreshAutoNormalFooter     *tableFooterView;
@end

static NSString *const homeSearchActivityClickReuseIdentifier = @"XBHomeSearchActivityClickCell";
static NSString *const homeSearchReuseIdentifier = @"XBHomeSearchCell";
static NSString *const homeSearchHeaderReuseIdentifier = @"XBSearchHeaderView";
static NSString *const homeSearchCityReuseIdentifier = @"XBHomeSearchCityCell";
static NSString *const homeSearchActivityReuseIdentifier = @"XBHomeSearchActivityCell";
static NSString *const homeSearchHistoryReuseIdentifier = @"XBHomeSearchHistoryCell";
@implementation XBHomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    [self buildView];

    [self reloadDataSearchHot];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.searchView.becomFirstreSpondent = NO;
}

#pragma mark -- 从本地加载热搜关键词
- (void)reloadDataSearchHot
{
    //查询数据库是否有数据
    //查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"modelId",[self dateString]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = predicate;
    
    [[XBDBUtil shareDBUtil] queryOneWithEntityName:[XBSearchHot managedObjectEntityName] fetchRequest:fetchRequest sortDescriptors:nil complete:^(id result) {
        
        if (result) {
        
            NSError *error;
            
            self.searchHot = [MTLManagedObjectAdapter modelOfClass:[XBSearchHot class] fromManagedObject:result error:&error];
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_type"ascending:YES];
            
            self.searchHot.items = [self.searchHot.items sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

            [self dislodgeRepeatAndSortItems];
            
            [self.view bringSubviewToFront:self.collectionView];
            
            [self.collectionView reloadData];
            
        } else {
            
            [self sendSearchHotRequest];
        }
        
    }];
    
}

#pragma mark -- 获取热搜关键词
- (void)sendSearchHotRequest
{
    [XBLoadingView showInView:self.view];
    
    [[XBHttpClient shareInstance] getSearchHotWithSuccess:^(XBSearchHot *searchHot) {
        
        self.searchHot = searchHot;
        
        [self dislodgeRepeatAndSortItems];
        
        [self.view bringSubviewToFront:self.collectionView];
        
        [self.collectionView reloadData];
        
        [XBLoadingView hide];
        
        //保存到数据库
        searchHot.modelId = [self dateString];
        
        [[XBDBUtil shareDBUtil] add:searchHot];
        
    } failure:^(NSError *error) {
        
        DDLogDebug(@"error:%@",error);
        
        [self showFail:@"加载失败!"];
        
        [XBLoadingView hide];
        
    }];

}

#pragma mark -- 去除重复数据并排序
- (void)dislodgeRepeatAndSortItems
{
    for (XBSearch *search in self.searchHot.items) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:search.values.count];
        
        for (XBSearchItem *searchItem in search.values) {
            
            if (![dic valueForKey:searchItem.modelId]) {
                [dic setObject:searchItem forKey:searchItem.modelId];
            }
            
        }
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_modelId"ascending:YES];
        
        search.values = [[dic allValues] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    }
}

#pragma mark -- 关键字搜索
- (void)sendSearchRequestWithQuery:(NSString *)query isClicked:(BOOL)isClicked
{
    NSInteger limit = isClicked ? 0 : 5;        //如果按下搜索 则筛选相应的查询参数
    
    self.page = isClicked ? self.page : 1;      //如果按下搜索 则按页数显示
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[XBHttpClient shareInstance] getSearchWithQuery:query page:self.page limit:limit success:^(NSArray<XBSearchItem *> *searchs) {
        
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
        self.tableFooterView.hidden = !isClicked || self.searchItems.count <= 0;
        
        //页数+1
        self.page += isClicked ? 1 : 0;
        
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)buildView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    self.searchView = [XBSearchView new];
    self.searchView.delegate = self;
    [self.view addSubview:self.searchView];
    
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeSearchCityCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:homeSearchCityReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeSearchActivityCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:homeSearchActivityReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeSearchHistoryCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:homeSearchHistoryReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeSearchActivityClickCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:homeSearchActivityClickReuseIdentifier];
    [self.view addSubview:self.tableView];
    
    XBHomeSearchFlowLayout *flowLayout = [[XBHomeSearchFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 15.f;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.tag = 1;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeSearchCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:homeSearchReuseIdentifier];
    [self.collectionView registerClass:[XBSearchHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:homeSearchHeaderReuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    [self buildTableFooter];
}

- (void)buildTableFooter
{
    self.tableFooterView = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self sendSearchRequestWithQuery:self.searchView.searchText isClicked:YES];
        
    }];
    
    self.tableFooterView.refreshingTitleHidden = YES;
    
    self.tableFooterView.hidden = YES;
    
    self.tableView.mj_footer = self.tableFooterView;
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.searchView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.searchView.bottom);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.searchView.bottom);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}


#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.searchHot.items.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    XBSearch *search = self.searchHot.items[section];
    return search.values.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBSearch *search = self.searchHot.items[indexPath.section];
    
    XBSearchItem *item = search.values[indexPath.row];
    
    XBHomeSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeSearchReuseIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = item.name;
    
    return cell;
}


#pragma mark -- UICollectionViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XBSearch *search = self.searchHot.items[indexPath.section];
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        XBSearchHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:homeSearchHeaderReuseIdentifier forIndexPath:indexPath];
        headerView.titleLabel.text = search.name;
        headerView.titleLabel.font = [UIFont systemFontOfSize:15.f];
        headerView.titleLabel.textColor  = [UIColor colorWithHexString:kDefaultColorHex];
        return headerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){CGRectGetWidth(collectionView.frame),60};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){CGRectGetWidth(collectionView.frame),0};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth  = 55.f;
    CGFloat cellHeight = 30.f;
    
    XBSearch *search = self.searchHot.items[indexPath.section];
    XBSearchItem *item = search.values[indexPath.row];
    
    CGFloat width = [item.name sizeWithFont:[UIFont systemFontOfSize:14.f] maxSize:CGSizeMake(CGFLOAT_MAX, cellHeight)].width;
    
    cellWidth += width > 30 ? width - 30 : 0;
    
    return (CGSize){cellWidth,cellHeight};
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBHomeSearchCell *cell = (XBHomeSearchCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.titleLabel.textColor = [UIColor colorWithHexString:@"#BEBEBE"];
    
    XBSearch *search = self.searchHot.items[indexPath.section];
    
    XBSearchItem *item = search.values[indexPath.row];
    
    XBGroupItem *groupItem = [XBGroupItem new];
    
    groupItem.name = item.name;
    
    groupItem.modelId = item.modelId;
    
    if ([item.type isEqualToString:kTypeOfCity]) {
        
        XBCityViewController *cityVC = [[XBCityViewController alloc] init];
        
        cityVC.groupItem = groupItem;
        
        [self.navigationController pushViewController:cityVC animated:YES];
        
    } else if ([item.type isEqualToString:kTypeOfActivity]) {
        
        
        DDLogDebug(@"跳转到活动页........");
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBHomeSearchCell *cell = (XBHomeSearchCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.titleLabel.textColor = [UIColor colorWithHexString:@"#2F2F2F"];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchItems ? self.searchItems.count : self.searchHistorys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.searchItems && self.searchItems.count > 0) {
       
        XBSearchItem *firstItem = [self.searchItems firstObject];
        
        XBSearchItem *item = self.searchItems[indexPath.row];
        
        if (self.isSearchClicked && [firstItem.type isEqualToString:kTypeOfActivity]) {
            
            XBHomeSearchActivityClickCell *activityCell = [tableView dequeueReusableCellWithIdentifier:homeSearchActivityClickReuseIdentifier forIndexPath:indexPath];
            
            activityCell.groupItem = item;
            
            return activityCell;
            
        } else {
            
            if ([item.type isEqualToString:kTypeOfCity]) {
                
                XBHomeSearchCityCell *cityCell = [tableView dequeueReusableCellWithIdentifier:homeSearchCityReuseIdentifier forIndexPath:indexPath];
                cityCell.searchItem = item;
                return cityCell;
            }
            
            XBHomeSearchActivityCell *activityCell = [tableView dequeueReusableCellWithIdentifier:homeSearchActivityReuseIdentifier forIndexPath:indexPath];
            activityCell.searchItem = item;
            return activityCell;
        }
        
    }
    
    XBHomeSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:homeSearchHistoryReuseIdentifier forIndexPath:indexPath];
    cell.searchHistory = self.searchHistorys[indexPath.row];
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.searchItems.count > 0) {
        
        XBSearchItem *item = self.searchItems[indexPath.row];
        
        if ([item.type isEqualToString:kTypeOfCity]) {
            
            XBGroupItem *groupItem = [[XBGroupItem alloc] init];
            
            groupItem.modelId = item.modelId;
            
            groupItem.name = item.name;
            
            XBCityViewController *cityVC = [[XBCityViewController alloc] init];
            
            cityVC.groupItem = groupItem;
            
            [self.navigationController pushViewController:cityVC animated:YES];
            
        } else if ([item.type isEqualToString:kTypeOfActivity]) {
            
            DDLogDebug(@"跳转到活动页........");
            
        }
        
    } else if (self.searchHistorys.count > 0) {
        
        XBSearchHistory *history = self.searchHistorys[indexPath.row];
        
        self.searchView.searchText = history.name;
        
        [self sendSearchRequestWithQuery:history.name isClicked:NO];
        
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
        
        [self.view bringSubviewToFront:self.collectionView];
        
    }];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
    return headerView;
}

#pragma mark -- XBSearchViewDelegate
- (void)searchViewDidSelectedCancle
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)searchViewTextDidChange:(NSString *)text
{
    if ([text stringByTrimmingCharactersInSet:
        [NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
    
        //初始化数据
        self.searchItems = nil;
        
        [self sendSearchRequestWithQuery:text isClicked:NO];
    
    } else {
        //显示历史记录
        
        [self searchViewDidBeginEditing];
    
    }
}

- (void)searchViewSearchButtonClicked:(NSString *)text
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

- (void)searchViewDidBeginEditing
{
    //查询历史记录
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchLimit = 100;
    
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
            
            self.searchHistorys = historys;
            
            self.searchItems = nil;
            
            [self.view bringSubviewToFront:self.tableView];
            
            self.tableView.backgroundColor = [UIColor whiteColor];
            
            [self.tableView reloadData];
            
        } else {
            
            //加载热搜
            [self reloadDataSearchHot];
            
        }
        
    }];
}

- (NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
