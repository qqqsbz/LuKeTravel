
//
//  AppDelegate+LaunchScreen.m
//  LuKeTravel
//
//  Created by coder on 16/8/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "AppDelegate+LaunchScreen.h"
#import "XBAppRootViewController.h"
#import "XBLaunchScreenViewController.h"
@interface AppDelegate()
@end
@implementation AppDelegate (LaunchScreen)

- (void)startLaunchScreen
{
    [self buildView];
}

- (void)buildView
{
    XBLaunchScreenViewController *launchScreenVC = [[XBLaunchScreenViewController alloc] init];
    
    self.window.rootViewController = launchScreenVC;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:launchScreenVC.view.bounds];
    
    imageView.image = [self loadLunchImage];
    
    [launchScreenVC.view addSubview:imageView];
    
    [launchScreenVC startIndicatorView];
    
    [self reloadConfig:launchScreenVC];
}

/** 加载配置信息 */
- (void)reloadConfig:(XBLaunchScreenViewController *)targetVC
{
    [[XBHttpClient shareInstance] getConfigWithSuccess:^(XBConfig *config) {
        
        [self showGuide:targetVC];
        
    } failure:^(NSError *error) {
        
        [self showGuide:targetVC];
        
    }];
}

/** 当第一次启动则显示引导页 否则直接进入主控制器 */
- (void)showGuide:(XBLaunchScreenViewController *)targetVC
{
    if (![XBUserDefaultsUtil alreadyFirstStart]) {
        
        [targetVC showGuideViewWithComplete:^{
            
            [self setRootController];
        }];
        
        [XBUserDefaultsUtil updateAlreadyFirstStart:YES];
    
    } else {
        
        [self setRootController];
    }
    
}

/** 设置主控制器 */
- (void)setRootController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    XBAppRootViewController *appRootVC = [storyboard instantiateInitialViewController];
    
    self.window.rootViewController = appRootVC;
}

/** 获取LunchImage */
- (UIImage *)loadLunchImage
{
    CGSize viewSize = self.window.bounds.size;
    
    NSString *viewOrientation = @"Portrait";
    
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    return [UIImage imageNamed:launchImage];
}

@end
