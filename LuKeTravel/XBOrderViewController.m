//
//  XBOrderViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/27.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderViewController.h"
#import "XBLoginTipView.h"
#import "XBNoDataView.h"
#import "XBWeChatLoginViewController.h"
@interface XBOrderViewController ()
/** 未登录时登录提醒  */
@property (strong, nonatomic) XBLoginTipView    *loginView;
/** 没有数据时显示 */
@property (strong, nonatomic) XBNoDataView      *noOrderView;
@end

@implementation XBOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kUserLoginSuccessNotificaton object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.loginView reloadLanguageConfig];
    
    self.noOrderView.text = [XBLanguageControl localizedStringForKey:@"order-noorder"];
    
    [self checkUserIfLogin];
}

- (void)buildView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    
    self.loginView = [[XBLoginTipView alloc] initWithLoginBlock:^{
        
        
        XBWeChatLoginViewController *loginViewController = [[XBWeChatLoginViewController alloc] init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        
        navigationController.navigationBarHidden = YES;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }];
    self.loginView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.loginView];
    
    self.noOrderView = [XBNoDataView new];
    self.noOrderView.image = [UIImage imageNamed:@"order_mask"];
    self.noOrderView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.noOrderView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.loginView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.noOrderView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)loginSuccess:(NSNotification *)notification
{
    if (notification.object) {
        //显示数据
        [self checkUserIfLogin];
    }
}

- (void)checkUserIfLogin
{
    //已登录
    if ([XBUserDefaultsUtil userInfo]) {
        
        self.title = [XBLanguageControl localizedStringForKey:@"order-title"];
        
        self.navigationController.navigationBarHidden = NO;
        
        [self.view bringSubviewToFront:self.noOrderView];
        
    } else {
        
        self.navigationController.navigationBarHidden = YES;
        
        [self.view bringSubviewToFront:self.loginView];
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
