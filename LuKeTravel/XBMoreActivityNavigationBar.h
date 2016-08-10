//
//  XBNavigationBar.h
//  LuKeTravel
//
//  Created by coder on 16/7/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBMoreActivityName;
@class XBMoreActivitySubName;
@class XBMoreActivityNavigationBar;
@class XBMoreActivitySort;
@class XBLevelOne;

@protocol XBMoreActivityNavigationBarDelegate <NSObject>

@optional
- (void)navigationBar:(XBMoreActivityNavigationBar *)navigationBar didSelectedWithLevelOne:(XBLevelOne *)levelOne;

- (void)navigationBar:(XBMoreActivityNavigationBar *)navigationBar didSelectedWithMoreActivitySort:(XBMoreActivitySort *)sort;

@end

@interface XBMoreActivityNavigationBar : UIView
//设置数据
@property (strong, nonatomic) XBMoreActivityName    *name;
//代理
@property (weak, nonatomic) id<XBMoreActivityNavigationBarDelegate> delegate;

/** 标题是否隐藏 */
@property (assign, nonatomic) BOOL  hideTitle;

/** 右边排序按钮是否可用 */
@property (assign, nonatomic) BOOL  sortEnable;

- (instancetype)initWithTargetViewController:(UIViewController *)targetViewController;

- (instancetype)initWithFrame:(CGRect)frame targetViewController:(UIViewController *)targetViewController;

- (void)reloadData;

- (void)closeListView;

- (void)removeAllSubviews;

@end

