//
//  XBOrderDetailToolBar.m
//  LuKeTravel
//
//  Created by coder on 16/8/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderDetailToolBar.h"
@interface XBOrderDetailToolBar()
/** 分割线 */
@property (strong, nonatomic) UIView *separatorView;
/** 按钮 */
@property (strong, nonatomic) UIButton *payButton;
/** 代码块 */
@property (copy  , nonatomic) dispatch_block_t  payBlock;
@end
@implementation XBOrderDetailToolBar

- (instancetype)initWithPayBlock:(dispatch_block_t)payBlock
{
    if (self = [super init]) {
        _payBlock = payBlock;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame payBlock:(dispatch_block_t)payBlock
{
    if (self = [super initWithFrame:frame]) {
        _payBlock = payBlock;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#BCBAC1"];
    [self addSubview:self.separatorView];
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.cornerRadius  = 6.f;
    [self.payButton setTitle:[XBLanguageControl localizedStringForKey:@"order-detail-pay"] forState:UIControlStateNormal];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.payButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
    [self.payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.payButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.payButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 1.5);
        make.right.equalTo(self).offset(-kSpace * 1.5);
        make.top.equalTo(self).offset(kSpace * 0.7);
        make.bottom.equalTo(self).offset(-kSpace * 0.7);
    }];
}

- (void)payAction
{
    if (self.payBlock) {
        
        self.payBlock();
    }
}

@end
