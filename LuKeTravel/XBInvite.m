//
//  XBInvite.m
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBInvite.h"

@implementation XBInvite
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
    return @{@"hasUsedCode":@"has_used_code",
             @"referImage":@"refer_image",
             @"referUrl":@"refer_url"
            };
}
@end