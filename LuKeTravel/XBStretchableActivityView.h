//
//  XBStretchableScrollHeaderView.h
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBActivity;
@class XBParserContent;
@class XBStretchableActivityView;
@protocol XBStretchableActivityViewDelegate <NSObject>

@optional
- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView
           didSelectLinkWithURL:(NSURL *)url;

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectRecommendWithText:(NSString *)text;

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectFavoriteWithActivity:(XBActivity *)activity;

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectDirectionWithParserContent:(NSArray<XBParserContent *> *)parserContents;

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectDetailWithParserContent:(NSArray<XBParserContent *> *)parserContents;

- (void)stretchableActivityView:(XBStretchableActivityView *)stretchableActivityView didSelectReviewWithReviewCount:(NSInteger)reviewCount;

@end

@interface XBStretchableActivityView : UIView
/** 目标控件 */
@property (strong, nonatomic) UIScrollView  *scrollView;
/** 封面view */
@property (strong, nonatomic) UIView        *headerView;
/** 活动数据 */
@property (strong, nonatomic) XBActivity    *activity;
/** 代理 */
@property (weak, nonatomic) id<XBStretchableActivityViewDelegate> delegate;
/** 是否收藏 */
@property (assign, nonatomic, getter=isFavorite) BOOL  favorite;
/**
 * subview:内容部分
 * view   :拉伸的背景图片
 */
- (void)stretchHeaderForScrollView:(UIScrollView *)scrollView
                         withView:(UIView *)view;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)resizeView;

@end
