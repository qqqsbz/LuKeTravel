//
//  XBCity.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCity.h"
#import "XBLevelOne.h"
#import "XBGroup.h"
@implementation XBCity

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
    return @{@"imageUrl":@"image_url",
             @"levelOnes":@"level_one",
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"levelOne":[XBLevelOne class],
             @"groups":[XBGroup class]
             };
}

+ (NSValueTransformer *)levelOnesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBLevelOne class]];
}

+ (NSValueTransformer *)groupsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBGroup class]];
}

@end
