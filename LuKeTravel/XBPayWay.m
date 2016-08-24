//
//  XBPayWay.m
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPayWay.h"

@implementation XBPayWay


+ (instancetype)payWayWithTitle:(NSString *)title icon:(UIImage *)icon payWay:(NSString *)payWay
{
    return [[self alloc] initWithTitle:title icon:icon payWay:payWay];
}

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon payWay:(NSString *)payWay
{
    if (self = [super init]) {
        _title = title;
        _icon = icon;
        _payWay = payWay;
        
    }
    return self;
}

@end
