//
//  XBHomeSearchHistoryHeaderView.h
//  LuKeTravel
//
//  Created by coder on 16/7/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBHomeSearchHistoryHeaderView : UIView

- (instancetype)initWithClearBlock:(dispatch_block_t)clearBlock;

- (instancetype)initWithFrame:(CGRect)frame clearBlock:(dispatch_block_t)clearBlock;

@end
