//
//  XBPromotionsViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPromotionsViewController.h"
#import "XBCoupon.h"
#import "XBCoupons.h"
#import "XBTSTView.h"
#import "XBCreditsCash.h"
#import "NSString+Util.h"
#import "XBCouponsCell.h"
#import "XBCouponHeaderView.h"
#import "XBCreditsHeaderView.h"
@interface XBPromotionsViewController () <TSTViewDelegate,TSTViewDataSource,UITableViewDelegate,UITableViewDataSource>
/** 多页view */
@property (strong, nonatomic) XBTSTView           *tstView;
/** 优惠券TableView */
@property (strong, nonatomic) UITableView         *couponsTableView;
/** 优惠券TableView headerView */
@property (strong, nonatomic) XBCouponHeaderView  *couponHeaderView;
/** 积分TableView headerView */
@property (strong, nonatomic) XBCreditsHeaderView *creditsHeaderView;
/** 积分TableView */
@property (strong, nonatomic) UITableView         *creditsTableView;
/** 标题 */
@property (strong, nonatomic) NSArray<NSString *> *titles;
/** 优惠券 */
@property (strong, nonatomic) XBCoupon *coupon;
/** 积分 */
@property (strong, nonatomic) XBCreditsCash *creditsCash;
@end

static NSString *const kCouponsReuseIdentifier = @"XBCouponsCell";
@implementation XBPromotionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self buildView];
    
    [self reloadConpon];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadConpon) name:kUserLoginSuccessNotificaton object:nil];
}

- (void)reloadConpon
{
    if (self.coupon) return;
    
    [self showLoadinngInView:self.view];
    
    [[XBHttpClient shareInstance] getCouponsWithSuccess:^(XBCoupon *coupon) {
        
        self.coupon = coupon;
        
        self.couponHeaderView.available = coupon.validCouponCounts;
        
        self.couponHeaderView.unavailable = coupon.usedCouponCounts;
        
        [self.couponsTableView reloadData];
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
    }];
}

- (void)reloadCreditsCash
{
    
    [self showLoadinngInView:self.view];
    
    [[XBHttpClient shareInstance] getTotalCreditsCashWithSuccess:^(XBCreditsCash *creditsCash) {
    
        [self hideLoading];
        
        self.creditsCash = creditsCash;
        
        self.creditsHeaderView.amount = creditsCash.amount;
        
        self.creditsHeaderView.cash = creditsCash.credit;
        
        [self.creditsTableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
    }];
}

- (void)buildView
{
    
    self.title = [XBLanguageControl localizedStringForKey:@"promotions-title"];
    
    self.titles = @[[XBLanguageControl localizedStringForKey:@"promotions-coupons"],
                    [XBLanguageControl localizedStringForKey:@"promotions-credits"]
                    ];
    
    self.couponHeaderView = [[XBCouponHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100.f) exchangeBlock:^(NSString *code) {
        
        code = [code clearBlack];
        
        if (code.length > 0) {
            
            [self showLoadinngInView:self.view];
            
            [[XBHttpClient shareInstance] postCouponsWithCouponCode:code success:^(XBCoupon *coupon) {
            
                self.coupon = coupon;
                
                self.couponHeaderView.available = coupon.validCouponCounts;
                
                self.couponHeaderView.unavailable = coupon.usedCouponCounts;
                
                [self.couponsTableView reloadData];
                
                [self hideLoading];
                
            } failure:^(NSError *error) {
                
                [self hideLoading];
                
                NSString *errorMsg = [error.userInfo valueForKey:kErrorMessage];
                
                errorMsg = errorMsg.length > 0 ? errorMsg : [XBLanguageControl localizedStringForKey:@"loading-fail"];
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:errorMsg message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:[XBLanguageControl localizedStringForKey:@"user-info-logout-confirm"], nil];
                
                [alertView show];
                
            }];
        }
        
    }];
    
    self.couponHeaderView.code = self.couponCode;
    
    
    self.creditsHeaderView = [[XBCreditsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.xb_width, 55.f)];
    
    self.tstView = [[XBTSTView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
    self.tstView.delegate = self;
    self.tstView.dataSource = self;
    self.tstView.shadowTitleEqualWidth = YES;
    self.tstView.onePageOfItemCount    = 2;
    self.tstView.zeroMargin = YES;
    self.tstView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.tstView reloadData];
    [self.view addSubview:self.tstView];
    
}

#pragma mark -- TSTView delegate

- (CGFloat)heightForTabInTSTView:(XBTSTView *)tstview {
    return 60;
}

- (CGFloat)heightForSelectedIndicatorInTSTView:(XBTSTView *)tstview {
    return 2;
}

- (CGFloat)heightForTabSeparatorInTSTView:(XBTSTView *)tstview {
    return 1;
}

- (UIFont *)fontForNormalTabTitleInTSTView:(XBTSTView *)tstview {
    return [UIFont systemFontOfSize:16];
}

- (UIFont *)fontForSelectedTabTitleInTSTView:(XBTSTView *)tstview
{
    return [UIFont systemFontOfSize:16.f];
}

- (UIColor *)highlightColorForTSTView:(XBTSTView *)tstview {
    return [UIColor colorWithHexString:kDefaultColorHex];
}

- (UIColor *)normalColorForTSTView:(XBTSTView *)tstview {
    return [UIColor colorWithHexString:@"#757575"];
}

- (UIColor *)normalColorForShadowViewInTSTView:(XBTSTView *)tstview
{
    return [UIColor colorWithHexString:kDefaultColorHex];
}

- (UIColor *)normalColorForSeparatorInTSTView:(XBTSTView *)tstview
{
    return [UIColor colorWithHexString:@"#BCBAC1"];
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
        self.couponsTableView = [UITableView new];
        self.couponsTableView.tag = 0;
        self.couponsTableView.dataSource = self;
        self.couponsTableView.delegate   = self;
        self.couponsTableView.tableHeaderView = self.couponHeaderView;
        self.couponsTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        self.couponsTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self.couponsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBCouponsCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCouponsReuseIdentifier];
        return self.couponsTableView;
    }
    
    self.creditsTableView = [UITableView new];
    self.creditsTableView.tag = 1;
    self.creditsTableView.dataSource = self;
    self.creditsTableView.delegate   = self;
    self.creditsTableView.tableHeaderView = self.creditsHeaderView;
    self.creditsTableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.creditsTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.creditsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBCouponsCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCouponsReuseIdentifier];
    [self reloadCreditsCash];
    return self.creditsTableView;
}


#pragma mark -- UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag == 0 ? self.coupon.coupons.count : self.creditsCash.credits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCouponsReuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.coupos = self.coupon.coupons[indexPath.row];
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == 0 ? 135.f : 0;
}


- (void)showError:(NSError *)error
{
    
    [self hideLoading];
    
    //用户未登陆
    if (error.code == kUserUnLoginCode) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserUnLoginNotification object:nil];
        
    } else {
        
        [self showFail:[XBLanguageControl localizedStringForKey:@"loading-fail"]];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
