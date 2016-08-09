//
//  XBWishlist.m
//  LuKeTravel
//
//  Created by coder on 16/8/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBWishlist.h"

@implementation XBWishlist
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
    return @{@"destinationName":@"destination_name",
             @"hotState":@"hot_state",
             @"isFavourite":@"is_favourite",
             @"isInstant":@"is_instant",
             @"isVideo":@"is_video",
             @"marketPrice":@"market_price",
             @"participantsFormat":@"participants_format",
             @"sellPrice":@"sell_price",
             @"subName":@"subname",
             @"thumbUrl":@"thumb_url",
             @"modelId":@"id"
             };
}
@end