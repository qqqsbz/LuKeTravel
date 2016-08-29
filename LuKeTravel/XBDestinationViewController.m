//
//  XBDestinationViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDestinationViewController.h"
#import "XBTSTView.h"
#import "XBGroupItem.h"
#import "NSString+Util.h"
#import "XBDestination.h"
#import "XBHotDestination.h"
#import "XBDestinationItem.h"
#import "XBDestinationCities.h"
#import "XBDestinationHotCell.h"
#import "XBDestinationAllCell.h"
#import "XBCityViewController.h"
#import "XBDesinationFooterView.h"
#import "XBDestinationAllLayout.h"
#import "XBNavigationController.h"
#import "XBDestinationAllHeaderView.h"
#import "XBDestinationAllFooterView.h"
@interface XBDestinationViewController () <TSTViewDelegate,TSTViewDataSource,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
/** 多视图切换 */
@property (strong, nonatomic) XBTSTView         *tstView;
/** 标题 */
@property (strong, nonatomic) NSArray           *titles;
/** 目的地数据 */
@property (strong, nonatomic) XBDestination     *destination;
/** 列表 */
@property (strong, nonatomic) UICollectionView  *allCollectionView;
/** 底部view */
@property (strong, nonatomic) XBDesinationFooterView  *desinationFooterView;
@end

static NSString *const destinationCityReuseIdentifier = @"XBDestinationHotCell";
static NSString *const destinationAllReuseIdentifier = @"XBDestinationAllCell";
static NSString *const destinationAllHeaderReuseIdentifier = @"XBDestinationAllHeaderView";
static NSString *const destinationAllFooterReuseIdentifier = @"XBDestinationAllFooterView";
@implementation XBDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self reloadLanguageConfig];
    
    [self buildView];
    
    [self reloadData];
}

- (void)reloadData
{
    [XBLoadingView showInView:self.navigationController.view];
    
    [[XBHttpClient shareInstance] getDestinationsWithSuccess:^(XBDestination *destination) {
        
        self.destination = destination;
        
        [self.hotTableView reloadData];
        
        self.hotTableView.tableFooterView = self.desinationFooterView;
        
        [XBLoadingView hide];
        
    } failure:^(NSError *error) {
        
        [XBLoadingView hide];
        
        DDLogDebug(@"error:%@",error);
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    //如果用户切换过语言 则重新创建页面加载数据
    if (self.destination && (![self.destination.modelLanguage isEqualToString:[XBUserDefaultsUtil currentLanguage]] || ![self.destination.modelCurrency isEqualToString:[XBUserDefaultsUtil currentCurrency]])) {
        
        [self.tstView removeFromSuperview];
        
        [self reloadLanguageConfig];
        
        [self buildView];
        
        [self reloadData];
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.navigationController.navigationBarHidden = NO;
    
    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:1];
    
}

- (void)reloadLanguageConfig
{
    self.title = [XBLanguageControl localizedStringForKey:@"destination-title"];
    
    self.titles = @[
                    [XBLanguageControl localizedStringForKey:@"destination-popular"],
                    [XBLanguageControl localizedStringForKey:@"destination-all"]
                    ];
}

- (void)buildView
{
    self.tstView = [[XBTSTView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - 49)];
    self.tstView.delegate = self;
    self.tstView.dataSource = self;
    self.tstView.shadowTitleEqualWidth = YES;
    self.tstView.onePageOfItemCount    = 2;
    self.tstView.zeroMargin = YES;
    self.tstView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.tstView reloadData];
    [self.view addSubview:self.tstView];
    
    self.desinationFooterView = [[XBDesinationFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tstView.frame), 100) title:[XBLanguageControl localizedStringForKey:@"destination-popular-more"] didSelectedBlock:^{
        [self.tstView showFraternalViewAtIndex:1];
    }];
}


#pragma mark -- TSTView delegate

- (CGFloat)heightForTabInTSTView:(XBTSTView *)tstview {
    return 40;
}

- (CGFloat)heightForSelectedIndicatorInTSTView:(XBTSTView *)tstview {
    return 2;
}

- (CGFloat)heightForTabSeparatorInTSTView:(XBTSTView *)tstview {
    return 0.8;
}

- (UIFont *)fontForTabTitleInTSTView:(XBTSTView *)tstview {
    return [UIFont systemFontOfSize:13];
}

- (UIColor *)highlightColorForTSTView:(XBTSTView *)tstview {
    return [UIColor colorWithHexString:kDefaultColorHex];
}

- (UIColor *)normalColorForTSTView:(XBTSTView *)tstview {
    return [UIColor colorWithHexString:@"#ABABAB"];
}

- (UIColor *)normalColorForShadowViewInTSTView:(XBTSTView *)tstview
{
    return [UIColor colorWithHexString:kDefaultColorHex];
}

- (UIColor *)normalColorForSeparatorInTSTView:(XBTSTView *)tstview
{
    return [UIColor colorWithHexString:@"#EEEEEE"];
}

- (UIColor *)tabViewBackgroundColorForTSTView:(XBTSTView *)tstview {
    return [UIColor clearColor];
}


#pragma mark -- TSTView data source
- (NSInteger)numberOfTabsInTSTView:(XBTSTView *)tstview
{
    return [self.titles count];
}

- (NSString *)tstview:(XBTSTView *)tstview titleForTabAtIndex:(NSInteger)tabIndex
{
    return self.titles[tabIndex];
}

- (UIView *)tstview:(XBTSTView *)tstview viewForSelectedTabIndex:(NSInteger)tabIndex
{
    if (tabIndex == 0) {
        self.hotTableView = [UITableView new];
        self.hotTableView.tag = 0;
        self.hotTableView.dataSource = self;
        self.hotTableView.delegate   = self;
        self.hotTableView.backgroundColor = [UIColor clearColor];
        self.hotTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self.hotTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBDestinationHotCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:destinationCityReuseIdentifier];
        return self.hotTableView;
    }
    
    XBDestinationAllLayout *flowLayout = [[XBDestinationAllLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0.f;
    
    self.allCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.allCollectionView.dataSource = self;
    self.allCollectionView.delegate = self;
    self.allCollectionView.tag = 1;
    self.allCollectionView.backgroundColor = [UIColor clearColor];
    [self.allCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XBDestinationAllCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:destinationAllReuseIdentifier];
    [self.allCollectionView registerClass:[XBDestinationAllHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:destinationAllHeaderReuseIdentifier];
    [self.allCollectionView registerClass:[XBDestinationAllFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:destinationAllFooterReuseIdentifier];
    [self.allCollectionView reloadData];
    return self.allCollectionView;
}

#pragma mark -- UITabelView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.destination.popularDestinations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBDestinationHotCell *cell = [tableView dequeueReusableCellWithIdentifier:destinationCityReuseIdentifier forIndexPath:indexPath];
    
    cell.hotDestination = self.destination.popularDestinations[indexPath.row];
   
    return cell;
}


#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175 * ([XBApplication isPlus] ? 1.2 : 1);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    
    XBHotDestination *hotDestination = self.destination.popularDestinations[indexPath.row];
    
    XBGroupItem *groupItem = [[XBGroupItem alloc] init];
    
    groupItem.name = hotDestination.name;
    
    groupItem.modelId = hotDestination.modelId;
    
    XBDestinationHotCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell.shapeLayer removeFromSuperlayer];
    
    XBCityViewController *cityVC = [[XBCityViewController alloc] init];
    
    cityVC.cityId = [groupItem.modelId integerValue];
    
    cityVC.type = XBCityViewControllerTypeHot;
    
    cityVC.hidesBottomBarWhenPushed = YES;
    
    self.navigationController.delegate = cityVC;
    
    [self.navigationController pushViewController:cityVC animated:YES];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.destination.allCities.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    XBDestinationCities *city = self.destination.allCities[section];
    return city.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBDestinationCities *city = self.destination.allCities[indexPath.section];
    
    XBDestinationItem *item = city.items[indexPath.row];
    
    XBDestinationAllCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:destinationAllReuseIdentifier forIndexPath:indexPath];
   
    cell.titleLabel.text = item.name;
    
    cell.separatorView.hidden = indexPath.row == city.items.count - 1 ;
    
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        XBDestinationCities *city = self.destination.allCities[indexPath.section];
        XBDestinationAllHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:destinationAllHeaderReuseIdentifier forIndexPath:indexPath];
        headerView.titleLabel.text = city.regionName;
        return headerView;
    }
    
    XBDestinationAllFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:destinationAllFooterReuseIdentifier forIndexPath:indexPath];
    
    return footerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){CGRectGetWidth(collectionView.frame),38};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){CGRectGetWidth(collectionView.frame),section == self.destination.allCities.count - 1 ? 50 : 0};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth  = 70.f;
    CGFloat cellHeight = 40.f;
    
    XBDestinationCities *city = self.destination.allCities[indexPath.section];
    
    XBDestinationItem *item = city.items[indexPath.row];
    
    CGFloat width = [item.name sizeWithFont:[UIFont systemFontOfSize:15.f] maxSize:CGSizeMake(CGFLOAT_MAX, 40)].width;
    
    cellWidth += width > 30 ? width - 30 : 0;
    
    return (CGSize){cellWidth,cellHeight};
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBDestinationCities *city = self.destination.allCities[indexPath.section];
   
    XBDestinationItem *item = city.items[indexPath.row];

    XBGroupItem *groupItem = [[XBGroupItem alloc] init];
    
    groupItem.modelId = item.modelId;
   
    groupItem.name = item.name;
    
    XBCityViewController *cityVC = [[XBCityViewController alloc] init];
    
    cityVC.cityId = [groupItem.modelId integerValue];
    
    cityVC.hidesBottomBarWhenPushed = YES;
    
    self.navigationController.delegate = nil;
    
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
