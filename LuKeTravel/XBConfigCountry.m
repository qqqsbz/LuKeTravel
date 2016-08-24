//
//  XBConfigCountry.m
//  LuKeTravel
//
//  Created by coder on 16/8/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBConfigCountry.h"

@implementation XBConfigCountry
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
    return @{@"countryCode":@"country_code"
             };
}

@end
