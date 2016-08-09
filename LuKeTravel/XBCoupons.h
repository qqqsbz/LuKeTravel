//
//  XBCoupons.h
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"

@interface XBCoupons : XBModel
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *discountDesc;
@property (strong, nonatomic) NSString *endDate;
@property (strong, nonatomic) NSString *specialDesc;
@property (assign, nonatomic) BOOL     usable;
@end