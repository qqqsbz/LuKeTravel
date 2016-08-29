//
//  XBDestinationViewController.h
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBDestinationViewController : UIViewController
/** 热门目的地列表 */
@property (strong, nonatomic) UITableView  *hotTableView;
/** 热门目的地选中NSIndexPath */
@property (strong, nonatomic) NSIndexPath  *currentIndexPath;
@end
