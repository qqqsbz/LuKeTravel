//
//  XBActivityNavigationBarView.h
//  LuKeTravel
//
//  Created by coder on 16/7/25.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kActivityNavigationBarHeight 64.f

#import <UIKit/UIKit.h>
@interface XBActivityNavigationBar : UIView

@property (strong, nonatomic) UILabel  *titleLabel;

@property (strong, nonatomic) UIView   *separatorView;

/** 是否在进行动画 */
@property (assign, nonatomic) BOOL  animationing;

@end
