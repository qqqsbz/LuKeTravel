//
//  XBOrderBookPrice.m
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderBookPrice.h"

@implementation XBOrderBookPrice
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
    return @{@"marketPrice":@"market_price",
             @"maxNum":@"max_num",
             @"minNum":@"min_num",
             @"unitName":@"unit_name",
             @"modelId":@"id"
             };
}
@end
