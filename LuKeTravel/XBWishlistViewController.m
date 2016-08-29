//
//  XBWishlistViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBWishlistViewController.h"
#import "XBNoDataView.h"
#import "XBWishlist.h"
#import "XBSearchItem.h"
#import "XBActivityViewController.h"
#import "XBHomeSearchActivityClickCell.h"
@interface XBWishlistViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate,XBHomeSearchActivityClickCellDelegate>
/** 没有数据显示的界面 */
@property (strong, nonatomic) XBNoDataView *noDataView;
/** 数据列表 */
@property (strong, nonatomic) UITableView  *tableView;
/** 数据集合 */
@property (strong, nonatomic) NSArray<XBWishlist *> *datas;
@end

static NSString *const reuseIdentifier = @"XBHomeSearchActivityClickCell";
@implementation XBWishlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kUserLoginSuccessNotificaton object:nil];
}

- (void)reloadData
{
    [self showLoadinngInView:self.view];
    
    [[XBHttpClient shareInstance] getWishesWithSuccess:^(NSArray<XBWishlist *> *wishlists) {
        
        if (wishlists.count > 0) {
            
            [self.view bringSubviewToFront:self.tableView];
            
            self.datas = wishlists;
            
            [self.tableView reloadData];
            
        } else {
            
            [self.view bringSubviewToFront:self.noDataView];
        }
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        if (error.code == kUserUnLoginCode) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserUnLoginNotification object:nil];
            
        } else {
            
            [self showNoSignalAlert];
        }

    }];
}

- (void)buildView
{
    self.title = [XBLanguageControl localizedStringForKey:@"wishlist-title"];
    
    self.noDataView = [XBNoDataView new];
    self.noDataView.image = [UIImage imageNamed:@"wish_mask"];
    self.noDataView.text  = [XBLanguageControl localizedStringForKey:@"wishlist-nodata-message"];
    self.noDataView.backgroundColor = [UIColor colorWithHexString:@"#E0E1E2"];
    [self.view addSubview:self.noDataView];
    
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F8"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeSearchActivityClickCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews
{
    [self.noDataView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBHomeSearchActivityClickCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    XBWishlist *wishlist = self.datas[indexPath.row];
    
    cell.searchItem = [XBSearchItem searchItemFromWishlist:wishlist];
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBWishlist *wishlist = self.datas[indexPath.row];
    
    XBActivityViewController *activityVC = [XBActivityViewController new];
    
    activityVC.activityId = [wishlist.modelId integerValue];
    
    //设置导航栏透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    [self.navigationController pushViewController:activityVC animated:YES];
    
}


#pragma mark -- XBHomeSearchActivityClickCellDelegate
- (void)searchActivityClickCell:(XBHomeSearchActivityClickCell *)searchActivityClickCell didSelectFavorite:(XBSearchItem *)searchItem
{
    NSInteger activityId = [searchItem.modelId integerValue];
    
    if (searchItem.favorite) {
        
        [self cancelFavoriteWishlistWithSearchActivityClickCell:searchActivityClickCell acticityId:activityId];
        
    } else {
        
        [self favoriteWishlistWithSearchActivityClickCell:searchActivityClickCell activityId:activityId];
        
    }
}

/** 收藏愿望清单 */
- (void)favoriteWishlistWithSearchActivityClickCell:(XBHomeSearchActivityClickCell *)cell activityId:(NSInteger)activityId
{
    [[XBHttpClient shareInstance] postWisheWithActivityId:activityId success:^(BOOL success) {
        
        cell.favorite = YES;
        
    } failure:^(NSError *error) {
        
    }];
}

/** 取消收藏愿望清单 */
- (void)cancelFavoriteWishlistWithSearchActivityClickCell:(XBHomeSearchActivityClickCell *)cell acticityId:(NSInteger)activityId
{
    [[XBHttpClient shareInstance] deleteWisheWithActivityId:activityId success:^(BOOL success) {
        
        cell.favorite = NO;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
