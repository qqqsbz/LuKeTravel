//
//  XBOrderNextView.h
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBOrderNextView : UIView

/** 设置标题 */
@property (strong, nonatomic) NSString *title;

- (instancetype)initWithNextBlock:(dispatch_block_t)nextBlock;

- (instancetype)initWithFrame:(CGRect)frame nextBlock:(dispatch_block_t)nextBlock;


@end
