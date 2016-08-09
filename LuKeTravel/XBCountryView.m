//
//  XBCountryView.m
//  LuKeTravel
//
//  Created by coder on 16/8/4.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCountryView.h"

@implementation XBCountryView

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
    self.imageView.image = [UIImage imageNamed:@"scan_done"];
    [self addSubview:self.imageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:self.titleLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kSpace * 2);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(20);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.imageView.right).offset(kSpace * 0.5);
    }];
}

@end
