//
//  XBVerificationCodeView.h
//  LuKeTravel
//
//  Created by coder on 16/8/4.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBVerificationCodeView;
@protocol XBVerificationCodeViewDelegate <NSObject>

- (void)verificationCodeView:(XBVerificationCodeView *)verificationCodeView didSelectResendToPhoneNumber:(NSString *)phoneNumber;

- (void)verificationCodeView:(XBVerificationCodeView *)verificationCodeView didSelecSendWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code;

@end


@interface XBVerificationCodeView : UIView

/** 号码 */
@property (strong, nonatomic) NSString *phoneNumber;

/** 代理 */
@property (weak, nonatomic) id<XBVerificationCodeViewDelegate> delegate;


/** 显示与隐藏切换 */
- (void)toggle;

/** 显示验证码错误页面 */
- (void)showCodeError;

@end