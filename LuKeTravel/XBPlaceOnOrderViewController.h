//
//  XBPlaceOnOrderViewController.h
//  LuKeTravel
//
//  Created by coder on 16/8/10.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBPackage;
@interface XBPlaceOnOrderViewController : UIViewController

- (instancetype)initWithPackage:(XBPackage *)package;

/** 显示日历 */
- (void)showCalendar;

@end
