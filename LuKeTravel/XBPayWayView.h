//
//  XBPayWayView.h
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBPayWay;
@class XBPayWayView;

@protocol XBPayWayViewDelegate <NSObject>

@optional
- (void)payWayView:(XBPayWayView *)payWayView didSelectWithPayWay:(XBPayWay *)payWay;

@end

@interface XBPayWayView : UIView

@property (weak, nonatomic) id<XBPayWayViewDelegate> delegate;

/** 获取主要显示view */
- (UIView *)payWayContentView;

/** 显示与隐藏 */
- (void)toggle;

@end
