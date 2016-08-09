//
//  XBExchange.h
//  LuKeTravel
//
//  Created by coder on 16/8/1.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBExchange : XBModel
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *desc;

+ (instancetype)exchangeWithTitle:(NSString *)title text:(NSString *)text desc:(NSString *)desc;

+ (NSArray<XBExchange *> *)exchangeFromArray:(NSArray<NSDictionary *> *)datas;

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text desc:(NSString *)desc;

@end
