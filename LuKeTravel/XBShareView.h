//
//  XBShareView.h
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBShareActivity;
@interface XBShareView : UIView

- (instancetype)initWithShareActivity:(XBShareActivity *)shareActivity targetViewController:(UIViewController *)targetViewController;

- (instancetype)initWithFrame:(CGRect)frame shareActivity:(XBShareActivity *)shareActivity targetViewController:(UIViewController *)targetViewController;

- (void)toggle;

@end
