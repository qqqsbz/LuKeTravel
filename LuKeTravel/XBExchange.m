//
//  XBExchange.m
//  LuKeTravel
//
//  Created by coder on 16/8/1.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBExchange.h"

@implementation XBExchange

+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}


+ (instancetype)exchangeWithTitle:(NSString *)title text:(NSString *)text desc:(NSString *)desc
{
    return [[self alloc] initWithTitle:title text:text desc:desc];
}

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text desc:(NSString *)desc
{
    if (self = [super init]) {
        _title = title;
        _text  = text;
        _desc  = desc;
    }
    return self;
}

+ (NSArray<XBExchange *> *)exchangeFromArray:(NSArray<NSDictionary *> *)datas
{
    NSError *error = nil;
    NSArray *result = [MTLJSONAdapter modelsOfClass:[XBExchange class] fromJSONArray:datas error:&error];
    return result;
}

@end
