//
//  XBBookOrderHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/8/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBBookOrderHeaderView.h"
@interface XBBookOrderHeaderView()
/** 顶部分割线 */
@property (strong, nonatomic) UIView  *topSeparatorView;
/** 底部分割线 */
@property (strong, nonatomic) UIView  *bottomSeparatorView;
@end
@implementation XBBookOrderHeaderView

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
    self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-order-book-date"];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#6F6F6F"];
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:self.titleLabel];
    
    self.detailLabel = [UILabel new];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#6F6F6F"];
    self.detailLabel.font = [UIFont systemFontOfSize:14.f];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:self.detailLabel];
    
    
    self.topSeparatorView = [UIView new];
    self.topSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#BCBAC1"];
    [self addSubview:self.topSeparatorView];
    
    self.bottomSeparatorView = [UIView new];
    self.bottomSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#BCBAC1"];
    [self addSubview:self.bottomSeparatorView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kSpace * 1.5);
    }];
    
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kSpace * 1.5);
    }];
    
    [self.topSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(0.7f);
    }];
    
    [self.bottomSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.7f);
    }];
}

@end
