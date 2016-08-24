//
//  XBOrderDetailToolBar.h
//  LuKeTravel
//
//  Created by coder on 16/8/19.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kOrderDetailBarHeight 60
#import <UIKit/UIKit.h>

@interface XBOrderDetailToolBar : UIView

- (instancetype)initWithPayBlock:(dispatch_block_t)payBlock;

- (instancetype)initWithFrame:(CGRect)frame payBlock:(dispatch_block_t)payBlock;

@end
