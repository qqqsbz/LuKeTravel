//
//  XBOrderCalendarView.h
//  LuKeTravel
//
//  Created by coder on 16/8/10.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBArrangement;
@class XBOrderCalendarView;

@protocol XBOrderCalendarViewDelegate <NSObject>

@optional

- (void)orderCalendarView:(XBOrderCalendarView *)orderCalendarView didSelectOrderWithArrangement:(XBArrangement *)arrangement;

@end

@interface XBOrderCalendarView : UIView


/** 活动日历数据 */
@property (strong, nonatomic) NSArray<XBArrangement *> *arrangements;

@property (weak, nonatomic) id<XBOrderCalendarViewDelegate> delegate;

@end
