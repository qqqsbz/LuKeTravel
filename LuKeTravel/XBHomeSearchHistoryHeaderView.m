//
//  XBHomeSearchHistoryHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/7/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeSearchHistoryHeaderView.h"
@interface XBHomeSearchHistoryHeaderView()
/** 标题 */
@property (strong, nonatomic) UILabel  *titleLabel;
/** 清除 */
@property (strong, nonatomic) UIButton *clearButton;
/** 回调 */
@property (copy  , nonatomic) dispatch_block_t  clearBlock;
@end
@implementation XBHomeSearchHistoryHeaderView

- (instancetype)initWithClearBlock:(dispatch_block_t)clearBlock
{
    if (self = [super init]) {
        _clearBlock = clearBlock;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame clearBlock:(dispatch_block_t)clearBlock
{
    if (self = [super initWithFrame:frame]) {
        _clearBlock = clearBlock;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.titleLabel = [UILabel new];
    self.titleLabel.text = NSLocalizedString(@"search-history-title", @"search-history-title");
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#A1A1A1"];
    [self addSubview:self.titleLabel];
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setTitle:NSLocalizedString(@"search-history-clear", @"search-history-clear") forState:UIControlStateNormal];
    [self.clearButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self.clearButton setTitleColor:[UIColor colorWithHexString:@"#A1A1A1"] forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(17.f);
    }];
    
    [self.clearButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15.f);
    }];
    
}

- (void)clearAction
{
    if (self.clearBlock) {
        self.clearBlock();
    }
}

@end
