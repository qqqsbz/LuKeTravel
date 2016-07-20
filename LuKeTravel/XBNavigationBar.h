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
@class XBNavigationBar;
@class XBMoreActivitySort;
@class XBLevelOne;

@protocol XBNavigationBarDelegate <NSObject>

@optional
- (void)navigationBar:(XBNavigationBar *)navigationBar didSelectedWithLevelOne:(XBLevelOne *)levelOne;

- (void)navigationBar:(XBNavigationBar *)navigationBar didSelectedWithMoreActivitySort:(XBMoreActivitySort *)sort;

@end

@interface XBNavigationBar : UIView
//设置数据
@property (strong, nonatomic) XBMoreActivityName    *name;
//目标控制器 用来pop
@property (strong, nonatomic) UIViewController  *tagetViewController;
//代理
@property (weak, nonatomic) id<XBNavigationBarDelegate> delegate;

//标题是否隐藏
@property (assign, nonatomic) BOOL  hideTitle;

- (void)reloadData;

- (void)closeListView;

- (void)removeAllSubviews;

@end

