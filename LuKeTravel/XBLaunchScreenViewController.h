//
//  XBLaunchScreenViewController.h
//  LuKeTravel
//
//  Created by coder on 16/8/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBLaunchScreenViewController : UIViewController

/** 菊花转动 */
- (void)startIndicatorView;

/** 显示引导页 */
- (void)showGuideViewWithComplete:(dispatch_block_t)complete;

@end
