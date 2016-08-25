//
//  XBRequest.m
//  LuKeTravel
//
//  Created by coder on 16/8/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBRequest.h"
@interface XBRequest()

@property (strong, nonatomic) NSDictionary *params;

@property (strong, nonatomic) NSDictionary *api;

@end
@implementation XBRequest

- (instancetype)initWithApi:(NSString *)api params:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        _api =  @{@"method": api};
        _params = params;
    }
    return self;
}

- (NSString *)description
{
    NSDictionary *request = @{@"request": self.api, @"params": self.params ?: @{}};
    
    NSError *error = nil;
    NSJSONWritingOptions options = 0;
#ifdef DEBUG
    options = NSJSONWritingPrettyPrinted;
#endif
    NSData *data = [NSJSONSerialization dataWithJSONObject:request options:options error:&error];
    if (!data || error) {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"Could not serialize request!"
                               userInfo:error.userInfo] raise];
    }
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}

@end
