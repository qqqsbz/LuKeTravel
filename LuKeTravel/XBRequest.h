//
//  XBRequest.h
//  LuKeTravel
//
//  Created by coder on 16/8/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBRequest : NSObject

- (instancetype)initWithApi:(NSString *)api params:(NSDictionary *)params;

@end
