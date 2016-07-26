//
//  XBActivityToolBar.m
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f

#import "XBActivityToolBar.h"
@interface XBActivityToolBar()
@property (strong, nonatomic) UIView    *separatorView;
@property (strong, nonatomic) UIButton  *packageButton;
@property (copy  , nonatomic) SelectedBlock  selectedBlock;
@end
@implementation XBActivityToolBar

- (instancetype)initWithSelectedBlock:(SelectedBlock)block
{
    if (self = [super init]) {
        _selectedBlock = block;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame selectedBlock:(SelectedBlock)block
{
    if (self = [super initWithFrame:frame]) {
        _selectedBlock = block;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#E0DFDD"];
    [self addSubview:self.separatorView];
    
    self.packageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.packageButton.layer.masksToBounds = YES;
    self.packageButton.layer.cornerRadius  = 8.f;
    [self.packageButton setTitle:NSLocalizedString(@"activity-detail-package-normal", @"activity-detail-package-normal") forState:UIControlStateNormal];
    self.packageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.packageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.packageButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
    [self.packageButton addTarget:self action:@selector(packageAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.packageButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.7f);
    }];
    
    [self.packageButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 3);
        make.right.equalTo(self).offset(-kSpace * 3);
        make.centerY.equalTo(self);
    }];
}

- (void)packageAction
{
    if (self.selectedBlock) {
        self.selectedBlock(self.packageButton);
    }
}

@end
