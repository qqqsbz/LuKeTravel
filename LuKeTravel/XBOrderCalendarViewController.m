//
//  XBBookOrderViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBBookOrderViewController.h"
#import "XBPackage.h"
#import "XBOrderCalendarView.h"
@interface XBBookOrderViewController () <XBOrderCalendarViewDelegate>
/** 日历 */
@property (strong, nonatomic) XBOrderCalendarView *calendarView;
@end

@implementation XBBookOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self buildView];
}

- (void)reloadArrangements
{
    [self showLoadinng];
 
    [[XBHttpClient shareInstance] getArrangementsWithPackageId:[self.package.modelId integerValue] success:^(NSArray<XBArrangement *> *arrangements) {
        
        self.calendarView.arrangements = arrangements;
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
    }];
}

- (void)buildView
{
    self.title = [XBLanguageControl localizedStringForKey:@"activity-order-chosedate"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.calendarView = [XBOrderCalendarView new];
    self.calendarView.delegate = self;
    [self.view addSubview:self.calendarView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.calendarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
}

#pragma mark -- XBOrderCalendarViewDelegate
- (void)orderCalendarView:(XBOrderCalendarView *)orderCalendarView didSelectOrderWithArrangement:(XBArrangement *)arrangement
{

    DDLogDebug(@"下单 :%@",arrangement);
}

- (void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
