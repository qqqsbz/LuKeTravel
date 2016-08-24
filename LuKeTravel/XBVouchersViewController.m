//
//  XBVouchersViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBVouchersViewController.h"
#import "XBNoDataView.h"
#import "XBVoucher.h"
@interface XBVouchersViewController ()
/** 没有数据显示的界面 */
@property (strong, nonatomic) XBNoDataView *noDataView;
/** 显示数据 */
@property (strong, nonatomic) UITableView  *tableView;
/** 当前页 */
@property (assign, nonatomic) NSInteger  page;
@end

@implementation XBVouchersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    [self buildView];
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kUserLoginSuccessNotificaton object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.noDataView.text = [XBLanguageControl localizedStringForKey:@"vouchers-nodata-message"];
    
    self.noDataView.image = [UIImage imageNamed:@"mine_voucher"];
    
    self.title = [XBLanguageControl localizedStringForKey:@"vouchers-title"];
}

- (void)reloadData
{
    
    [self showLoadinngInView:self.view];
    
    [[XBHttpClient shareInstance] getVouchersWithPage:self.page success:^(XBVoucher *voucher) {
        
        if (voucher.vouchers.count > 0) {
            
            [self.view bringSubviewToFront:self.tableView];
        
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
    self.noDataView = [XBNoDataView new];
    self.noDataView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.view addSubview:self.noDataView];
    
    self.tableView = [UITableView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.noDataView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
