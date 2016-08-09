//
//  XBUser.m
//  LuKeTravel
//
//  Created by coder on 16/7/28.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBUser.h"

@implementation XBUser
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
    return @{@"avatarUrl":@"avatar_url",
             @"validCoupons":@"valid_coupons"
             };
}

@end
