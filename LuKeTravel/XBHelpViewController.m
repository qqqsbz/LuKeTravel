
//
//  XBHelpViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/29.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHelpViewController.h"
#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <NJKWebViewProgress/NJKWebViewProgressView.h>

@interface XBHelpViewController () <UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (strong, nonatomic) UIWebView              *webView;
@property (strong, nonatomic) NJKWebViewProgress     *progressProxy;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@end

@implementation XBHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = [XBLanguageControl localizedStringForKey:@"help-title"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.progressView removeFromSuperview];
}

- (void)buildView
{
    
    self.webView = [UIWebView new];
    [self.view addSubview:self.webView];
    
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, self.navigationController.navigationBar.xb_height - progressBarHeight, self.self.navigationController.navigationBar.xb_width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.progressView.progressBarView.backgroundColor = [UIColor colorWithHexString:kDefaultColorHex];
    
    [self.navigationController.navigationBar addSubview:self.progressView];
    
}

- (void)reloadData
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kHelp,[XBUserDefaultsUtil currentLanguage]]]]];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark -- NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
