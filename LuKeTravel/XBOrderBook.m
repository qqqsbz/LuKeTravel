//
//  XBOrderBook.m
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderBook.h"
#import "XBOrderBookPrice.h"
@implementation XBOrderBook
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
    return @{@"remainTicketCount":@"remain_ticket_count"
           };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"prices":[XBOrderBookPrice class]};
}

+ (NSValueTransformer *)pricesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBOrderBookPrice class]];
}
@end
