//
//  XBDate.m
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDate.h"

@implementation XBDate

+ (instancetype)dateWithDate:(NSString *)date week:(NSString *)week day:(NSString *)day month:(NSString *)month
{
    return [[self alloc] initWithDate:date week:week day:day month:month];
}

- (instancetype)initWithDate:(NSString *)date week:(NSString *)week day:(NSString *)day month:(NSString *)month
{
    if (self = [super init]) {
        _date  = date;
        _week  = week;
        _day   = day;
        _month = month;
    }
    return self;
}

@end
