//
//  XBHomeHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/7/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kSpace 10.f
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
    self.leftLabel.text = @"附近";
    self.leftLabel.textColor = [UIColor colorWithHexString:@"#292929"];
    self.leftLabel.font = [UIFont systemFontOfSize:18.f];
    [self addSubview:self.leftLabel];
    
    self.rightLabel = [UILabel new];
    self.rightLabel.text = @"澳门";
    self.rightLabel.textColor = [UIColor colorWithHexString:@"#ADAEAD"];
    self.rightLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:self.rightLabel];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [self.rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kSpace * 2);
        make.bottom.equalTo(self.leftLabel);
    }];
}

@end
