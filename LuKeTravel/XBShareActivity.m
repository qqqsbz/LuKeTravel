//
//  XBShareActivity.m
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBShareActivity.h"

@implementation XBShareActivity
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
    return @{@"subTitle":@"sub_title"
             };
}
@end