//
//  XBMoreActivitySort.m
//  LuKeTravel
//
//  Created by coder on 16/7/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBMoreActivitySort.h"

@implementation XBMoreActivitySort

+ (instancetype)sortWithName:(NSString *)name type:(NSInteger)type
{
    return [[self alloc] initWithName:name type:type];
}

- (instancetype)initWithName:(NSString *)name type:(NSInteger)type
{
    if (self = [super init]) {
        _name = name;
        _type = type;
    }
    return self;
}


@end
