//
//  XBHomeViewController.h
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBHomeViewController : UIViewController
/** 数据 */
@property (strong, nonatomic) XBHome        *home;

/** 数据列表 */
@property (strong, nonatomic) UITableView   *tableView;
@end
