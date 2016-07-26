//
//  XBActivityToolBar.h
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kActivityToolBarHeight 60.f
#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(UIButton *);
@interface XBActivityToolBar : UIView

- (instancetype)initWithSelectedBlock:(SelectedBlock)block;

- (instancetype)initWithFrame:(CGRect)frame selectedBlock:(SelectedBlock)block;

@end
