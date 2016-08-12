//
//  XBOrderNavigationBar.m
//  LuKeTravel
//
//  Created by coder on 16/8/10.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderNavigationBar.h"
@interface XBOrderNavigationBar()
/** 返回按钮 */
@property (strong, nonatomic) UIButton *backButton;
/** 标题 */
@property (strong, nonatomic) UILabel  *titleLabel;
/** 分割线 */
@property (strong, nonatomic) UIView   *separatorView;
/** 返回回调 */
@property (copy , nonatomic) dispatch_block_t  backBlock;
@end
@implementation XBOrderNavigationBar

- (instancetype)initWithBackBlock:(dispatch_block_t)block
{
    if (self = [super init]) {
        _backBlock = block;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame backBlock:(dispatch_block_t)block
{
    if (self = [super initWithFrame:frame]) {
        _backBlock = block;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitleColor:[UIColor colorWithHexString:kDefaultColorHex] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"选择日期";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#4F4F4F"];
    [self addSubview:self.titleLabel];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#BCBAC1"];
    [self addSubview:self.separatorView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kSpace * 0.5);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.7);
    }];
}

- (void)backAction
{
    if (self.backBlock) {
        
        self.backBlock();
        
    }
}

- (void)setBackText:(NSString *)backText
{
    [self.backButton setTitle:backText forState:UIControlStateNormal];
}

- (void)setTitleText:(NSString *)titleText
{
    self.titleLabel.text = titleText;
}

@end
