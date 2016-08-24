//
//  XBConfigSplash.m
//  LuKeTravel
//
//  Created by coder on 16/8/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBConfigSplash.h"
#import "XBConfigImages.h"
@implementation XBConfigSplash
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"images":[XBConfigImages class]
             };
}

+ (NSValueTransformer *)imagesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBConfigImages class]];
}

@end
