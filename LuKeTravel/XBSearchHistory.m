//
//  XBSearchHistory.m
//  LuKeTravel
//
//  Created by coder on 16/7/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearchHistory.h"

@implementation XBSearchHistory
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSSet *)propertyKeysForManagedObjectUniquing
{
    return [NSSet setWithObject:@"name"];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}
@end
