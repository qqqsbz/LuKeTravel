//
//  XBFavoriteTemp.m
//  LuKeTravel
//
//  Created by coder on 16/8/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBFavoriteTemp.h"

@implementation XBFavoriteTemp

+ (instancetype)favoriteTempWithHomeActivityCell:(XBHomeActivityCell *)homeActivityCell homeActivityContentCell:(XBHomeActivityContentCell *)homeActivityContentCell index:(NSInteger)index{
    
    return [[self alloc] initWithHomeActivityCell:homeActivityCell homeActivityContentCell:homeActivityContentCell index:index];
}

- (instancetype)initWithHomeActivityCell:(XBHomeActivityCell *)homeActivityCell homeActivityContentCell:(XBHomeActivityContentCell *)homeActivityContentCell index:(NSInteger)index
{
    if (self = [super init]) {
    
        _homeActivityCell = homeActivityCell;
        
        _homeActivityContentCell = homeActivityContentCell;
        
        _index = index;
    }
    
    return self;
}

@end
