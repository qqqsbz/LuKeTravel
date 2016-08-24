//
//  XBOrderPrePayViewController.h
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBBook;
@class XBPayContact;
@class XBOrderPrePayNavigationBar;
@interface XBOrderPrePayViewController : UITableViewController <UINavigationControllerDelegate>

/** 订单信息 */
@property (strong, nonatomic) XBOrderPrePayNavigationBar *orderPrePayNavigationBar;

@property (strong, nonatomic) XBBook *book;
@end

