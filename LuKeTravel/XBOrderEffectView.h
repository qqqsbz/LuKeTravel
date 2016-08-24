//
//  XBOrderEffectView.h
//  LuKeTravel
//
//  Created by coder on 16/8/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBOrderEffectView : UIView

/** 活动名称 */
@property (strong, nonatomic) UILabel *nameLabel;

/** 子名称 */
@property (strong, nonatomic) UILabel *subNameLabel;

- (instancetype)initWithDismissBlock:(dispatch_block_t)dismissBlock;

- (instancetype)initWithFrame:(CGRect)frame dismissBlock:(dispatch_block_t)dismissBlock;

@end
