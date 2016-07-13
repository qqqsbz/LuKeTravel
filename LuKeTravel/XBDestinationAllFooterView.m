//
//  XBDestinationAllFooterView.m
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDestinationAllFooterView.h"

@implementation XBDestinationAllFooterView
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
    self.titleLabel.text = NSLocalizedString(@"destination-all-foot", @"destination-all-foot");
    self.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#B7B7B7"];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-5);
    }];
}
@end
