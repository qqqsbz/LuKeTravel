//
//  XBLoginTipView.m
//  LuKeTravel
//
//  Created by coder on 16/7/27.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f

#import "XBLoginTipView.h"
@interface XBLoginTipView()
@property (strong, nonatomic) UIImageView   *loginPicImageView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UILabel       *subTitelLabel;
@property (strong, nonatomic) UIButton      *loginButton;
@property (copy  , nonatomic) dispatch_block_t  loginBlock;
@end
@implementation XBLoginTipView

- (instancetype)initWithLoginBlock:(dispatch_block_t)block
{
    if (self = [super init]) {
        _loginBlock = block;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame loginBlock:(dispatch_block_t)block
{
    if (self = [super initWithFrame:frame]) {
        _loginBlock = block;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.loginPicImageView = [UIImageView new];
    self.loginPicImageView.image = [UIImage imageNamed:@"booking_login_pic"];
    [self addSubview:self.loginPicImageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"order-title"];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#515152"];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:27.f];
    [self addSubview:self.titleLabel];
    
    self.subTitelLabel = [UILabel new];
    self.subTitelLabel.numberOfLines = 0;
    self.subTitelLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitelLabel.text = [XBLanguageControl localizedStringForKey:@"order-login-tip"];
    self.subTitelLabel.textColor = [UIColor colorWithHexString:@"#A5A5A5"];
    self.subTitelLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.subTitelLabel];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius  = 5.f;
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginButton setTitle:[XBLanguageControl localizedStringForKey:@"order-login"] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
    [self.loginButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loginButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.loginPicImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kSpace * 5);
        make.left.equalTo(self).offset(kSpace * 5);
        make.right.equalTo(self).offset(-kSpace * 5);
        make.bottom.equalTo(self.centerY).offset(kSpace * 3.5);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.loginPicImageView.bottom).offset(kSpace * 2);
    }];
    
    [self.subTitelLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(kSpace * 0.7);
        make.left.equalTo(self).offset(kSpace * 3);
        make.right.equalTo(self).offset(-kSpace * 3);
    }];
    
    [self.loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel).offset(-kSpace * 1.5);
        make.right.equalTo(self.titleLabel).offset(kSpace * 1.5);
        make.top.equalTo(self.subTitelLabel.bottom).offset(kSpace * 1.5);
        make.height.mas_equalTo(42.f);
    }];
}

- (void)reloadLanguageConfig
{
    self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"order-title"];
    
    self.subTitelLabel.text = [XBLanguageControl localizedStringForKey:@"order-login-tip"];
    
    [self.loginButton setTitle:[XBLanguageControl localizedStringForKey:@"order-login"] forState:UIControlStateNormal];

}

- (void)clickAction
{
    if (self.loginBlock) {
        
        self.loginBlock();
        
    }
}

@end
