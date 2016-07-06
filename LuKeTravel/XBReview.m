//
//  XBReview.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBReview.h"
#import "XBComment.h"
@implementation XBReview
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
    return @{@"currentPage":@"current_page",
             @"totalPages":@"total_pages"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"reviews":[XBComment class]
             };
}

+ (NSValueTransformer *)reviewsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBComment class]];
}

@end
