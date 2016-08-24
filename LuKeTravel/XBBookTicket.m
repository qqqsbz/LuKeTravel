//
//  XBBookTickets.m
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBBookTicket.h"
#import "XBArrangement.h"
#import "XBBookOtherInfo.h"
@implementation XBBookTicket
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
    return @{
             @"marketPrice":@"market_price",
             @"packageDesc":@"package_desc",
             @"ticketPrice":@"ticket_price",
             @"ticketTypeCounts":@"ticket_type_counts",
             @"totalCounts":@"total_counts",
             @"modelId":@"id"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{
             @"arrangement":[XBArrangement class],
             @"generalOtherInfos":[XBBookOtherInfo class]
             };
}


+ (NSValueTransformer *)arrangementJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBArrangement class]];
}

+ (NSValueTransformer *)generalOtherInfosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBBookOtherInfo class]];
}

@end
