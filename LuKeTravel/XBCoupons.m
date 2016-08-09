//
//  XBCoupons.m
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCoupons.h"

@implementation XBCoupons
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
    return @{@"discountDesc":@"discount_desc",
             @"endDate":@"end_date",
             @"specialDesc":@"special_desc"
             };
}
@end