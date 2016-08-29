//
//  XBMoreActivityViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//
//#define kNavigationBarHeight 124
#define kNavigationBarHeight 64
#define kCalendarViewHeight  60
#define kSubNameHeight       50
#define kAnimationDuration   0.35

#import "XBMoreActivityViewController.h"
#import "XBLevelOne.h"
#import "XBSearchItem.h"
#import "XBSubNameView.h"
#import "XBCalendarView.h"
#import "XBMoreActivity.h"
#import "XBNoActivityView.h"
#import "XBMoreActivitySort.h"
#import "XBActivityViewController.h"
#import "XBMoreActivitySubNameItem.h"
#import "XBMoreActivityNavigationBar.h"
#import "XBHomeSearchActivityClickCell.h"
@interface XBMoreActivityViewController () <XBCalendarViewDelegate,XBMoreActivitySubNameDelegate,XBMoreActivityNavigationBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (assign, nonatomic) NSInteger  sortType;
@property (assign, nonatomic) NSInteger  subNameId;
@property (assign, nonatomic) NSInteger  nameId;
@property (strong, nonatomic) NSString   *selectedTime;
@property (assign, nonatomic) NSInteger  cityId;
@property (strong, nonatomic) XBCalendarView  *calendarView;
@property (strong, nonatomic) XBMoreActivity  *moreActivity;
@property (strong, nonatomic) XBSubNameView   *subNameView;
@property (strong, nonatomic) UITableView     *tableView;
@property (assign, nonatomic) CGFloat         previousOffsetY;
@property (strong, nonatomic) XBNoActivityView  *noActivityView;
@property (strong, nonatomic) XBMoreActivityNavigationBar *navigationBar;
@end

static NSString *const reuseIdentifier = @"XBHomeSearchActivityClickCell";
@implementation XBMoreActivityViewController

- (instancetype)initWithCityId:(NSInteger)cityId
{
    if (self = [super init]) {
        _cityId = cityId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.view bringSubviewToFront:self.navigationBar];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)reloadData
{
    [self showLoadinngInView:self.view];
    [[XBHttpClient shareInstance] getMoreActivityWithCityId:self.cityId sortType:self.sortType nameId:self.nameId subNameId:self.subNameId selectedTime:self.selectedTime success:^(XBMoreActivity *moreActivity) {
        
        self.moreActivity = moreActivity;
        
        self.navigationBar.name = moreActivity.name;
        
        self.navigationBar.hideTitle = NO;
        
        self.navigationBar.sortEnable = YES;
        
        [self.navigationBar reloadData];
        
        self.subNameView.subName = moreActivity.subName;
        
        [self.tableView reloadData];
        
        [self hideLoading];
        
        if (moreActivity.subName) {
            
            [self.subNameView updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kSubNameHeight);
            }];
            
        } else {
            
            [self.subNameView updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
        
        if (self.moreActivity.items.count <= 0) {
        
            self.noActivityView.hidden = NO;
            
            [self.view bringSubviewToFront:self.noActivityView];
        
        } else {
            
            self.noActivityView.hidden = YES;
            
            [self.view sendSubviewToBack:self.noActivityView];
        
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        DDLogDebug(@"error:%@",error);
        
    }];
}

- (void)buildView
{
    //初始化值
    self.sortType  = 1;
    self.nameId    = -1;
    self.subNameId = -1;
    self.selectedTime = @"";
    
    self.navigationBar = [[XBMoreActivityNavigationBar alloc] initWithTargetViewController:self];
    self.navigationBar.hideTitle = YES;
    self.navigationBar.delegate = self;
    self.navigationBar.sortEnable = NO;
    [self.view addSubview:self.navigationBar];
    
    self.calendarView = [XBCalendarView new];
    self.calendarView.delegate = self;
    [self.calendarView reloadData];
    [self.view addSubview:self.calendarView];
    
    self.subNameView = [XBSubNameView new];
    self.subNameView.delegate = self;
    [self.view addSubview:self.subNameView];
    
    self.noActivityView = [XBNoActivityView new];
    self.noActivityView.hidden = YES;
    self.noActivityView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.noActivityView];
    
    self.tableView = [UITableView new];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBHomeSearchActivityClickCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
    
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    
    [self.calendarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.navigationBar.bottom);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kCalendarViewHeight);
    }];
    
    [self.subNameView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.calendarView.bottom);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.subNameView.bottom);
        make.bottom.equalTo(self.view);
    }];
    
    [self.noActivityView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.subNameView.bottom);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moreActivity.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBHomeSearchActivityClickCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.searchItem = self.moreActivity.items[indexPath.row];
    
    return cell;
}

#pragma mark -- UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBSearchItem *searchItem = self.moreActivity.items[indexPath.row];
    
    XBActivityViewController *activityVC = [XBActivityViewController new];
    
    activityVC.activityId = [searchItem.modelId integerValue];
    
    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:0];
    
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark -- XBNavigationBarDelegate
- (void)navigationBar:(XBMoreActivityNavigationBar *)navigationBar didSelectedWithLevelOne:(XBLevelOne *)levelOne
{
    self.nameId = [levelOne.type integerValue];
    
    [self reloadData];
}

- (void)navigationBar:(XBMoreActivityNavigationBar *)navigationBar didSelectedWithMoreActivitySort:(XBMoreActivitySort *)sort
{
    self.sortType = sort.type;
    
    [self reloadData];
}

#pragma mark -- XBCalendarViewDelegate
- (void)calendarView:(XBCalendarView *)calendarView didSelectedWithDateString:(NSString *)dateString
{
    self.selectedTime = dateString;
    
    [self reloadData];
}

#pragma mark -- XBMoreActivitySubNameDelegate
- (void)subNameView:(XBSubNameView *)subNameView didSelectedWithSubNameItem:(XBMoreActivitySubNameItem *)item
{
    self.subNameId = [item.modelId integerValue];
    
    [self reloadData];
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY  = scrollView.contentOffset.y;
    
    if (offsetY > 0) {
        if (offsetY > self.previousOffsetY) {
            
            if (CGRectGetMinY(self.calendarView.frame) == kNavigationBarHeight) {
                [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    self.calendarView.xb_y -= kNavigationBarHeight;
            
                    self.subNameView.xb_y -= kNavigationBarHeight;
                    
                    self.tableView.xb_y -= kNavigationBarHeight;
                    
                    self.tableView.xb_height += kNavigationBarHeight;
                    
                } completion:nil];
            }
            
        } else {
            
            if (CGRectGetMinY(self.calendarView.frame) == 0) {
                [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    self.calendarView.xb_y += kNavigationBarHeight;
                    
                    self.subNameView.xb_y += kNavigationBarHeight;
                    
                    self.tableView.xb_y += kNavigationBarHeight;
                    
                    self.tableView.xb_height -= kNavigationBarHeight;
                    
                } completion:nil];
            }
        }
    }
    
//    DDLogDebug(@"frame :%@  offsetX: %f  previousOffsetX:%f",NSStringFromCGRect(self.tableView.frame),offsetY,self.previousOffsetY);
    
    self.previousOffsetY = offsetY;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
