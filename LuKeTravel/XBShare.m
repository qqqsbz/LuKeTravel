//
//  XBShare.m
//  LuKeTravel
//
//  Created by coder on 16/7/27.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBShare.h"

@implementation XBShare

+ (instancetype)shareWithName:(NSString *)name icon:(UIImage *)icon plantform:(NSString *)plantform
{
    return [[self alloc] initWithName:name icon:icon plantform:plantform];
}

- (instancetype)initWithName:(NSString *)name icon:(UIImage *)icon plantform:(NSString *)plantform
{
    if (self = [super init]) {
        _icon = icon;
        _name = name;
        _plantform = plantform;
    }
    return self;
}

@end
