//
//  XBConfigImages.m
//  LuKeTravel
//
//  Created by coder on 16/8/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBConfigImages.h"

@implementation XBConfigImages
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
    return @{@"beginTime":@"begin_time",
             @"endTime":@"end_time",
             @"imgUrl":@"img_url"
             };
}
@end
