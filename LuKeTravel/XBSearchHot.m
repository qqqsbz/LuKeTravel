//
//  XBSearchHot.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearchHot.h"
#import "XBSearch.h"
@implementation XBSearchHot
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
    return @{@"cityCount":@"city_count"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"items":[XBSearch class]
             };
}

+ (NSValueTransformer *)itemsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBSearch class]];
}

@end
