//
//  XBHomeActivityView.m
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 5.f
#import "XBHomeActivityView.h"
#import "XBGroupItem.h"
@interface XBHomeActivityView()
@property (strong, nonatomic) UIImageView   *coverImageView;
@property (strong, nonatomic) UIImageView   *favoriteImageView;
@property (strong, nonatomic) UIView        *pirceView;
@property (strong, nonatomic) UILabel       *marketPriceLabel;
@property (strong, nonatomic) UILabel       *sellingPriceLabel;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UIImageView   *instantImageView;
@property (strong, nonatomic) UILabel       *subTitleLabel;
@property (strong, nonatomic) UIImageView   *addressImageView;
@property (strong, nonatomic) UILabel       *addressLabel;
@property (strong, nonatomic) UIImageView   *participantsImageView;
@property (strong, nonatomic) UILabel       *participantsLabel;
@end
@implementation XBHomeActivityView

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
    self.coverImageView.image = [UIImage imageNamed:@"banner1.jpg"];
    [self addSubview:self.coverImageView];
    
    self.favoriteImageView = [UIImageView new];
    self.favoriteImageView.image = [UIImage imageNamed:@"activityWishNormal"];
    [self addSubview:self.favoriteImageView];
    
    self.pirceView = [UIView new];
    self.pirceView.backgroundColor = [UIColor colorWithRed:64.f/225. green:67.f/255.f blue:73.f/255.f alpha:0.88];
    self.pirceView.layer.masksToBounds = YES;
    self.pirceView.layer.cornerRadius  = 5.f;
    [self addSubview:self.pirceView];
    
    self.marketPriceLabel = [UILabel new];
    self.marketPriceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.f];
    self.marketPriceLabel.textColor = [UIColor whiteColor];
    [self.pirceView addSubview:self.marketPriceLabel];
    
    self.sellingPriceLabel = [UILabel new];
    self.sellingPriceLabel.font = [UIFont systemFontOfSize:13.5f];
    self.sellingPriceLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85f];
    [self.pirceView addSubview:self.sellingPriceLabel];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    [self addSubview:self.titleLabel];
    
    self.instantImageView = [UIImageView new];
    self.instantImageView.image = [UIImage imageNamed:@"activityFast"];
    [self addSubview:self.instantImageView];
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.font = [UIFont systemFontOfSize:13.5f];
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"#CBCBCB"];
    [self addSubview:self.subTitleLabel];
    
    self.addressImageView = [UIImageView new];
    self.addressImageView.image = [UIImage imageNamed:@"activityMap"];
    [self addSubview:self.addressImageView];
    
    self.addressLabel = [UILabel new];
    self.addressLabel.font = [UIFont systemFontOfSize:12.f];
    self.addressLabel.textColor = [UIColor colorWithHexString:@"#CBCBCB"];
    [self addSubview:self.addressLabel];
    
    self.participantsImageView = [UIImageView new];
    self.participantsImageView.image = [UIImage imageNamed:@"activityBooked"];
    [self addSubview:self.participantsImageView];
    
    self.participantsLabel = [UILabel new];
    self.participantsLabel.font = [UIFont systemFontOfSize:12.f];
    self.participantsLabel.textColor = self.addressLabel.textColor;
    [self addSubview:self.participantsLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat coverHeight = CGRectGetHeight(self.frame) * 0.62;
    
    [self.coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(coverHeight);
    }];
    
    [self.favoriteImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kSpace * 2.f);
        make.top.equalTo(self).offset(kSpace * 2.5f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 1.8f);
        make.top.equalTo(self.coverImageView.bottom).offset(kSpace * 3.f);
    }];
    
    [self.instantImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.right).offset(kSpace * 0.6f);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(kSpace);
        make.right.equalTo(self).offset(-kSpace * 2.f);
    }];
    
    [self.addressImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subTitleLabel);
        make.top.equalTo(self.subTitleLabel.bottom).offset(kSpace);
    }];
    
    [self.addressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressImageView);
        make.left.equalTo(self.addressImageView.right).offset(kSpace * 0.5);
    }];
    
    [self.participantsImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressImageView);
        make.left.equalTo(self.addressLabel.right).offset(kSpace * 3);
    }];
    
    [self.participantsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.participantsImageView);
        make.left.equalTo(self.participantsImageView.right).offset(kSpace * 0.5);
    }];
    
    [self.pirceView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(-kSpace);
        make.bottom.equalTo(self.coverImageView).offset(-kSpace * 4.f);
        make.height.mas_equalTo(coverHeight * 0.36);
        make.width.mas_equalTo(coverHeight * 0.47);;
    }];
    
    [self.pirceView layoutIfNeeded];
    CGFloat pirceHeight = CGRectGetHeight(self.pirceView.frame);
    
    [self.marketPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pirceView);
        make.top.equalTo(self.pirceView);
        make.height.mas_equalTo(pirceHeight * 0.65);
    }];
    
    [self.sellingPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pirceView);
        make.bottom.equalTo(self.pirceView).offset(-kSpace);
        make.height.mas_equalTo(pirceHeight * 0.35);
    }];
}

- (void)setGroupItem:(XBGroupItem *)groupItem
{
    _groupItem = groupItem;
    
    self.titleLabel.text    = groupItem.name;
    self.subTitleLabel.text = groupItem.subName;
    self.addressLabel.text  = groupItem.cityName;
    self.participantsLabel.text = groupItem.participants;
    self.marketPriceLabel.text  = [NSString stringWithFormat:@"￥%@",groupItem.marketPrice];
    self.sellingPriceLabel.text = [NSString stringWithFormat:@"￥ %@",groupItem.sellingPrice];
    self.favoriteImageView.image = [UIImage imageNamed:groupItem.favorite ? @"activityWishSelected" : @"activityWishNormal"];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:groupItem.imageUrl]];

    NSMutableAttributedString *markAttributedString = [[NSMutableAttributedString alloc] initWithString:self.marketPriceLabel.text];
    [markAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:22.f] range:NSMakeRange(1, self.marketPriceLabel.text.length - 1)];
    self.marketPriceLabel.attributedText = markAttributedString;
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.sellingPriceLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    self.sellingPriceLabel.attributedText = attribtStr;
}

@end
