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

@property (strong, nonatomic) NSString *title;

- (instancetype)initWithShareActivity:(XBShareActivity *)shareActivity targetViewController:(UIViewController *)targetViewController dismissBlock:(dispatch_block_t)dismissBlock;

- (instancetype)initWithFrame:(CGRect)frame shareActivity:(XBShareActivity *)shareActivity targetViewController:(UIViewController *)targetViewController dismissBlock:(dispatch_block_t)dismissBlock;

- (void)toggle;

@end
