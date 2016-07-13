//
//  XBDestinationAllHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDestinationAllHeaderView.h"

@implementation XBDestinationAllHeaderView
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
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#B9B9B9"];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(0);
    }];
}

@end
