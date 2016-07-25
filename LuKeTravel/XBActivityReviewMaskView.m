//
//  XBActivityReviewView.m
//  LuKeTravel
//
//  Created by coder on 16/7/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBActivityReviewMaskView.h"
@interface XBActivityReviewMaskView()
@property (strong, nonatomic) UILabel              *titleLabel;
@property (strong, nonatomic) UITableView          *tableView;
@property (strong, nonatomic) UIVisualEffectView   *effectView;
@property (strong, nonatomic) UIActivityIndicatorView  *indicatorView;
@end
@implementation XBActivityReviewMaskView

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
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = NSLocalizedString(@"activity-detail-reviewcount", @"activity-detail-reviewcount");
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.indicatorView startAnimating];
    [self addSubview:self.indicatorView];
}

- (void)layoutSubviews
{
    [self.effectView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_offset(44.f);
    }];
    
    [self.indicatorView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

@end
