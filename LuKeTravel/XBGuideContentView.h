//
//  XBGuideContentView.h
//  LuKeTravel
//
//  Created by coder on 16/8/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBGuideContentView : UIView
/** 封面图片 */
@property (strong, nonatomic) UIImageView *imageView;
/** 标题 */
@property (strong, nonatomic) UILabel *titleLabel;
/** 内容 */
@property (strong, nonatomic) UILabel *contentLabel;
/** 隐藏跳过按钮 */
@property (assign, nonatomic) BOOL  hideJump;

- (instancetype)initWithJumpBlock:(dispatch_block_t)jumpBlock;

- (instancetype)initWithFrame:(CGRect)frame jumpBlock:(dispatch_block_t)jumpBlock;

@end
