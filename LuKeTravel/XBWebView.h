//
//  XBWebToolBar.h
//  LuKeTravel
//
//  Created by coder on 16/7/27.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XBWebViewDelegate <NSObject>

@optional
- (void)webViewDidStartLoad:(UIWebView *)webView;

- (void)webViewDidFinishLoad:(UIWebView *)webView;

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface XBWebView : UIView
/** 网址 */
@property (strong, nonatomic) NSURL  *url;

/** 代理 */
@property (weak, nonatomic) id<XBWebViewDelegate> delegate;

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController;

- (instancetype)initWithFrame:(CGRect)frame targetViewController:(UIViewController *)targetViewController;

@end
