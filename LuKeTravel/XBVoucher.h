//
//  XBVoucher.h
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBVouchers;
@interface XBVoucher : XBModel
@property (assign, nonatomic) NSInteger  allRow;
@property (assign, nonatomic) NSInteger  currentPage;
@property (assign, nonatomic) NSInteger  totalPage;
@property (strong, nonatomic) NSArray<XBVouchers *> *vouchers;
@end
