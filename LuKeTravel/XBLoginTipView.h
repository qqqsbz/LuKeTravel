//
//  XBLoginTipView.h
//  LuKeTravel
//
//  Created by coder on 16/7/27.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBLoginTipView : UIView

- (instancetype)initWithLoginBlock:(dispatch_block_t)block;

- (instancetype)initWithFrame:(CGRect)frame loginBlock:(dispatch_block_t)block;

/** 重新加载语言资源 */
- (void)reloadLanguageConfig;

@end
