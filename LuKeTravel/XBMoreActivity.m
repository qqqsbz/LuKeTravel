//
//  XBMoreActivity.m
//  LuKeTravel
//
//  Created by coder on 16/7/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBMoreActivity.h"
#import "XBSearchItem.h"
#import "XBMoreActivityName.h"
#import "XBMoreActivitySubName.h"
@implementation XBMoreActivity
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
    return @{@"selectedTime":@"selected_time",
             @"sortType":@"sort_type",
             @"subName":@"subname"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"name":[XBMoreActivityName class],
             @"subName":[XBMoreActivitySubName class],
             @"items":[XBSearchItem class]
             };
}

+ (NSValueTransformer *)nameJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBMoreActivityName class]];
}

+ (NSValueTransformer *)subNameJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBMoreActivitySubName class]];
}

+ (NSValueTransformer *)itemsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBSearchItem class]];
}

@end
