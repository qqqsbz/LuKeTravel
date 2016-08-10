//
//  XBNoActivityView.m
//  LuKeTravel
//
//  Created by coder on 16/7/20.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 15.f
#define kLineSpacing 10.f

#import "XBNoActivityView.h"
@interface XBNoActivityView()
@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) UILabel       *titleLabel;
@end
@implementation XBNoActivityView

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
    self.imageView.image = [UIImage imageNamed:@"noActivities"];
    [self addSubview:self.imageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-more-nodata"];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [self addSubview:self.titleLabel];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kLineSpacing];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.titleLabel.text.length)];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.centerY).offset(-kSpace);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.centerY).offset(kSpace);
    }];
}

@end
