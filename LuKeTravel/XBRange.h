//
//  XBRange.h
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBRange : NSObject
@property (assign, nonatomic) NSInteger  location;
@property (assign, nonatomic) NSInteger  length;

+ (instancetype)rangeMakeLocation:(NSInteger)location length:(NSInteger)length;

- (instancetype)initRangeMakeLocation:(NSInteger)location length:(NSInteger)length;

@end
