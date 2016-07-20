//
//  XBMoreActivityName.m
//  LuKeTravel
//
//  Created by coder on 16/7/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBMoreActivityName.h"
#import "XBLevelOne.h"
@implementation XBMoreActivityName
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
    return @{};
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"items":[XBLevelOne class]
             };
}

+ (NSValueTransformer *)itemsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBLevelOne class]];
}

@end
