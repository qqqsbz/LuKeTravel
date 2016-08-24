//
//  XBBookOrderViewController.h
//  LuKeTravel
//
//  Created by coder on 16/8/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBArrangement;
@interface XBBookOrderViewController : UIViewController

/** 订单数据 */
@property (strong, nonatomic) XBArrangement *arrangement;

@end
