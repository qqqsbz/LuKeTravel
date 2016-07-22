//
//  XBPackage.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPackage.h"
@implementation XBPackage
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
    return @{@"marketPrice":@"market_price",
             @"sellPrice":@"sell_price",
             @"subName":@"subname",
             @"modelId":@"id"
             };
}



@end