//
//  XBCouponHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCouponHeaderView.h"
@interface XBCouponHeaderView() <UITextFieldDelegate>
/** 可用 */
@property (strong, nonatomic) UILabel       *availableLabel;
/** 不可用 */
@property (strong, nonatomic) UILabel       *unavailableLable;
/** 内容view */
@property (strong, nonatomic) UIView        *contentView;
/** 优惠券输入框 */
@property (strong, nonatomic) UITextField   *textField;
/** 兑换按钮 */
@property (strong, nonatomic) UIButton      *exchangeButton;
/** 回调 */
@property (copy  , nonatomic) ExchangeBlock exchangeBlock;
@end
@implementation XBCouponHeaderView


- (instancetype)initWithExchangeBlock:(ExchangeBlock)block
{
    if (self = [super init]) {
        _exchangeBlock = block;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame exchangeBlock:(ExchangeBlock)block
{
    if (self = [super initWithFrame:frame]) {
        _exchangeBlock = block;
        [self initialization];
    }
    return self;
}


- (void)initialization
{
    self.availableLabel = [UILabel new];
    self.availableLabel.text = [XBLanguageControl localizedStringForKey:@"promotions-coupons-header-available"];
    self.availableLabel.font = [UIFont boldSystemFontOfSize:13.f];
    self.availableLabel.textColor = [UIColor blackColor];
    [self addSubview:self.availableLabel];
    
    self.unavailableLable = [UILabel new];
    self.unavailableLable.text = [XBLanguageControl localizedStringForKey:@"promotions-coupons-header-unavailable"];
    self.unavailableLable.font = [UIFont boldSystemFontOfSize:13.f];
    self.unavailableLable.textColor = [UIColor blackColor];
    [self addSubview:self.unavailableLable];
    
    self.contentView = [UIView new];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius  = 5.f;
    self.contentView.layer.borderColor   = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    self.contentView.layer.borderWidth   = 1.f;
    [self addSubview:self.contentView];
    
    self.textField = [UITextField new];
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.tintColor = [UIColor colorWithHexString:kDefaultColorHex];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[XBLanguageControl localizedStringForKey:@"promotions-coupons-header-placeholder"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#C4C5CB"]}];
    [self.contentView addSubview:self.textField];
    
    self.exchangeButton = [UIButton new];
    [self.exchangeButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self.exchangeButton setTitle:[XBLanguageControl localizedStringForKey:@"promotions-coupons-header-exchange"] forState:UIControlStateNormal];
    [self.exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.exchangeButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
    [self.exchangeButton addTarget:self action:@selector(exchangeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.exchangeButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.availableLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 1.3);
        make.top.equalTo(self).offset(kSpace * 1.85);
    }];
    
    [self.unavailableLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.availableLabel);
        make.left.equalTo(self.availableLabel.right).offset(kSpace * 0.5);
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.availableLabel.bottom).offset(kSpace * 2);
        make.left.equalTo(self.availableLabel);
        make.right.equalTo(self).offset(-kSpace * 1.5);
        make.height.mas_greaterThanOrEqualTo(40.f);
        make.bottom.equalTo(self).offset(-kSpace);
    }];
    
    [self.exchangeButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(80.f);
    }];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kSpace * 2);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.exchangeButton.left).offset(-kSpace * 0.8);
        make.bottom.equalTo(self.contentView);
    }];
    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        [self exchangeAction];
        
        return NO;
    }
    
    return YES;
}

- (void)exchangeAction
{
    if (self.exchangeBlock) {
        
        [self.textField resignFirstResponder];
        
        self.exchangeBlock(self.textField.text);
    }
}

- (void)setAvailable:(NSInteger)available
{
    self.availableLabel.text = [NSString stringWithFormat:@"%@ %@",[XBLanguageControl localizedStringForKey:@"promotions-coupons-header-available"],[NSIntegerFormatter formatToNSString:available]];
}

- (void)setUnavailable:(NSInteger)unavailable
{
    self.unavailableLable.text = [NSString stringWithFormat:@"%@ %@",[XBLanguageControl localizedStringForKey:@"promotions-coupons-header-unavailable"],[NSIntegerFormatter formatToNSString:unavailable]];
}

- (void)setCode:(NSString *)code
{
    self.textField.text = code;
}

@end
