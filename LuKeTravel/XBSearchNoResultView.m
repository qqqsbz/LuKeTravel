//
//  XBSearchNoResultView.m
//  LuKeTravel
//
//  Created by coder on 16/8/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearchNoResultView.h"
@interface XBSearchNoResultView()
/** 图标 */
@property (strong, nonatomic) UIImageView *imageView;
/** 文字 */
@property (strong, nonatomic) UILabel *titleLabel;
@end
@implementation XBSearchNoResultView

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
    self.imageView = [UIImageView new];
    self.imageView.image = [UIImage imageNamed:@"search"];
    [self addSubview:self.imageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"search-noresult"];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel.left).offset(-kSpace * 0.7);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

@end
