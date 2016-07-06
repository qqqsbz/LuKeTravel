//
//  XBHome.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHome.h"
#import "XBGroup.h"
#import "XBInviation.h"
@implementation XBHome
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
    return @{@"subName":@"subname",
             @"bannerImages":@"banner_images"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"inviation":[XBInviation class],
             @"groups":[XBGroup class]
             };
}

+ (NSValueTransformer *)groupsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBGroup class]];
}

+ (NSValueTransformer *)inviationJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBInviation class]];
}

@end
