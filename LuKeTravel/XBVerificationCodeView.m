//
//  XBVerificationCodeView.m
//  LuKeTravel
//
//  Created by coder on 16/8/4.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBVerificationCodeView.h"
#import "NSString+Util.h"
@interface XBVerificationCodeView() <UITextFieldDelegate>
/** 主界面 */
@property (strong, nonatomic) UIView        *contentView;

/** 标题*/
@property (strong, nonatomic) UILabel       *titleLabel;

/** 详细说明 */
@property (strong, nonatomic) UILabel       *textLabel;

/** 提示 */
@property (strong, nonatomic) UILabel       *messageLabel;

/** 文本输入框 */
@property (strong, nonatomic) UITextField   *textField;

/** 发送按钮 */
@property (strong, nonatomic) UIButton      *sendButton;

/** 验证码错误主页面 */
@property (strong, nonatomic) UIView        *errorView;

/** 标题 */
@property (strong, nonatomic) UILabel       *errorTitleLabel;

/** 详细说明 */
@property (strong, nonatomic) UILabel      *errorTextLabel;

/** 重试按钮 */
@property (strong, nonatomic) UIButton      *tryAgainButton;

/** 定时器 */
@property (strong, nonatomic) NSTimer       *timer;

/** 计时的秒数 */
@property (assign, nonatomic) NSInteger  duration;

/**是否重新发送验证码 */
@property (assign, nonatomic, getter=isResendCode) BOOL resendCode;

@end
@implementation XBVerificationCodeView

- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.duration = 60;
    
    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)]];
    
    self.errorView = [UIView new];
    self.errorView.hidden = YES;
    self.errorView.backgroundColor = [UIColor whiteColor];
    self.errorView.layer.masksToBounds = YES;
    self.errorView.layer.cornerRadius  = 8.f;
    [self addSubview:self.errorView];
    
    self.errorTitleLabel = [UILabel new];
    self.errorTitleLabel.font = [UIFont systemFontOfSize:24.f];
    self.errorTitleLabel.text = [XBLanguageControl localizedStringForKey:@"verification-code-error-title"];
    self.errorTitleLabel.textColor = [UIColor blackColor];
    [self.errorView addSubview:self.errorTitleLabel];
    
    self.errorTextLabel = [UILabel new];
    self.errorTextLabel.numberOfLines = 0;
    self.errorTextLabel.text = [XBLanguageControl localizedStringForKey:@"verification-code-error-text"];
    self.errorTextLabel.font = [UIFont systemFontOfSize:14.f];
    self.errorTextLabel.textColor = [UIColor colorWithHexString:@"#595959"];
    [self.errorView addSubview:self.errorTextLabel];
    
    self.tryAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tryAgainButton.layer.masksToBounds = YES;
    self.tryAgainButton.layer.cornerRadius  = 5.f;
    [self.tryAgainButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.tryAgainButton setTitle:[XBLanguageControl localizedStringForKey:@"verification-code-error-try"] forState:UIControlStateNormal];
    [self.tryAgainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tryAgainButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.tryAgainButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
    [self.tryAgainButton addTarget:self action:@selector(tryAgainAction) forControlEvents:UIControlEventTouchUpInside];
    [self.errorView addSubview:self.tryAgainButton];
    
    /*****************************输入验证码***************************************/
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius  = 8.f;
    [self addSubview:self.contentView];
    
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:24.f];
    self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"verification-code-title"];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.textLabel = [UILabel new];
    self.textLabel.numberOfLines = 0;
    self.textLabel.text = [XBLanguageControl localizedStringForKey:@"verification-code-text"];
    self.textLabel.font = [UIFont systemFontOfSize:14.f];
    self.textLabel.textColor = [UIColor colorWithHexString:@"#595959"];
    [self.contentView addSubview:self.textLabel];
    
    self.messageLabel = [UILabel new];
    self.messageLabel.text = [XBLanguageControl localizedStringForKey:@"verification-code-message"];
    self.messageLabel.font = [UIFont systemFontOfSize:14.f];
    self.messageLabel.textColor = [UIColor colorWithHexString:@"#C1C1C1"];
    [self.contentView addSubview:self.messageLabel];

    self.textField = [UITextField new];
    self.textField.delegate = self;
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius  = 5.f;
    self.textField.font = [UIFont boldSystemFontOfSize:22.f];
    self.textField.textColor   = [UIColor colorWithHexString:kDefaultColorHex];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"verification-code-input"] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#C1C1C1"]}];
    [self.contentView addSubview:self.textField];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius  = 5.f;
    [self.sendButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.sendButton setTitle:[NSString stringWithFormat:@"%@ (%d)",[XBLanguageControl localizedStringForKey:@"verification-code-resend"],self.duration] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.sendButton setBackgroundColor:[UIColor colorWithHexString:@"#CCCCCC"]];
    [self.sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sendButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.errorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace);
        make.top.equalTo(self.top).offset(kSpace * 9.5f);
        make.right.equalTo(self).offset(-kSpace);
        make.height.mas_equalTo(170);
    }];
    
    [self.errorTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.errorView);
        make.top.equalTo(self.errorView).offset(kSpace * 2);
    }];
    
    [self.errorTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.errorView).offset(kSpace);
        make.right.equalTo(self.errorView).offset(-kSpace);
        make.top.equalTo(self.errorTitleLabel.bottom).offset(kSpace * 1.5);
    }];
    
    [self.tryAgainButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.errorTextLabel);
        make.left.equalTo(self.errorTextLabel);
        make.top.equalTo(self.errorTextLabel.bottom).offset(kSpace);
        make.height.mas_equalTo(45.f);
    }];

    
    /********************************输入验证码**********************************/
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace);
        make.bottom.equalTo(self.top);
        make.right.equalTo(self).offset(-kSpace);
        make.height.mas_equalTo(280);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(kSpace * 2);
    }];
    
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kSpace * 3);
        make.right.equalTo(self.contentView).offset(-kSpace * 3);
        make.top.equalTo(self.titleLabel.bottom).offset(kSpace * 2);
    }];
    
    [self.messageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.textLabel.bottom);
    }];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kSpace * 1.5);
        make.right.equalTo(self.contentView).offset(-kSpace * 1.5);
        make.top.equalTo(self.messageLabel.bottom).offset(kSpace * 2.5f);
        make.height.mas_equalTo(45.f);
    }];
    
    [self.sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textField);
        make.left.equalTo(self.textField);
        make.top.equalTo(self.textField.bottom).offset(kSpace * 2);
        make.height.equalTo(self.textField);
    }];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    
    NSString *text = [[NSString stringWithFormat:@"%@%@",textField.text,string] clearBlack];
    
    text = [string isEqualToString:@""] ? [text substringToIndex:range.location] : text;
    
    if (text.length > 6) return NO;
    
    if (text.length == 0 || text.length == 6) {
        
        self.sendButton.enabled = YES;
        
        [self.sendButton setTitle:text.length == 0 ? [XBLanguageControl localizedStringForKey:@"verification-code-resend"] : [XBLanguageControl localizedStringForKey:@"verification-code-send"] forState:UIControlStateNormal];
        
        [self.sendButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
        
    } else {
        
        self.sendButton.enabled = NO;
        
        [self.sendButton setBackgroundColor:[UIColor colorWithHexString:@"#CCCCCC"]];
    }
    
    
    return text.length <= 6;
}


- (void)toggle
{
    
    if (self.isResendCode) {
        
        [self restartTimer];
        
        return;
    }
    
    [self.contentView layoutIfNeeded];
    
    if (self.alpha == 0) {
        
        self.duration = 60;
        
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.alpha = 1.f;
            
            self.contentView.xb_y = kSpace * 4;
            
        } completion:^(BOOL finished) {
            
            self.contentView.xb_y = kSpace * 4;
            
        }];
        
    } else {
        
        [UIView animateWithDuration:0.45 delay:0.1 usingSpringWithDamping:0.85 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.contentView.xb_y = self.xb_height;
            
            self.alpha = 0.f;
            
        } completion:^(BOOL finished) {
            
            //销毁定时器
            [self.timer invalidate];
            
            self.timer = nil;
            
            self.resendCode = NO;
            
            self.textField.text = @"";
            
            [self.sendButton setTitle:[NSString stringWithFormat:@"%@ (%d)",[XBLanguageControl localizedStringForKey:@"verification-code-resend"],self.duration] forState:UIControlStateNormal];
            
            [self.sendButton setBackgroundColor:[UIColor colorWithHexString:@"#CCCCCC"]];
            
            self.contentView.xb_y -= (self.contentView.xb_height + self.xb_height);
            
            [self endEditing:YES];
            
        }];

        
    }
}

- (void)sendAction
{
    NSString *text = [self.textField.text clearBlack];
    
    if (text.length == 0 && [self.delegate respondsToSelector:@selector(verificationCodeView:didSelectResendToPhoneNumber:)]) {
        
        self.resendCode = YES;
        
        [self.delegate verificationCodeView:self didSelectResendToPhoneNumber:self.phoneNumber];
        
    } else if (text.length == 6 && [self.delegate respondsToSelector:@selector(verificationCodeView:didSelecSendWithPhoneNumber:code:)]) {
        
        [self.delegate verificationCodeView:self didSelecSendWithPhoneNumber:self.phoneNumber code:text];
        
    }
    
}

- (void)timerAction
{
    if (self.duration > 1) {
        
        self.duration --;
        
        NSString *text = [NSString stringWithFormat:@"%@ (%02d)",[XBLanguageControl localizedStringForKey:@"verification-code-resend"],self.duration];
        
        self.sendButton.enabled = NO;
        
        [self.sendButton setTitle:text forState:UIControlStateNormal];
        
        [self.sendButton setBackgroundColor:[UIColor colorWithHexString:@"#CCCCCC"]];
        
    } else {
        
        self.sendButton.enabled = YES;
        
        [self.sendButton setTitle:[XBLanguageControl localizedStringForKey:@"verification-code-resend"] forState:UIControlStateNormal];
        
        
        [self.sendButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
        
        //关闭定时器
        [self.timer setFireDate:[NSDate distantFuture]];
        
    }
    
}

/** 重启定时器 */
- (void)restartTimer
{
    self.duration = 60.f;
    
    //开启定时器
    [self.timer setFireDate:[NSDate distantPast]];
    
    self.resendCode = NO;
}


- (void)showCodeError
{
    self.contentView.hidden = YES;
    
    self.errorView.hidden = NO;
}

- (void)tryAgainAction
{
    self.errorView.hidden = YES;
    
    self.contentView.hidden = NO;
    
    self.contentView.xb_y = kSpace * 4;
}

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = phoneNumber;
    
    self.textLabel.text = [NSString stringWithFormat:@"%@, +%@",[XBLanguageControl localizedStringForKey:@"verification-code-text"],phoneNumber];
}

@end
