//
//  XBActivityView.h
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBActivity;
@class XBActivityView;

@protocol XBActivityViewDelegate <NSObject>

@optional
- (void)activityView:(XBActivityView *)activityView didSelectLinkWithURL:(NSURL *)url;

@end

@interface XBActivityView : UIView

@property (strong, nonatomic) XBActivity  *activity;

@property (weak, nonatomic) id<XBActivityViewDelegate> delegate;

@end
