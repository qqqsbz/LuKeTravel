//
//  XBAppRootViewController.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBAppRootViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface XBAppRootViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager  *locationManager;
@end

@implementation XBAppRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildTabBarItemImage];
    
    if (![XBUserDefaultsUtil currentLongitude]) {
        [self updateLocation];
    }
}


- (void)buildTabBarItemImage
{
    NSString *imageName ;
    NSString *imageSelName ;
    NSArray *childers = self.childViewControllers;
    for (int i = 0 ; i < [childers count]; i++) {
        
        if (i == 0) {
            
            imageName = @"tab_explore";
            
            imageSelName = @"tab_explore_selected";
            
        } else if (i == 1) {
            
            imageName = @"tab_dest";
            
            imageSelName = @"tab_dest_selected";
            
        } else if (i == 2) {
            
            imageName = @"tab_search";
            
            imageSelName = @"tab_search_selected";
            
        } else if (i == 3) {
            
            imageName = @"tab_mine";
            
            imageSelName = @"tab_mine_selected";
            
        }
        
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImage *imageSel = [UIImage imageNamed:imageSelName];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        imageSel = [imageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UINavigationController *navigationController = self.childViewControllers[i];
        
        navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:image selectedImage:imageSel];
        
        [navigationController.tabBarItem setImageInsets:UIEdgeInsetsMake(7, 0, -7, 0)];
        
    }
}

//获取所在位置
- (void)updateLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
        //_locationManager.distanceFilter = 100; //控制定位服务更新频率。单位是“米”
        [self.locationManager startUpdatingLocation];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [self.locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    item.title = @"";
}

#pragma mark -- CLLocation manager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currLocation = [locations lastObject];
    [XBUserDefaultsUtil updateCurrentLatitude:currLocation.coordinate.latitude];
    [XBUserDefaultsUtil updateCurrentLongitude:currLocation.coordinate.longitude];
    [manager stopUpdatingLocation];
    DDLogDebug(@"location success!!");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager startUpdatingLocation];
    DDLogCDebug(@"error:%@",error);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
