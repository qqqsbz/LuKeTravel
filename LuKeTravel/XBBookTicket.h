//
//  XBBookTickets.h
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBArrangement;
@class XBBookOtherInfo;
@interface XBBookTicket : XBModel
@property (strong, nonatomic) NSString  *marketPrice;
@property (strong, nonatomic) NSString  *packageDesc;
@property (strong, nonatomic) NSString  *ticketPrice;
@property (assign, nonatomic) NSInteger totalCounts;
@property (strong, nonatomic) XBArrangement *arrangement;

@property (strong, nonatomic) NSArray<NSString *>        *ticketTypeCounts;
@property (strong, nonatomic) NSArray<XBBookOtherInfo *> *generalOtherInfos;
@property (strong, nonatomic) NSArray *individualOtherInfos;
@end
