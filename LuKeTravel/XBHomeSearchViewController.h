//
//  XBHomeSearchViewController.h
//  LuKeTravel
//
//  Created by coder on 16/7/13.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBHomeSearchViewController : UIViewController
/** 列表 */
@property (strong, nonatomic) UITableView       *tableView;
/** 搜索结果 */
@property (strong, nonatomic) NSArray<XBSearchItem *>       *searchItems;
@end
