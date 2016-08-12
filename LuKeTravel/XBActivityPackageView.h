//
//  XBActivityToolBar.h
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kActivityToolBarHeight 50.f

#import <UIKit/UIKit.h>
@class XBPackage;
@class XBActivityPackageView;

@protocol XBActivityPackageViewDelegate <NSObject>

@optional
- (void)activityPackageView:(XBActivityPackageView *)activityPackageView
   didShowPackageWithButton:(UIButton *)btn;

- (void)activityPackageView:(XBActivityPackageView *)activityPackageView
   didHidePackageWithButton:(UIButton *)btn;

- (void)activityPackageView:(XBActivityPackageView *)activityPackageView
didSelectPackageWithPackage:(XBPackage *)package;

@end

@interface XBActivityPackageView : UIView

/** tablview y的最大值  默认是活动详情banner图片的高度 */
@property (assign, nonatomic) CGFloat  maxTop;

/** 数据源 */
@property (strong, nonatomic) NSArray<XBPackage *>  *packages;

/** 隐藏菜单栏 */
@property (assign, nonatomic) BOOL  hideMenu;

@property (weak, nonatomic) id<XBActivityPackageViewDelegate> delegate;

@end

