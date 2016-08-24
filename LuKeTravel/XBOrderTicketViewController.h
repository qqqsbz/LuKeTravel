//
//  XBOrderTicketViewController.h
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBOrderTicketNavigationBar;
@class XBBook;
@interface XBOrderTicketViewController : UITableViewController <UINavigationControllerDelegate>

/** 订单信息 */
@property (strong, nonatomic) XBOrderTicketNavigationBar *orderTicketNavigationBar;
/** 订单数据 */
@property (strong, nonatomic) XBBook *book;

@end
