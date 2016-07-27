//
//  XBWebToolBar.m
//  LuKeTravel
//
//  Created by coder on 16/7/27.
//  Copyright © 2016年 coder. All rights reserved.
//
#define  kSpace 10.f
#import "XBWebView.h"
#import "UIImage+Util.h"
@interface XBWebView() <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIView    *toolBarView;
@property (strong, nonatomic) UIButton  *refreshButton;
@property (strong, nonatomic) UIButton  *backButton;
@property (strong, nonatomic) UIButton  *forwardButton;
@property (strong, nonatomic) UIButton  *shareButton;
@property (strong, nonatomic) UIView    *separatorView;
@property (strong, nonatomic) UIImage   *refreshNormalImage;
@property (strong, nonatomic) UIImage   *refreshHighlightImage;
@property (strong, nonatomic) UIImage   *backNormalImage;
@property (strong, nonatomic) UIImage   *backHighlightImage;
@property (strong, nonatomic) UIImage   *forwardNormalImage;
@property (strong, nonatomic) UIImage   *forwardHighlightImage;

/** 分享控件*/
@property (strong, nonatomic) UIActivityViewController  *activityViewController;
/** 目标控制器 */
@property (strong, nonatomic) UIViewController  *targetViewController;

@end
@implementation XBWebView

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController
{
    if (self = [super init]) {
        _targetViewController = targetViewController;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame targetViewController:(UIViewController *)targetViewController
{
    if (self = [super initWithFrame:frame]) {
        _targetViewController = targetViewController;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    UIColor *defaultColor = [UIColor colorWithHexString:kDefaultColorHex];
    
    self.refreshNormalImage = [UIImage imageNamed:@"cancel"];
    
    self.refreshHighlightImage = [[UIImage imageNamed:@"refresh" ] imageContentWithColor:defaultColor];
    
    self.backNormalImage = [UIImage imageNamed:@"backcardit"];
    
    self.backHighlightImage = [[UIImage imageNamed:@"backcardit"] imageContentWithColor:defaultColor];
    
    self.forwardNormalImage = [UIImage image:self.backNormalImage  rotation:UIImageOrientationDown];
    
    self.forwardHighlightImage = [UIImage image:self.backHighlightImage  rotation:UIImageOrientationDown];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.webView = [UIWebView new];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self addSubview:self.webView];
    
    self.toolBarView = [UIView new];
    self.toolBarView.backgroundColor = [UIColor colorWithHexString:@"#DFDFDF"];
    [self addSubview:self.toolBarView];
    
    self.separatorView = [UIView new];
    self.separatorView.hidden = YES;
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#CDCDCD"];
    [self addSubview:self.separatorView];
    
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.refreshButton setImage:[self.refreshHighlightImage imageContentWithColor:defaultColor] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.refreshButton];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:self.backNormalImage forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forwardButton setImage:self.forwardNormalImage forState:UIControlStateNormal];
    [self.forwardButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.forwardButton];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.enabled = NO;
    [self.shareButton setImage:[UIImage imageNamed:@"activity_share_icon"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.shareButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [self.toolBarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.webView.bottom);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(45.f);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolBarView);
        make.right.equalTo(self.toolBarView);
        make.top.equalTo(self.toolBarView);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.refreshButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolBarView);
        make.left.equalTo(self.toolBarView).offset(kSpace * 2);
    }];
    
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolBarView);
        make.right.equalTo(self.toolBarView.centerX).offset(-kSpace * 3.);
    }];
    
    [self.forwardButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolBarView);
        make.left.equalTo(self.toolBarView.centerX).offset(kSpace * 3.);
    }];
    
    [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolBarView);
        make.right.equalTo(self.toolBarView).offset(-kSpace * 2);
    }];
    
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.shareButton.enabled = NO;
    
    [self.refreshButton setImage:self.refreshNormalImage forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.shareButton.enabled = YES;
    
    [self.refreshButton setImage:self.refreshHighlightImage forState:UIControlStateNormal];
    
    [self.backButton setImage:webView.canGoBack ? self.backHighlightImage : self.backNormalImage forState:UIControlStateNormal];
    
    [self.forwardButton setImage:webView.canGoForward ? self.forwardHighlightImage : self.forwardNormalImage forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.shareButton.enabled = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

- (void)clickAction:(UIButton *)sender
{
    
    if (sender == self.refreshButton) {
        
        [self.webView reload];
        
    } else if (sender == self.backButton) {
        
        [self.webView goBack];
        
    } else if (sender == self.forwardButton) {
        
        [self.webView goForward];
        
    } else if (sender == self.shareButton) {
        
        [self.targetViewController presentViewController:self.activityViewController animated:YES completion:nil];
        
    }
    
}

- (UIActivityViewController *)activityViewController
{
    if (!_activityViewController) {
        
        _activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.url.absoluteString] applicationActivities:nil];
        
    }
    
    return _activityViewController;
}

@end
