//
//  XBDesinationFooterView.m
//  LuKeTravel
//
//  Created by coder on 16/7/11.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#import "XBDesinationFooterView.h"
@interface XBDesinationFooterView()
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) UIButton  *viewAllButton;
@property (copy  , nonatomic) dispatch_block_t  block;
@end
@implementation XBDesinationFooterView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title didSelectedBlock:(dispatch_block_t)block
{
    if (self = [super initWithFrame:frame]) {
        _block = block;
        _title = title;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.viewAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.viewAllButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.viewAllButton.layer.masksToBounds = YES;
    self.viewAllButton.layer.cornerRadius  = 6.f;
    self.viewAllButton.titleLabel.textColor = [UIColor whiteColor];
    self.viewAllButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.viewAllButton setTitle:self.title forState:UIControlStateNormal];
    [self.viewAllButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
    [self.viewAllButton addTarget:self action:@selector(viewAll) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.viewAllButton];
}

- (void)viewAll
{
    if (self.block) {
        self.block();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewAllButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace);
        make.right.equalTo(self).offset(-kSpace);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(CGRectGetHeight(self.frame) * 0.46f);
    }];
}

@end
