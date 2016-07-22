//
//  XBStretchableScrollHeaderView.h
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBStretchableActivityHeaderView : UIView
@property (strong, nonatomic) UITableView  *tableView;
@property (strong, nonatomic) UIView       *headerView;


/**
 * subview:内容部分
 * view   :拉伸的背景图片
 */
- (void)stretchHeaderForTableView:(UITableView *)tableView
                         withView:(UIView *)view;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)resizeView;

@end
