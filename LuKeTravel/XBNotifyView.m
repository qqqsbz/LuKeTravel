//
//  XBNotifyView.m
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 5.f

#import "XBNotifyView.h"

@implementation XBNotifyView

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
    self.imageView = [UIImageView new];
    self.imageView.image = [UIImage imageNamed:@"activity_lang"];
    [self addSubview:self.imageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"时长";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#BBBAB9"];
    [self addSubview:self.titleLabel];
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.text = @"1-3.5小时";
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.font = [UIFont systemFontOfSize:13.5f];
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"#404040"];
    [self addSubview:self.subTitleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kSpace);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.bottom).offset(kSpace * 2.f);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.bottom).offset(kSpace * 0.7);
        make.bottom.equalTo(self);
    }];
}

@end
