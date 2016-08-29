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
/** 数据列表 */
@property (strong, nonatomic) UITableView   *tableView;
/** 封面图片 */
@property (strong, nonatomic) UIImageView  *coverImageView;
/** 城市id */
@property (assign, nonatomic) NSInteger  cityId;
/** 城市数据 */
@property (strong, nonatomic) XBCity        *city;
/** 类型 */
@property (assign, nonatomic) XBCityViewControllerType  type;

- (void)reloadData;

@end
