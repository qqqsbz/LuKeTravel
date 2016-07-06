//
//  XBActivity.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBActivity.h"
#import "XBPackage.h"
@implementation XBActivity
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
    return @{@"cityName":@"city_name",
             @"isFavourite":@"is_favourite",
             @"subName":@"subname"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"packages":[XBPackage class]
             };
}

+ (NSValueTransformer *)packagesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBPackage class]];
}
@end
