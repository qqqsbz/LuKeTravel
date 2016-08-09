//
//  XBCoupon.m
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCoupon.h"
#import "XBCoupons.h"
@implementation XBCoupon
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
    return @{@"usedCouponCounts":@"used_coupon_counts",
             @"validCouponCounts":@"valid_coupon_counts"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"coupons":[XBCoupons class]};
}

+ (NSValueTransformer *)couponsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBCoupons class]];
}

@end
