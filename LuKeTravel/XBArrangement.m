//
//  XBArrangement.m
//  LuKeTravel
//
//  Created by coder on 16/8/11.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBArrangement.h"

@implementation XBArrangement
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"hasStock":@"has_stock",
             @"startTime":@"start_time",
             @"modelId":@"id"
             };
}

@end
