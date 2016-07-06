//
//  XBGroupItem.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBGroupItem.h"

@implementation XBGroupItem
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
             @"subName":@"subname",
             @"cityName":@"city_name",
             @"modelId":@"id",
             @"marketPrice":@"market_price",
             @"sellingPrice":@"selling_price"
             };
}
@end
