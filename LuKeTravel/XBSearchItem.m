//
//  XBSearchItem.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearchItem.h"

@implementation XBSearchItem
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
             @"sellingPrice":@"selling_price",
             @"hotState":@"hot_state",
             @"participantsFormat":@"participants_format"
             };
}
@end
