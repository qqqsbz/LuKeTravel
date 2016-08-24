//
//  XBOrderBook.h
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBOrderBookPrice;
@interface XBOrderBook : XBModel
@property (strong, nonatomic) NSString  *currency;
@property (assign, nonatomic) NSInteger remainTicketCount;
@property (strong, nonatomic) NSArray<XBOrderBookPrice *> *prices;
@end
