//
//  XBOrderDetailViewController.h
//  LuKeTravel
//
//  Created by coder on 16/8/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBBook;
@class XBPayWay;
@interface XBOrderDetailViewController : UITableViewController <UINavigationControllerDelegate>

/** 订单详细 */
@property (strong, nonatomic) XBBook *book;
/** 支付方式 */
@property (strong, nonatomic) XBPayWay *payWay;
/** 日期 */
@property (strong, nonatomic) NSString *dateString;

@end
