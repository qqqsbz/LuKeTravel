//
//  XBPayWay.h
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBPayWay : NSObject
/** 图标 */
@property (strong, nonatomic) UIImage *icon;
/** 名称 */
@property (strong, nonatomic) NSString *title;
/** 支付类型 */
@property (strong, nonatomic) NSString *payWay;


+ (instancetype)payWayWithTitle:(NSString *)title icon:(UIImage *)icon payWay:(NSString *)payWay;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon payWay:(NSString *)payWay;

@end
