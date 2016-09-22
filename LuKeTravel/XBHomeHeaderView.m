//
//  XBHomeHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/7/11.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeHeaderView.h"
@interface XBHomeHeaderView()
@property (copy, nonatomic) dispatch_block_t  viewAllBlock;
@end
@implementation XBHomeHeaderView

- (instancetype)initWithViewAllBlock:(dispatch_block_t)block
{
    if (self = [super init]) {
        _viewAllBlock = block;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame viewAllBlock:(dispatch_block_t)block
{
    if (self = [super initWithFrame:frame]) {
        _viewAllBlock = block;
        [self initialization];
    }
    return self;
}

- (void)initialization
{    
    self.leftLabel = [UILabel new];
    self.leftLabel.font = [UIFont systemFontOfSize:20.f];
    self.leftLabel.textColor = [UIColor colorWithHexString:@"#3E3D3D"];
    [self addSubview:self.leftLabel];
    
    self.rightLabel = [UILabel new];
    self.rightLabel.userInteractionEnabled = YES;
    self.rightLabel.font = [UIFont systemFontOfSize:14.f];
    self.rightLabel.textColor = [UIColor colorWithHexString:@"#BDBDBD"];
    [self addSubview:self.rightLabel];
    
    [self.rightLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAllAction)]];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    [self.rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.leftLabel);
    }];
}

- (void)viewAllAction {
    
    if (_viewAllBlock) {
        
        self.viewAllBlock();
    }
}

@end
