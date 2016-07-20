//
//  XBMoreActivitySort.h
//  LuKeTravel
//
//  Created by coder on 16/7/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBMoreActivitySort : NSObject
@property (strong, nonatomic) NSString  *name;
@property (assign, nonatomic) NSInteger type;

- (instancetype)initWithName:(NSString *)name type:(NSInteger)type;

+ (instancetype)sortWithName:(NSString *)name type:(NSInteger)type;

@end
