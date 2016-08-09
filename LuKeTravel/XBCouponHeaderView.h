//
//  XBCouponHeaderView.h
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExchangeBlock)(NSString *code);
@interface XBCouponHeaderView : UIView

/** 可用个数 */
@property (assign, nonatomic) NSInteger  available;
/** 已用个数 */
@property (assign, nonatomic) NSInteger  unavailable;
/** 设置优惠券码 */
@property (strong, nonatomic) NSString   *code;

- (instancetype)initWithExchangeBlock:(ExchangeBlock)block;

- (instancetype)initWithFrame:(CGRect)frame exchangeBlock:(ExchangeBlock)block;

@end
