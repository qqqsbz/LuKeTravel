//
//  TSTView.h
//  iPenYou
//
//  Created by fanly frank on 5/22/15.
//  Copyright (c) 2015 vbuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class XBTSTView;

@protocol TSTViewDataSource <NSObject>

@required
- (NSInteger)numberOfTabsInTSTView:(XBTSTView *)tstview;

- (NSString *)tstview:(XBTSTView *)tstview titleForTabAtIndex:(NSInteger)tabIndex;

- (UIView *)tstview:(XBTSTView *)tstview viewForSelectedTabIndex:(NSInteger)tabIndex;

@end

@protocol TSTViewDelegate <NSObject>

@optional

- (UIColor *)tabViewBackgroundColorForTSTView:(XBTSTView *)tstview;

- (UIColor *)highlightColorForTSTView:(XBTSTView *)tstview;

- (UIColor *)normalColorForTSTView:(XBTSTView *)tstview;

- (UIColor *)normalColorForSeparatorInTSTView:(XBTSTView *)tstview;

- (UIColor *)normalColorForShadowViewInTSTView:(XBTSTView *)tstview;

- (CGFloat)heightForTabInTSTView:(XBTSTView *)tstview;

- (CGFloat)heightForTabSeparatorInTSTView:(XBTSTView *)tstview;

- (CGFloat)heightForSelectedIndicatorInTSTView:(XBTSTView *)tstview;

- (UIFont *)fontForNormalTabTitleInTSTView:(XBTSTView *)tstview;

- (UIFont *)fontForSelectedTabTitleInTSTView:(XBTSTView *)tstview;

- (void)tstview:(XBTSTView *)tstview didSelectedTabAtIndex:(NSInteger)tabIndex;

- (BOOL)hiddenTabSeparator;

@end


@interface XBTSTView : UIView <UIScrollViewDelegate>

@property (assign, nonatomic) id <TSTViewDataSource> dataSource;
@property (assign, nonatomic) id <TSTViewDelegate>   delegate;
//@property (assign, nonatomic, getter=isAutoAverageSort) BOOL autoAverageSort;
@property (assign, nonatomic, getter=isShadowTitleEqualWidth) BOOL shadowTitleEqualWidth;
@property (assign, nonatomic) NSInteger  onePageOfItemCount;        // 只有一页 该页显示多少个
@property (assign, nonatomic) BOOL       zeroMargin;                //是否距离左右为0

- (void)registerReusableContentViewClass:(Class)contentViewClass;

- (NSString *)titleForSelectedTab;

- (NSInteger)indexForSelectedTab;

- (UIScrollView *)topTabViewInTSTView;

- (void)reloadData;

- (void)showFraternalViewAtIndex:(NSInteger)page;

- (NSArray *)tabContentSubViews;

@end

