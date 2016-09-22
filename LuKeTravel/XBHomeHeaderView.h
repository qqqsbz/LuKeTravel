//
//  XBHomeHeaderView.h
//  LuKeTravel
//
//  Created by coder on 16/7/11.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBHomeHeaderView : UIView
@property (strong, nonatomic) UILabel  *leftLabel;

@property (strong, nonatomic) UILabel  *rightLabel;

- (instancetype)initWithViewAllBlock:(dispatch_block_t)block;

- (instancetype)initWithFrame:(CGRect)frame viewAllBlock:(dispatch_block_t)block;

@end
