//
//  XBDestinationCities.m
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDestinationCities.h"
#import "XBDestinationItem.h"
@implementation XBDestinationCities
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
    return @{@"regionName":@"region_name",
             @"modelId":@"ID"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"items":[XBDestinationItem class]
             };
}

+ (NSValueTransformer *)itemsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBDestinationItem class]];
}

@end
