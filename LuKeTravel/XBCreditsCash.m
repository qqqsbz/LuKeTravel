//
//  XBCreditsCash.m
//  LuKeTravel
//
//  Created by coder on 16/8/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCreditsCash.h"
#import "XBCredits.h"
@implementation XBCreditsCash
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}


+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"credits":[XBCredits class]};
}

+ (NSValueTransformer *)creditsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBCredits class]];
}

@end
