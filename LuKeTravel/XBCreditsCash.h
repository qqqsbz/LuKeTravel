//
//  XBCreditsCash.h
//  LuKeTravel
//
//  Created by coder on 16/8/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBCredits;
@interface XBCreditsCash : XBModel
@property (assign, nonatomic) NSInteger  amount;
@property (assign, nonatomic) NSInteger  credit;
@property (strong, nonatomic) NSArray<XBCredits *> *credits;
@end