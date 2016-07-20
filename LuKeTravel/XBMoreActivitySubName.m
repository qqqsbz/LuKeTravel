//
//  XBLevelOneSubName.m
//  LuKeTravel
//
//  Created by coder on 16/7/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBMoreActivitySubName.h"
#import "XBMoreActivitySubNameItem.h"
@implementation XBMoreActivitySubName
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
    return @{@"items":[XBMoreActivitySubNameItem class]
             };
}

+ (NSValueTransformer *)itemsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBMoreActivitySubNameItem class]];
}

@end
