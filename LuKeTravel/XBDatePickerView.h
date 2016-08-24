//
//  XBDatePickerView.h
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBDatePickerView;

@protocol XBDatePickerViewDelegate <NSObject>

@optional
- (void)datePickerView:(XBDatePickerView *)datePickerView didDoneWithDate:(NSDate *)date;

@end
@interface XBDatePickerView : UIView

/** 是否显示 */
@property (assign, nonatomic, getter=isShow) BOOL  show;

@property (weak, nonatomic) id<XBDatePickerViewDelegate> delegate;

/** 显示与隐藏 */
- (void)toggle;

@end
