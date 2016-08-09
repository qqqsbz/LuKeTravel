//
//  XBUserInfo.m
//  LuKeTravel
//
//  Created by coder on 16/8/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBUserInfo.h"

@implementation XBUserInfo
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
    return @{@"avatarUrl":@"avatar_url"};
}
@end
