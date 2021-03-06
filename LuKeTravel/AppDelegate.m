//
//  AppDelegate.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import <DDTTYLogger.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworkReachabilityManager.h>
#import <SDImageCache.h>
#import "AppDelegate+LaunchScreen.h"
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:kDefaultColorHex]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithHexString:@"#4F4F4F"], NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:17.5f], NSFontAttributeName, nil]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateSelected];
    
    [self setLanguage];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DDLogDebug(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    [reachability startMonitoring];
    
    [UMSocialData setAppKey:kUmengAppkey];
    
    //微信
    [UMSocialWechatHandler setWXAppId:@"wx67d852f153fb2dfb" appSecret:@"ba8021608afc841d767c7eff5d12cd15" url:@"http://www.umeng.com/social"];
    
    //新浪微博的SSO
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"61509799"
                                              secret:@"bd08f4f0a1988d317cdc45f889593eb6"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [self startLaunchScreen];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

/** 设置语言环境 */
- (void)setLanguage {
    
    //如果没有设置过语言
    if (![XBUserDefaultsUtil currentLanguage]) {
        
        NSString *systemLanguage = [[NSLocale preferredLanguages] firstObject];

        NSString *currentLanguage = @"";
        
        NSString *currentCurrency = @"";
        
        NSString *currentSymbol = @"";
        
        if ([systemLanguage isEqualToString:@"zh-Hans-CN"]) {
            
            currentLanguage = kLanguageZHCN;
            
            currentCurrency = @"CNY";
            
            currentSymbol = @"￥";
            
        } else if ([systemLanguage isEqualToString:@"zh-Hant-CN"]) {
            
            currentLanguage = kLanguageTW;
            
            currentCurrency = @"TWD";
            
            currentSymbol = @"NT$";
            
        } else if ([systemLanguage isEqualToString:@"en-CN"]) {
            
            currentLanguage = kLanguageENUS;
            
            currentCurrency = @"USD";
            
            currentSymbol = @"$";
        }
        
        
        [XBUserDefaultsUtil updateCurrentLanguage:currentLanguage];
        
        [XBUserDefaultsUtil updateCurrentCurrency:currentCurrency];
        
        [XBUserDefaultsUtil updateCurrentCurrencySymbol:currentSymbol];
    }

    
}

@end
