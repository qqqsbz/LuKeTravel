//
//  XBHomeDestinationView.m
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeDestinationView.h"
#import "XBGroupItem.h"
@interface XBHomeDestinationView()
@end
@implementation XBHomeDestinationView

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
    self.coverImageView = [UIImageView new];
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.layer.cornerRadius  = 10.f;
    [self addSubview:self.coverImageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.f];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
}

- (void)setDestination:(XBGroupItem *)destination
{
    _destination = destination;
    
    self.titleLabel.text = destination.name;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:destination.imageUrl]];
}

@end
