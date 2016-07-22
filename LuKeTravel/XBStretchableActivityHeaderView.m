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

- (void)stretchHeaderForTableView:(UITableView *)tableView withView:(UIView *)view
{
    _tableView = tableView;
    
    _headerView = view;
    
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    
    _initialFrame       = _headerView.frame;
    
    _defaultViewHeight  = _initialFrame.size.height;
    
    [_tableView addSubview:_headerView];
    
    _tableView.tableHeaderView = self.contentView;
    
}


- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGRect f     = _headerView.frame;
    f.size.width = _tableView.frame.size.width;
    _headerView.frame  = f;
    
    if(scrollView.contentOffset.y < 0)
    {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        
        _initialFrame.origin.y = - offsetY;
        
        _initialFrame.size.height = _defaultViewHeight + offsetY;
        
        
        _headerView.frame = _initialFrame;
        
        
    }
    
}


- (void)resizeView
{
    _initialFrame.size.width = _tableView.frame.size.width;
    _headerView.frame = _initialFrame;
}



@end
