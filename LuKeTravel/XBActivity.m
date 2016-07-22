//
//  XBActivity.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBActivity.h"
#import "XBPackage.h"
#import "XBNotify.h"
#import "XBShareActivity.h"
@implementation XBActivity
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
    return @{@"cityName":@"city_name",
             @"directionsAndLocation":@"directions_and_location",
             @"frequentlyAskedQuestions":@"frequently_asked_questions",
             @"hotState":@"hot_state",
             @"modelId":@"id",
             @"isFavourite":@"is_favourite",
             @"isInstant":@"is_instant",
             @"marketPrice":@"market_price",
             @"subName":@"subname",
             @"participantsFormat":@"participants_format",
             @"reviewsCount":@"reviews_count",
             @"sellPrice":@"sell_price",
             @"termsAndConditions":@"terms_and_conditions",
             @"videoUrl":@"video_url",
             @"shareActivity":@"share_activity"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"packages":[XBPackage class],
             @"notify":[XBNotify class],
             @"shareActivity":[XBShareActivity class]
             };
}

+ (NSValueTransformer *)packagesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBPackage class]];
}

+ (NSValueTransformer *)notifyJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBNotify class]];
}

+ (NSValueTransformer *)shareActivityJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBShareActivity class]];
}

@end
