//
//  XBDestination.m
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDestination.h"
#import "XBHotDestination.h"
#import "XBDestinationCities.h"
@implementation XBDestination
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
    return @{@"popularDestinations":@"popular_destination",
             @"allCities":@"all_cities"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"popularDestinations":[XBHotDestination class],
             @"allCities":[XBDestinationCities class]
             };
}

+ (NSValueTransformer *)popularDestinationsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBHotDestination class]];
}

+ (NSValueTransformer *)allCitiesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBDestinationCities class]];
}


@end
