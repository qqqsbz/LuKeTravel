//
//  XBHomeHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/7/11.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeHeaderView.h"

@implementation XBHomeHeaderView

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
    self.leftLabel = [UILabel new];
    self.leftLabel.font = [UIFont systemFontOfSize:20.f];
    self.leftLabel.textColor = [UIColor colorWithHexString:@"#3E3D3D"];
    [self addSubview:self.leftLabel];
    
    self.rightLabel = [UILabel new];
    self.rightLabel.font = [UIFont systemFontOfSize:14.f];
    self.rightLabel.textColor = [UIColor colorWithHexString:@"#BDBDBD"];
    [self addSubview:self.rightLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    [self.rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self);
    }];
}

@end
