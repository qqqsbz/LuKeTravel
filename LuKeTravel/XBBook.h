//
//  XBBook.h
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBModel.h"
@class XBCoupons;
@class XBPayContact;
@class XBBookTicket;
@class XBWeiXinParams;

@interface XBBook : XBModel
//@property (assign, nonatomic) BOOL          smsOpen;
@property (strong, nonatomic) NSString      *alipayString;
@property (assign, nonatomic) NSInteger     applicableCredits;
@property (strong, nonatomic) NSString      *couponDiscount;
@property (strong, nonatomic) NSString      *couponUsed;
@property (strong, nonatomic) NSString      *creditDiscount;
@property (assign, nonatomic) NSInteger     creditUseAmount;
@property (strong, nonatomic) NSString      *currency;
@property (assign, nonatomic) BOOL          mobileVerifyStatus;
@property (strong, nonatomic) NSString      *orderGuid;
@property (strong, nonatomic) NSString      *orderRefid;
@property (assign, nonatomic) NSInteger     paymentChannel;
@property (assign, nonatomic) NSInteger     paymentStatus;
@property (assign, nonatomic) NSInteger     totalCredits;
@property (strong, nonatomic) NSString      *totalCreditsCash;
@property (strong, nonatomic) NSString      *totalPrice;
@property (strong, nonatomic) NSString      *totalSaving;
@property (strong, nonatomic) NSString      *userPayCurrency;
@property (strong, nonatomic) NSString      *userPayTotalPrice;
@property (strong, nonatomic) XBWeiXinParams *weixinParams;

@property (strong, nonatomic) XBPayContact  *payContact;
@property (strong, nonatomic) NSArray<XBBookTicket *>  *bookTickets;
@property (strong, nonatomic) NSArray<XBCoupons *>      *coupons;
@property (strong, nonatomic) NSArray<XBCoupons *>      *disableCoupons;
@end
