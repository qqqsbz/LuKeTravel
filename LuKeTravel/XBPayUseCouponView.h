//
//  XBPayUseCouponView.h
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBCoupons;
@class XBPayUseCouponView;

@protocol XBPayUseCouponViewDelegate <NSObject>

@optional
- (void)payUseCouponView:(XBPayUseCouponView *)payUseCouponView didSelectRedeemWithCode:(NSString *)code;

- (void)payUseCouponView:(XBPayUseCouponView *)payUseCouponView didSelectCouponWithCoupons:(XBCoupons *)coupons;

@end

@interface XBPayUseCouponView : UIView


/** 优惠券 */
@property (strong, nonatomic) NSArray<XBCoupons *> *coupons;

/** 代理 */
@property (weak, nonatomic) id<XBPayUseCouponViewDelegate> delegate;

/** 获取主要显示view */
- (UIView *)payUseContentView;

/** 显示与隐藏 */
- (void)toggle;

@end

