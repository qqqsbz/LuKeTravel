//
//  XBStretchableScrollHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBStretchableScrollHeaderView.h"
@interface XBStretchableScrollHeaderView()
@property (assign, nonatomic) CGRect   initialFrame;
@property (assign, nonatomic) CGFloat  defaultViewHeight;
@property (strong, nonatomic) UIView   *contentView;
@end
@implementation XBStretchableScrollHeaderView

- (void)stretchHeaderForScrollView:(UIScrollView *)scrollView withView:(UIView *)view
{
    _scrollView = scrollView;
    
    _view      = view;
    
    _initialFrame       = _view.frame;
    
    _defaultViewHeight  = _initialFrame.size.height;
    
    self.contentView = [[UIView alloc] initWithFrame:view.bounds];
    
    [_scrollView addSubview:_view];
    
    [_scrollView addSubview:self.contentView];
    
}


- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGRect f     = _view.frame;
    f.size.width = _scrollView.frame.size.width;
    _view.frame  = f;
    
    if(scrollView.contentOffset.y < 0)
    {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        
        _initialFrame.origin.y = - offsetY;
        
        _initialFrame.size.height = _defaultViewHeight + offsetY;
        
        _view.frame = _initialFrame;
    }
}


- (void)resizeView
{
    _initialFrame.size.width = _scrollView.frame.size.width;
    _view.frame = _initialFrame;
}



@end
