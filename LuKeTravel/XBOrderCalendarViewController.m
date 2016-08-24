//
//  XBBookOrderViewController.m
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderCalendarViewController.h"
#import "XBPackage.h"
#import "XBOrderCalendarView.h"
#import "XBBookOrderViewController.h"
#import "XBWeChatLoginViewController.h"
@interface XBOrderCalendarViewController () <XBOrderCalendarViewDelegate>
/** 日历 */
@property (strong, nonatomic) XBOrderCalendarView *calendarView;
@end

@implementation XBOrderCalendarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self buildView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadArrangements) name:kUserLoginSuccessNotificaton object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentToLoginViewController) name:kUserUnLoginNotification object:nil];
}

- (void)reloadArrangements
{
    [self showLoadinng];
 
    [[XBHttpClient shareInstance] getArrangementsWithPackageId:[self.package.modelId integerValue] success:^(NSArray<XBArrangement *> *arrangements) {
        
        self.calendarView.arrangements = arrangements;
        
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

    XBBookOrderViewController *bookOrderVC = [[XBBookOrderViewController alloc] init];
    
    bookOrderVC.arrangement = arrangement;
    
    [self.navigationController pushViewController:bookOrderVC animated:YES];
}

- (void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 用户未登陆 跳转到登陆界面 */
- (void)presentToLoginViewController
{
    XBWeChatLoginViewController *loginViewController = [[XBWeChatLoginViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    navigationController.navigationBarHidden = YES;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
