//
//  XBStretchableScrollHeaderView.h
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBStretchableScrollHeaderView : UIView
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView       *view;


/**
 * subview:内容部分
 * view   :拉伸的背景图片
 */
- (void)stretchHeaderForScrollView:(UIScrollView *)scrollView
                         withView:(UIView *)view;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)resizeView;

@end
