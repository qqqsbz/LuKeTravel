//
//  XBBasicViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//
#import "XBBasicViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
@interface XBBasicViewController ()
@end

@implementation XBBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    
    [self buildNavigationBarView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view bringSubviewToFront:self.navigationView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)buildNavigationBarView
{
    self.navigationView = [UIView new];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationView];
    
    self.navigationSeparatorView = [UIView new];
    self.navigationSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#E0DFDD"];
    [self.navigationView addSubview:self.navigationSeparatorView];
    
    self.navigationLeftButton = [UIButton new];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.navigationLeftButton];
    
    self.navigationRightButton = [UIButton new];
    [self.navigationRightButton setImage:[UIImage imageNamed:@"activity_share_icon"] forState:UIControlStateNormal];
    [self.navigationRightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.navigationRightButton];
    
    self.navigationtTitleLabel = [UILabel new];
    self.navigationtTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationtTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.navigationtTitleLabel.font = [UIFont systemFontOfSize:16.5f];
    self.navigationtTitleLabel.textColor = [UIColor colorWithHexString:@"#696969"];
    [self.navigationView addSubview:self.navigationtTitleLabel];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.navigationView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64.f);
    }];
    
    [self.navigationSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView);
        make.right.equalTo(self.navigationView);
        make.bottom.equalTo(self.navigationView);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.navigationLeftButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView).offset(kSpace);
        make.centerY.equalTo(self.navigationView).offset(kSpace * 1.1);
    }];
    
    [self.navigationRightButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigationLeftButton);
        make.right.equalTo(self.navigationView).offset(-kSpace * 1.5);
    }];
    
    [self.navigationRightButton layoutIfNeeded];
    
    [self.navigationLeftButton layoutIfNeeded];
    
    [self.navigationtTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigationLeftButton);
        make.left.equalTo(self.navigationView).offset(CGRectGetWidth(self.navigationLeftButton.frame) + kSpace);
        make.right.equalTo(self.navigationView).offset(-(CGRectGetWidth(self.navigationRightButton.frame) + kSpace));
    }];
}

- (void)leftButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
