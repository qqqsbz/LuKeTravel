//
//  XBOrderEffectView.m
//  LuKeTravel
//
//  Created by coder on 16/8/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderEffectView.h"
@interface XBOrderEffectView()
/** 毛玻璃效果 */
@property (strong, nonatomic) UIVisualEffectView *effectView;
/** pop代码块 */
@property (copy  , nonatomic) dispatch_block_t  dismissBlock;
@end
@implementation XBOrderEffectView

- (instancetype)initWithDismissBlock:(dispatch_block_t)dismissBlock
{
    if (self = [super init]) {
        
        _dismissBlock = dismissBlock;
        
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame dismissBlock:(dispatch_block_t)dismissBlock
{
    if (self = [super initWithFrame:frame]) {
        
        _dismissBlock = dismissBlock;
        
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    [self addSubview:self.effectView];
    
    
    self.nameLabel = [UILabel new];
    self.nameLabel.userInteractionEnabled = YES;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:24.f];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)]];
    [self addSubview:self.nameLabel];
    
    self.subNameLabel = [UILabel new];
    self.subNameLabel.textAlignment = NSTextAlignmentCenter;
    self.subNameLabel.font = [UIFont systemFontOfSize:13.f];
    self.subNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.subNameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.subNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)]];
    [self addSubview:self.subNameLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.effectView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kSpace * 3);
        make.left.equalTo(self).offset(kSpace * 0.5);
        make.right.equalTo(self).offset(-kSpace * 0.5);
    }];
    
    [self.subNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(kSpace * 0.3);
        make.left.equalTo(self).offset(kSpace * 0.5);
        make.right.equalTo(self).offset(-kSpace * 0.5);
        make.height.mas_equalTo(20);
    }];
}

- (void)dismissAction
{
    if (self.dismissBlock) {
        
        self.dismissBlock();
    }
}


@end
