//
//  XBActivityMaskView.m
//  LuKeTravel
//
//  Created by coder on 16/7/25.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 20.f
#import "XBActivityRecommendMaskView.h"
@interface XBActivityRecommendMaskView()
@property (strong, nonatomic) UIVisualEffectView   *effectView;
@end
@implementation XBActivityRecommendMaskView

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
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self addSubview:self.effectView];
    
    self.textLabel = [TTTAttributedLabel new];
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineSpacing = 7.f;
    self.textLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.textLabel.textColor = [UIColor colorWithWhite:1 alpha:0.65];
    self.textLabel.font = [UIFont systemFontOfSize:16.5f];
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews
{
    [self.effectView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 1.2);
        make.top.equalTo(self).offset(kSpace * 2);
        make.right.equalTo(self).offset(-kSpace);
        make.bottom.equalTo(self).offset(-kSpace);
    }];
}

@end
