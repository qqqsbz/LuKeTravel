//
//  XBBookOrderViewController.h
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBPackage;
@interface XBBookOrderViewController : UIViewController

@property (strong, nonatomic) XBPackage *package;

/** 加载数据 */
- (void)reloadArrangements;

/** pop */
- (void)dismissAction;

@end
