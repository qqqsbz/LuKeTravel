//
//  XBWebViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/27.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBWebViewController.h"
#import "XBWebView.h"
@interface XBWebViewController () <XBWebViewDelegate>
@property (strong, nonatomic) XBWebView  *webView;
@end

@implementation XBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:1];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:0];
}

- (void)buildView
{
    self.webView = [[XBWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) targetViewController:self];
    self.webView.delegate = self;
    self.webView.url = self.webUrl;
    [self.view addSubview:self.webView];
}

#pragma mark -- XBWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
