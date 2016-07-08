//
//  XBStretchableCityHeaderView.h
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XBLevelOne;
@interface XBStretchableCityHeaderView : NSObject
@property (strong, nonatomic) UITableView   *tableView;
@property (strong, nonatomic) UIView        *view;
@property (strong, nonatomic) NSString      *title;
@property (strong, nonatomic) UILabel       *temperatureLabel;
@property (strong, nonatomic) UIImageView   *temperatureImageView;
@property (strong, nonatomic) NSArray<XBLevelOne *>  *levelOnes;

/**
 * subview:内容部分
 * view   :拉伸的背景图片
 */
- (void)stretchHeaderForTableView:(UITableView *)tableView
                         withView:(UIView *)view;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)resizeView;

@end
