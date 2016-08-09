//
//  XBVoucher.m
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBVoucher.h"
#import "XBVouchers.h"
@implementation XBVoucher
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
    return @{@"allRow":@"avatar_url",
             @"currentPage":@"current_page",
             @"totalPage":@"total_page"
            };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"vouchers":[XBVouchers class]};
}

+ (NSValueTransformer *)vouchersJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBVouchers class]];
}

@end
