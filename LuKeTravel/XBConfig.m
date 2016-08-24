//
//  XBConfig.m
//  LuKeTravel
//
//  Created by coder on 16/8/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBConfig.h"
#import "XBConfigSplash.h"
#import "XBConfigCountry.h"
@implementation XBConfig

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
    return @{@"splashZhCN":@"splash_zh_CN",
             @"splashZhTW":@"splash_zh_TW",
             @"splashEN":@"splash_en",
             @"firstCountryNumberEN":@"first_country_number_en",
             @"firstCountryNumberZHCN":@"first_country_number_zh_CN",
             @"firstCountryNumberZHTW":@"first_country_number_zh_TW"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"splashZhCN":[XBConfigSplash class],
             @"splashZhTW":[XBConfigSplash class],
             @"splashEN":[XBConfigSplash class],
             @"firstCountryNumberEN":[XBConfigCountry class],
             @"firstCountryNumberZHCN":[XBConfigCountry class],
             @"firstCountryNumberZHTW":[XBConfigCountry class]
             };
}

+ (NSValueTransformer *)firstCountryNumberENJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBConfigCountry class]];
}

+ (NSValueTransformer *)firstCountryNumberZHCNJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBConfigCountry class]];
}

+ (NSValueTransformer *)firstCountryNumberZHTWJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBConfigCountry class]];
}

+ (NSValueTransformer *)splashZhCNJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBConfigSplash class]];
}

+ (NSValueTransformer *)splashZhTWJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBConfigSplash class]];
}

+ (NSValueTransformer *)splashENJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBConfigSplash class]];
}
@end
