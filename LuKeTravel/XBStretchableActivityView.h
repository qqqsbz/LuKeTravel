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
@property (strong, nonatomic) UIScrollView  *scrollView;

@property (strong, nonatomic) UIView        *headerView;

@property (strong, nonatomic) XBActivity    *activity;

@property (weak, nonatomic) id<XBStretchableActivityViewDelegate> delegate;

/**
 * subview:内容部分
 * view   :拉伸的背景图片
 */
- (void)stretchHeaderForScrollView:(UIScrollView *)scrollView
                         withView:(UIView *)view;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)resizeView;

@end
