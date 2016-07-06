//
//  XBPackage.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPackage.h"
#import "XBNotify.h"
@implementation XBPackage
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
             @"sellPrice":@"sell_price",
             @"subName":@"subname"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"notify":[XBNotify class]
             };
}

+ (NSValueTransformer *)notifyJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBNotify class]];
}


@end