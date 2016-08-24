//
//  XBGuideContentView.m
//  LuKeTravel
//
//  Created by coder on 16/8/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBGuideContentView.h"
@interface XBGuideContentView()
/** 跳过view */
@property (strong, nonatomic) UIView *jumpView;
/** 跳过文字 */
@property (strong, nonatomic) UILabel *jumpLabel;
/** 跳过图标 */
@property (strong, nonatomic) UIImageView *jumpImageView;
/** 跳过代码块 */
@property (copy  , nonatomic) dispatch_block_t  jumpBlock;
@end
@implementation XBGuideContentView

- (instancetype)initWithJumpBlock:(dispatch_block_t)jumpBlock
{
    if (self = [super init]) {
        _jumpBlock = jumpBlock;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame jumpBlock:(dispatch_block_t)jumpBlock
{
    if (self = [super initWithFrame:frame]) {
        _jumpBlock = jumpBlock;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.imageView = [UIImageView new];
    
    self.imageView.clipsToBounds = YES;
    
    [self addSubview:self.imageView];
    
    self.jumpView = [UIView new];
    
    self.jumpView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    self.jumpView.layer.masksToBounds = YES;
    
    self.jumpView.layer.cornerRadius  = 16.f;
    
    [self.jumpView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAction)]];
    
    [self addSubview:self.jumpView];
    
    self.jumpLabel = [UILabel new];
    
    self.jumpLabel.font = [UIFont systemFontOfSize:13.f];
    
    self.jumpLabel.textColor = [UIColor whiteColor];
    
    self.jumpLabel.text = [XBLanguageControl localizedStringForKey:@"guide-jump"];
    
    [self.jumpView addSubview:self.jumpLabel];
    
    self.jumpImageView = [UIImageView new];
    
    self.jumpImageView.image = [UIImage imageNamed:@"guide_arrow"];
    
    [self.jumpView addSubview:self.jumpImageView];
    
    self.contentLabel = [UILabel new];
    
    self.contentLabel.textColor = [UIColor whiteColor];
    
    self.contentLabel.font = [UIFont systemFontOfSize:14.f];
    
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    
    self.contentLabel.numberOfLines = 0;
    
    [self addSubview:self.contentLabel];
    
    
    self.titleLabel = [UILabel new];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:25.f];
    
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.jumpView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kSpace * 2);
        make.right.equalTo(self).offset(-kSpace * 2);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(70);
    }];
    
    [self.jumpLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jumpView);
        make.left.equalTo(self.jumpView).offset(kSpace * 1.5);
    }];
    
    [self.jumpImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jumpLabel.right).offset(kSpace * 0.5);
        make.centerY.equalTo(self.jumpView);
    }];
    
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 1.7);
        make.right.equalTo(self).offset(-kSpace * 1.7);
        make.bottom.equalTo(self).offset(-kSpace * 8.5);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.contentLabel.top).offset(-kSpace);
    }];
}

- (void)setHideJump:(BOOL)hideJump
{
    _hideJump = hideJump;
    
    self.jumpView.hidden = hideJump;
}

- (void)jumpAction
{
    if (self.jumpBlock) {
        
        self.jumpBlock();
    }
}

@end
