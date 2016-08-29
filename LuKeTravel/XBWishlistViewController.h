//
//  XBWishlistViewController.h
//  LuKeTravel
//
//  Created by coder on 16/8/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBWishlistViewController : UIViewController

/** 数据列表 */
@property (strong, nonatomic) UITableView  *tableView;
/** 数据集合 */
@property (strong, nonatomic) NSArray<XBWishlist *> *datas;
@end
