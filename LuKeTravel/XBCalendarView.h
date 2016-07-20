//
//  XBCalendarView.h
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBCalendarView;
@protocol XBCalendarViewDelegate <NSObject>

@optional
- (void)calendarView:(XBCalendarView *)calendarView didSelectedWithDateString:(NSString *)dateString;

@end

@interface XBCalendarView : UIView

@property (weak, nonatomic) id<XBCalendarViewDelegate> delegate;

- (void)reloadData;

@end
