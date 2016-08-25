//
//  XBFavoriteTemp.h
//  LuKeTravel
//
//  Created by coder on 16/8/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBHomeActivityCell.h"
#import "XBHomeActivityContentCell.h"

/** 该类存放未登录前的数据 以便登录后在进行操作 */
@interface XBFavoriteTemp : NSObject

/** 选择的cell */
@property (strong, nonatomic) XBHomeActivityCell *homeActivityCell;
/** 子cell */
@property (strong, nonatomic) XBHomeActivityContentCell  *homeActivityContentCell;
/** 下标 */
@property (assign, nonatomic) NSInteger  index;

+ (instancetype)favoriteTempWithHomeActivityCell:(XBHomeActivityCell *)homeActivityCell homeActivityContentCell:(XBHomeActivityContentCell *)homeActivityContentCell index:(NSInteger)index;

- (instancetype)initWithHomeActivityCell:(XBHomeActivityCell *)homeActivityCell homeActivityContentCell:(XBHomeActivityContentCell *)homeActivityContentCell index:(NSInteger)index;

@end
