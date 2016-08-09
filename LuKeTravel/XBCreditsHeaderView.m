//
//  XBCreditsHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/8/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCreditsHeaderView.h"
@interface XBCreditsHeaderView()
@property (strong, nonatomic) UILabel *titleLabel;
@end
@implementation XBCreditsHeaderView

- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}


- (void)initialization
{
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kSpace * 2);
    }];
}

- (void)setAmount:(NSInteger)amount
{
    self.titleLabel.text = [NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"credits-account"],[NSIntegerFormatter formatToNSString:amount]];
}

- (void)setCash:(NSInteger)cash
{
    NSString *text = self.titleLabel.text;
    
    self.titleLabel.text = [text stringByAppendingString:[NSString stringWithFormat:[XBLanguageControl localizedStringForKey:@"credits-credit"],[NSIntegerFormatter formatToNSString:cash]]];
    
    if ([[XBUserDefaultsUtil currentLanguage] isEqualToString:kLanguageENUS]) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:11.5f];
        
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#7B7B7B"];
        
    } else {
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12.5f];
        
        self.titleLabel.textColor = [UIColor blackColor];
    }
}
@end
