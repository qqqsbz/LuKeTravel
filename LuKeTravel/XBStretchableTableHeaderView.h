//
//  StretchableTableHeaderView.h
//  StretchableTableHeaderView
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XBStretchableTableHeaderView : NSObject

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView      *view;
@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UILabel     *subTitleLabel;


/**
 * subview:内容部分
 * view   :拉伸的背景图片
 */
- (void)stretchHeaderForTableView:(UITableView *)tableView
                         withView:(UIView *)view;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)resizeView;

@end

/*
 *使用时要实现以下两个代理方法
 *- (void)scrollViewDidScroll:(UIScrollView *)scrollView
 *- (void)viewDidLayoutSubviews
*/