//
//  XBDate.h
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBDate : NSObject
@property (strong, nonatomic) NSString  *date;
@property (strong, nonatomic) NSString  *day;
@property (strong, nonatomic) NSString  *week;
@property (strong, nonatomic) NSString  *month;

+ (instancetype)dateWithDate:(NSString *)date week:(NSString *)week day:(NSString *)day month:(NSString *)month;

- (instancetype)initWithDate:(NSString *)date week:(NSString *)week day:(NSString *)day month:(NSString *)month;

@end
