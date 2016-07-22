//
//  XBRange.m
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBRange.h"

@implementation XBRange

+ (instancetype)rangeMakeLocation:(NSInteger)location length:(NSInteger)length
{
    return [[self alloc] initRangeMakeLocation:location length:length];
}

- (instancetype)initRangeMakeLocation:(NSInteger)location length:(NSInteger)length
{
    if (self = [super init]) {
        _location = location;
        _length   = length;
    }
    return self;
}

@end
