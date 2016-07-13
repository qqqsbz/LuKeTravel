//
//  XBHotDestination.m
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHotDestination.h"

@implementation XBHotDestination
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
    return @{@"imageUrl":@"image_url",
             @"subName":@"subname",
             @"modelId":@"id"
             };
}
@end
