//
//  XBOrderConfirmNavigationBar.m
//  LuKeTravel
//
//  Created by coder on 16/8/16.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderTicketNavigationBar.h"
@interface XBOrderTicketNavigationBar()
/** 返回 */
@property (strong, nonatomic) UIButton *backButton;
/** 返回代码块 */
@property (copy, nonatomic) dispatch_block_t  popBlock;
@end
@implementation XBOrderTicketNavigationBar

- (instancetype)initWithPopBlock:(dispatch_block_t)popBlock
{
    if (self = [super init]) {
        _popBlock = popBlock;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame popBlock:(dispatch_block_t)popBlock
{
    if (self = [super initWithFrame:frame]) {
        _popBlock = popBlock;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#313131"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self addSubview:self.titleLabel];
    
    self.markerLabel = [UILabel new];
    self.markerLabel.font = [UIFont systemFontOfSize:15.f];
    self.markerLabel.textColor = [UIColor colorWithHexString:@"#979797"];
    [self addSubview:self.markerLabel];
    
    self.sellLabel = [UILabel new];
    self.sellLabel.textColor = [UIColor colorWithHexString:@"#313131"];
    self.sellLabel.font = [UIFont boldSystemFontOfSize:20.f];
    [self addSubview:self.sellLabel];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.font = [UIFont systemFontOfSize:14.f];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
    [self addSubview:self.dateLabel];
    
    self.countLabel = [UILabel new];
    self.countLabel.numberOfLines = 1;
    self.countLabel.font = [UIFont systemFontOfSize:14.f];
    self.countLabel.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
    [self.countLabel sizeToFit];
    [self addSubview:self.countLabel];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.backButton setTitle:[XBLanguageControl localizedStringForKey:@"activity-order-back"] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor colorWithHexString:kDefaultColorHex] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.markerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel).offset(-kSpace * 0.5);
        make.right.equalTo(self).offset(-kSpace);
    }];
    
    [self.sellLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.markerLabel);
        make.top.equalTo(self.markerLabel.bottom).offset(kSpace * 0.5);
        make.width.mas_greaterThanOrEqualTo(50.f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace);
        make.top.equalTo(self).offset(kSpace * 1.5);
        make.right.lessThanOrEqualTo(self.sellLabel.left).offset(-kSpace * 2);
    }];
    
    [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(kSpace * 0.4);
    }];
    
    [self.countLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel);
        make.top.equalTo(self.dateLabel.bottom).offset(kSpace * 0.5);
        make.right.equalTo(self).offset(-kSpace * 0.5);
    }];
    
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kSpace * 0.5);
    }];
    
    
}

- (void)popAction
{
    if (self.popBlock) {
        
        self.popBlock();
    }
}

@end
