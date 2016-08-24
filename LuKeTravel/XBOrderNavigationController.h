//
//  XBOrderNavigationController.h
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kTopSpace 90

#import <UIKit/UIKit.h>
@class XBOrderEffectView;
@interface XBOrderNavigationController : UINavigationController

/** 毛玻璃view */
@property (strong, nonatomic) XBOrderEffectView *orderEffectView;

@end
