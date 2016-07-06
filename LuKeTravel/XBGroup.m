//
//  XBGroup.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBGroup.h"
#import "XBGroupItem.h"
@implementation XBGroup
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
    return @{@"className":@"class_name",
             @"displayType":@"display_type",
             @"displayText":@"display_text",
             @"modelId":@"id"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"items":[XBGroupItem class]
             };
}

+ (NSValueTransformer *)itemsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBGroupItem class]];
}

@end