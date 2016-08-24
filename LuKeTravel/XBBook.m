//
//  XBBook.m
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBBook.h"
#import "XBCoupons.h"
#import "XBPayContact.h"
#import "XBBookTicket.h"
#import "XBWeiXinParams.h"
@implementation XBBook
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
//             @"smsOpen":@"_sms_open",
             @"alipayString":@"alipay_string",
             @"applicableCredits":@"applicable_credits",
             @"couponDiscount":@"coupon_discount",
             @"couponUsed":@"coupon_used",
             @"creditDiscount":@"credit_discount",
             @"creditUseAmount":@"credit_use_amount",
             @"mobileVerifyStatus":@"mobile_verify_status",
             @"orderGuid":@"order_guid",
             @"orderRefid":@"order_refid",
             @"modelId":@"id",
             @"paymentChannel":@"payment_channel",
             @"paymentStatus":@"payment_status",
             @"totalCredits":@"total_credits",
             @"totalCreditsCash":@"total_credits_cash",
             @"totalPrice":@"total_price",
             @"totalSaving":@"total_saving",
             @"userPayCurrency":@"user_pay_currency",
             @"userPayTotalPrice":@"user_pay_total_price",
             @"weixinParams":@"weixin_params",
             @"payContact":@"pay_contact",
             @"bookTickets":@"book_tickets"
             };
}


+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{
             @"coupons":[XBCoupons class],
             @"disableCoupons":[XBCoupons class],
             @"payContact":[XBPayContact class],
             @"bookTickets":[XBBookTicket class],
             @"weixinParams":[XBWeiXinParams class]
             };
}

+ (NSValueTransformer *)couponsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBCoupons class]];
}

+ (NSValueTransformer *)disableCouponsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBCoupons class]];
}

+ (NSValueTransformer *)bookTicketsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBBookTicket class]];
}

+ (NSValueTransformer *)payContactJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBPayContact class]];
}

+ (NSValueTransformer *)weixinParamsJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XBWeiXinParams class]];
}

@end
