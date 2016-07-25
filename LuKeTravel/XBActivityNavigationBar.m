//
//  XBActivityNavigationBarView.m
//  LuKeTravel
//
//  Created by coder on 16/7/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBActivityNavigationBar.h"

@implementation XBActivityNavigationBar

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
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.font = [UIFont systemFontOfSize:16.5f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#696969"];
    [self addSubview:self.titleLabel];
    
    self.separatorView = [UIView new];
    self.separatorView.hidden = YES;
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#E0DFDD"];
    [self addSubview:self.separatorView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(80);
        make.right.equalTo(self).offset(-75);
        make.centerY.equalTo(self).offset(13);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.7f);
    }];
}

- (void)clickAction:(UIButton *)sender
{
    
}

@end
