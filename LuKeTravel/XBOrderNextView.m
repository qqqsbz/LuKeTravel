//
//  XBOrderNextView.m
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderNextView.h"
@interface XBOrderNextView()
@property (strong, nonatomic) UIButton *nextButton;
@property (copy  , nonatomic) dispatch_block_t  nextBlock;
@end
@implementation XBOrderNextView

- (instancetype)initWithNextBlock:(dispatch_block_t)nextBlock
{
    if (self = [super init]) {
        _nextBlock = nextBlock;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame nextBlock:(dispatch_block_t)nextBlock
{
    if (self = [super initWithFrame:frame]) {
        _nextBlock = nextBlock;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.layer.cornerRadius  = 5.f;
    [self.nextButton setTitle:[XBLanguageControl localizedStringForKey:@"activity-order-next"] forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:[UIColor colorWithHexString:kDefaultColorHex]];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextButton];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 2);
        make.top.equalTo(self).offset(kSpace * 2);
        make.right.equalTo(self).offset(-kSpace * 2);
        make.bottom.equalTo(self).offset(-kSpace * 2);
    }];
}

- (void)nextAction
{
    if (self.nextBlock) {
        
        self.nextBlock();
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [self.nextButton setTitle:title forState:UIControlStateNormal];
}

@end
