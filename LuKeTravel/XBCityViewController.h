//
//  XBDesinationViewController.h
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBGroupItem;
typedef NS_ENUM(NSInteger,XBCityViewControllerType){
    XBCityViewControllerTypeNormal = 0,
    XBCityViewControllerTypeHot
};
@interface XBCityViewController : UIViewController <UINavigationControllerDelegate>
@property (strong, nonatomic) UIImageView  *coverImageView;
@property (strong, nonatomic) XBGroupItem  *groupItem;
@property (assign, nonatomic) XBCityViewControllerType  type;

- (void)reloadData;

@end
