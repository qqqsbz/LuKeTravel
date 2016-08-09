//
//  XBCoupon.h
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBCoupons;
@interface XBCoupon : XBModel
@property (assign, nonatomic) NSInteger  usedCouponCounts;
@property (assign, nonatomic) NSInteger  validCouponCounts;
@property (strong, nonatomic) NSArray<XBCoupons *> *coupons;
@end
