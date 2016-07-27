//
//  XBBasicViewController.h
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBBasicViewController : UIViewController
/** 导航栏 */
@property (strong, nonatomic) UIView  *navigationView;

/** 导航栏分割线 */
@property (strong, nonatomic) UIView  *navigationSeparatorView;

/** 导航栏 标题*/
@property (strong, nonatomic) UILabel   *navigationtTitleLabel;

/** 导航栏 左边按钮 */
@property (strong, nonatomic) UIButton  *navigationLeftButton;

/** 导航栏 右边按钮 */
@property (strong, nonatomic) UIButton  *navigationRightButton;

/** 左边按钮处理的点击事件 */
- (void)leftButtonAction;

/** 右边按钮处理的点击事件 */
- (void)rightButtonAction;

@end
