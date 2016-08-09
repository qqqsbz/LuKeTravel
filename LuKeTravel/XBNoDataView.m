//
//  XBNoOrderView.m
//  LuKeTravel
//
//  Created by coder on 16/7/28.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBNoDataView.h"
@interface XBNoDataView()
@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) UILabel       *titleLabel;
@end
@implementation XBNoDataView
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
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    self.imageView = [UIImageView new];
    self.imageView.image = [UIImage imageNamed:@"order_mask"];
    [self addSubview:self.imageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = [XBLanguageControl localizedStringForKey:@"order-noorder"];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#595959"];
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self addSubview:self.titleLabel];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 2.5);
        make.right.equalTo(self).offset(-kSpace * 2.5);
        make.centerY.equalTo(self).offset(kSpace * 0.7);
    }];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.titleLabel.top).offset(-kSpace * 2.f);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
}

- (void)setText:(NSString *)text
{
    self.titleLabel.text = text;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

@end
