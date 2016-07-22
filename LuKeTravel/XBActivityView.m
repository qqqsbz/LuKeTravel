//
//  XBActivityView.m
//  LuKeTravel
//
//  Created by coder on 16/7/21.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#define kLineSpacing 7.f

#import "XBActivityView.h"
#import "XBActivity.h"
#import "XBNotify.h"
#import "XBParserUtils.h"
#import "XBParserContent.h"
#import "XBParserContentItem.h"
#import "XBActivityItemView.h"
#import "XBNotifyView.h"
#import "UIImage+Util.h"
#import <MapKit/MapKit.h>
@interface XBActivityView() <XBActivityItemViewDelegate>
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UILabel       *subTitleLabel;
@property (strong, nonatomic) UILabel       *sellLabel;
@property (strong, nonatomic) UILabel       *markLabel;
@property (strong, nonatomic) UIImageView   *addressImageView;
@property (strong, nonatomic) UILabel       *addressLabel;
@property (strong, nonatomic) UIImageView   *instantImageView;
@property (strong, nonatomic) UILabel       *instantLabel;
@property (strong, nonatomic) UIView        *separatorView;
@property (strong, nonatomic) UIImageView   *fastImageView;
@property (strong, nonatomic) UILabel       *fastLabel;
@property (strong, nonatomic) UILabel       *fastTipLabel;
@property (strong, nonatomic) UILabel       *descLabel;
@property (strong, nonatomic) UIButton      *readMoreButton;
@property (strong, nonatomic) UIButton      *recommendButton;
@property (strong, nonatomic) XBNotifyView  *cancellationNotifyView;
@property (strong, nonatomic) XBNotifyView  *confirmationNotifyView;
@property (strong, nonatomic) XBNotifyView  *durationNotifyView;
@property (strong, nonatomic) XBNotifyView  *languageNotifyView;
@property (strong, nonatomic) XBNotifyView  *recommendedNumberNotifyView;
@property (strong, nonatomic) XBNotifyView  *transportationNotifyView;
@property (strong, nonatomic) MKMapView     *mapView;
@property (strong, nonatomic) UILabel       *reviewsLabel;
@property (strong, nonatomic) UIImageView   *starImageView1;
@property (strong, nonatomic) UIImageView   *starImageView2;
@property (strong, nonatomic) UIImageView   *starImageView3;
@property (strong, nonatomic) UIImageView   *starImageView4;
@property (strong, nonatomic) UIImageView   *starImageView5;
@property (strong, nonatomic) UIButton      *reviewsReadMoreButton;
@property (strong, nonatomic) UIView        *reviewsSeparatorView;
@property (strong, nonatomic) UILabel       *directionTitleLabel;
@property (strong, nonatomic) UILabel       *confirmTitleLabel;
@property (strong, nonatomic) UILabel       *packageTitleLabel;
@property (strong, nonatomic) UIButton      *directionReadMoreButton;
@property (strong, nonatomic) UIView        *directionSeparatorView;
@property (strong, nonatomic) UILabel       *useTitleLabel;
@property (strong, nonatomic) UIView        *useView;
@property (strong, nonatomic) UILabel       *noticeTitleLabel;
@property (strong, nonatomic) UIView        *noticeView;
@property (strong, nonatomic) UILabel       *tagLabel;
@property (strong, nonatomic) XBActivityItemView  *confirmSuccessLabel;
@property (strong, nonatomic) XBActivityItemView  *confirmEmailLabel;
@property (strong, nonatomic) XBActivityItemView  *detailItemView;

@property (strong, nonatomic) NSMutableArray *starImageViews;
@end

@implementation XBActivityView

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

- (void)setActivity:(XBActivity *)activity
{
    _activity = activity;
    
    self.titleLabel.text = activity.name;
    
    self.subTitleLabel.text = activity.subName;
    
    self.addressLabel.text  = activity.cityName;
    
    self.instantLabel.text  = activity.participantsFormat;
    
    self.sellLabel.text = [NSString stringWithFormat:@"￥ %@",[NSIntegerFormatter formatToNSString:activity.sellPrice]];
    
    self.markLabel.text = [NSIntegerFormatter formatToNSString:activity.marketPrice];
    
    self.descLabel.text = activity.desc;
    
    self.reviewsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"activity-detail-reviewcount", @"activity-detail-reviewcount"),[NSIntegerFormatter formatToNSString:activity.reviewsCount]];
    
    [self addStar];
    
    [self addNotify];
    
    [self fillMap];
    
    [self parserContent];
    
    [self addAttributedString];
}

- (void)initialization
{
    
    UIColor *defaultColor = [UIColor colorWithHexString:kDefaultColorHex];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#F6F5F2"];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    self.titleLabel.textColor = defaultColor;
    [self addSubview:self.titleLabel];
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.font = [UIFont systemFontOfSize:14.f];
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"#6C6C6B"];
    [self addSubview:self.subTitleLabel];
    
    
    self.sellLabel = [UILabel new];
    self.sellLabel.textAlignment = NSTextAlignmentRight;
    self.sellLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    self.sellLabel.textColor = [UIColor colorWithHexString:@"#4C4C4C"];
    [self addSubview:self.sellLabel];
    
    self.markLabel = [UILabel new];
    self.markLabel.font = [UIFont systemFontOfSize:13.f];
    self.markLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:self.markLabel];
    
    self.addressImageView = [UIImageView new];
    self.addressImageView.image = [UIImage imageNamed:@"activityMap"];
    [self addSubview:self.addressImageView];
    
    self.addressLabel = [UILabel new];
    self.addressLabel.font = [UIFont systemFontOfSize:14.5f];
    self.addressLabel.textColor = [UIColor colorWithHexString:@"#AFAEAD"];
    [self addSubview:self.addressLabel];
    
    self.instantImageView = [UIImageView new];
    self.instantImageView.image = [UIImage imageNamed:@"activityBooked"];
    [self addSubview:self.instantImageView];
    
    self.instantLabel = [UILabel new];
    self.instantLabel.font = [UIFont systemFontOfSize:14.5f];
    self.instantLabel.textColor = [UIColor colorWithHexString:@"#AFAEAD"];
    [self addSubview:self.instantLabel];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#E0DFDD"];
    [self addSubview:self.separatorView];
    
    self.fastImageView = [UIImageView new];
    self.fastImageView.image = [UIImage imageNamed:@"activityFast"];
    [self addSubview:self.fastImageView];
    
    self.fastLabel = [UILabel new];
    self.fastLabel.text = @"极速";
    self.fastLabel.font = [UIFont systemFontOfSize:14.f];
    self.fastLabel.textColor = defaultColor;
    [self addSubview:self.fastLabel];
    
    self.fastTipLabel = [UILabel new];
    self.fastTipLabel.text = @"现在预订可立即获得电子凭证";
    self.fastTipLabel.font = [UIFont systemFontOfSize:11.5f];
    self.fastTipLabel.textColor = [UIColor colorWithHexString:@"#AFAEAD"];
    [self addSubview:self.fastTipLabel];
    
    self.descLabel = [UILabel new];
    self.descLabel.numberOfLines = 0;
    self.descLabel.font = [UIFont systemFontOfSize:15.f];
    self.descLabel.textColor = [UIColor colorWithHexString:@"#6C6C6B"];
    [self addSubview:self.descLabel];
    
    self.detailItemView = [XBActivityItemView new];
    self.detailItemView.delegate = self;
    [self addSubview:self.detailItemView];

    self.readMoreButton = [UIButton new];
    self.readMoreButton.layer.borderWidth = 1.f;
    self.readMoreButton.layer.borderColor = defaultColor.CGColor;
    self.readMoreButton.layer.masksToBounds = YES;
    self.readMoreButton.layer.cornerRadius  = 5.f;
    self.readMoreButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.readMoreButton setTitle:NSLocalizedString(@"activity-detail-readmore", @"activity-detail-readmore") forState:UIControlStateNormal];
    [self.readMoreButton setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.readMoreButton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.readMoreButton];
    
    self.recommendButton = [UIButton new];
    self.recommendButton.layer.borderWidth = 1.f;
    self.recommendButton.layer.borderColor = defaultColor.CGColor;
    self.recommendButton.layer.masksToBounds = YES;
    self.recommendButton.layer.cornerRadius  = 5.f;
    self.recommendButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.recommendButton setTitle:NSLocalizedString(@"activity-detail-recommend", @"activity-detail-recommend") forState:UIControlStateNormal];
    [self.recommendButton setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.recommendButton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.recommendButton];
    
    self.durationNotifyView = [XBNotifyView new];
    self.durationNotifyView.titleLabel.text = NSLocalizedString(@"activity-notify-duration", @"activity-notify-duration");
    self.durationNotifyView.imageView.image = [UIImage imageNamed:@"activity_time"];
    [self addSubview:self.durationNotifyView];
    
    self.languageNotifyView = [XBNotifyView new];
    self.languageNotifyView.titleLabel.text = NSLocalizedString(@"activity-notify-language", @"activity-notify-language");
    self.languageNotifyView.imageView.image = [UIImage imageNamed:@"activity_lang"];
    [self addSubview:self.languageNotifyView];
    
    self.recommendedNumberNotifyView = [XBNotifyView new];
    self.recommendedNumberNotifyView.titleLabel.text = NSLocalizedString(@"activity-notify-recommendedNumber", @"activity-notify-recommendedNumber");
    self.recommendedNumberNotifyView.imageView.image = [UIImage imageNamed:@"activity_head_count"];
    [self addSubview:self.recommendedNumberNotifyView];
    
    self.transportationNotifyView = [XBNotifyView new];
    self.transportationNotifyView.titleLabel.text = NSLocalizedString(@"activity-notify-transportation", @"activity-notify-transportation");
    self.transportationNotifyView.imageView.image = [UIImage imageNamed:@"activity_pickup"];
    [self addSubview:self.transportationNotifyView];
    
    self.confirmationNotifyView = [XBNotifyView new];
    self.confirmationNotifyView.titleLabel.text = NSLocalizedString(@"activity-notify-confirmation", @"activity-notify-confirmation");
    self.confirmationNotifyView.imageView.image = [UIImage imageNamed:@"activity_confirm"];
    [self addSubview:self.confirmationNotifyView];
    
    self.cancellationNotifyView = [XBNotifyView new];
    self.cancellationNotifyView.titleLabel.text = NSLocalizedString(@"activity-notify-cancellation", @"activity-notify-cancellation");
    self.cancellationNotifyView.imageView.image = [UIImage imageNamed:@"activity_refund"];
    [self addSubview:self.cancellationNotifyView];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = NO;
    self.mapView.showsCompass = NO;
    self.mapView.showsPointsOfInterest = YES;
    [self addSubview:self.mapView];
    
    self.reviewsLabel = [UILabel new];
    self.reviewsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.f];
    self.reviewsLabel.textColor = [UIColor blackColor];
    [self addSubview:self.reviewsLabel];
    
    UIImage *starImage = [[UIImage imageNamed:@"star-template"] imageContentWithColor:defaultColor];
    
    self.starImageView1 = [UIImageView new];
    self.starImageView1.image = starImage;
    [self addSubview:self.starImageView1];
    
    self.starImageView2 = [UIImageView new];
    self.starImageView2.image = starImage;
    [self addSubview:self.starImageView2];
    
    self.starImageView3 = [UIImageView new];
    self.starImageView3.image = starImage;
    [self addSubview:self.starImageView3];
    
    self.starImageView4 = [UIImageView new];
    self.starImageView4.image = starImage;
    [self addSubview:self.starImageView4];
    
    self.starImageView5 = [UIImageView new];
    self.starImageView5.image = starImage;
    [self addSubview:self.starImageView5];
    
    self.starImageViews = [NSMutableArray arrayWithCapacity:5];
    [self.starImageViews addObject:self.starImageView1];
    [self.starImageViews addObject:self.starImageView2];
    [self.starImageViews addObject:self.starImageView3];
    [self.starImageViews addObject:self.starImageView4];
    [self.starImageViews addObject:self.starImageView5];
    
    self.reviewsReadMoreButton = [UIButton new];
    self.reviewsReadMoreButton.layer.borderWidth = 1.f;
    self.reviewsReadMoreButton.layer.borderColor = defaultColor.CGColor;
    self.reviewsReadMoreButton.layer.masksToBounds = YES;
    self.reviewsReadMoreButton.layer.cornerRadius  = 5.f;
    self.reviewsReadMoreButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.reviewsReadMoreButton setTitle:NSLocalizedString(@"activity-detail-readmore", @"activity-detail-readmore") forState:UIControlStateNormal];
    [self.reviewsReadMoreButton setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.reviewsReadMoreButton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.reviewsReadMoreButton];
    
    self.reviewsSeparatorView = [UIView new];
    self.reviewsSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#E0DFDD"];
    [self addSubview:self.reviewsSeparatorView];

    self.directionTitleLabel = [UILabel new];
    self.directionTitleLabel.text = NSLocalizedString(@"activity-detail-direction", @"activity-detail-direction");
    self.directionTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    self.directionTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.directionTitleLabel];
    
    self.confirmTitleLabel = [UILabel new];
    self.confirmTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    self.confirmTitleLabel.textColor = defaultColor;
    [self addSubview:self.confirmTitleLabel];

    self.confirmSuccessLabel = [XBActivityItemView new];
    self.confirmSuccessLabel.delegate = self;
    [self addSubview:self.confirmSuccessLabel];
//
    self.confirmEmailLabel = [XBActivityItemView new];
    self.confirmEmailLabel.delegate = self;
    [self addSubview:self.confirmEmailLabel];

    self.packageTitleLabel = [UILabel new];
    self.packageTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    self.packageTitleLabel.textColor = defaultColor;
    [self addSubview:self.packageTitleLabel];
    
    self.directionReadMoreButton = [UIButton new];
    self.directionReadMoreButton.layer.borderWidth = 1.f;
    self.directionReadMoreButton.layer.borderColor = defaultColor.CGColor;
    self.directionReadMoreButton.layer.masksToBounds = YES;
    self.directionReadMoreButton.layer.cornerRadius  = 5.f;
    self.directionReadMoreButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.directionReadMoreButton setTitle:NSLocalizedString(@"activity-detail-readmore", @"activity-detail-readmore") forState:UIControlStateNormal];
    [self.directionReadMoreButton setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.directionReadMoreButton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.directionReadMoreButton];

    self.directionSeparatorView = [UIView new];
    self.directionSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#E0DFDD"];
    [self addSubview:self.directionSeparatorView];
    
    self.useTitleLabel = [UILabel new];
    self.useTitleLabel.text = NSLocalizedString(@"activity-detail-use", @"activity-detail-use");
    self.useTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    self.useTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.useTitleLabel];
    
    self.useView = [UIView new];
    self.useView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.useView];
    
    self.noticeTitleLabel = [UILabel new];
    self.noticeTitleLabel.text = NSLocalizedString(@"activity-detail-notice", @"activity-detail-notice");
    self.noticeTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    self.noticeTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.noticeTitleLabel];
    
    self.noticeView = [UIView new];
    self.noticeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.noticeView];

    self.tagLabel = [UILabel new];
    self.tagLabel.text = @"Activity #@";
    self.tagLabel.font = [UIFont systemFontOfSize:14.5f];
    self.tagLabel.textColor = [UIColor colorWithHexString:@"#AFAEAD"];
    [self addSubview:self.tagLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kSpace * 2.3);
        make.left.equalTo(self).offset(kSpace);
        make.right.equalTo(self.sellLabel.left).offset(-kSpace);
    }];
    
    [self.sellLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kSpace);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(kSpace * 0.4);
        make.right.equalTo(self.titleLabel);
    }];

    [self.markLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.subTitleLabel);
        make.right.equalTo(self.sellLabel);
    }];
    
    
    [self.addressImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.subTitleLabel.bottom).offset(kSpace * 0.7);
    }];
    
    [self.addressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressImageView);
        make.left.equalTo(self.addressImageView.right).offset(kSpace * 0.5);
    }];
    
    [self.instantImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel.right).offset(kSpace);
        make.centerY.equalTo(self.addressLabel);
    }];
    
    [self.instantLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.instantImageView);
        make.left.equalTo(self.instantImageView.right).offset(kSpace * 0.5);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressImageView.bottom).offset(kSpace * 1.2);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.sellLabel);
        make.height.mas_equalTo(0.7);
    }];
    
    [self.fastImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.separatorView);
        make.top.equalTo(self.separatorView.bottom).offset(kSpace * 1.3);
    }];
    
    [self.fastLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fastImageView);
        make.left.equalTo(self.fastImageView.right).offset(kSpace * 0.5);
    }];
    
    [self.fastTipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fastLabel);
        make.left.equalTo(self.fastLabel.right).offset(kSpace);
    }];
    
    [self.descLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fastImageView);
        make.top.equalTo(self.fastImageView.bottom).offset(kSpace * 2.3);
        make.right.equalTo(self).offset(-kSpace * 1.5);
    }];
    
    [self.detailItemView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLabel).offset(kSpace);
        make.top.equalTo(self.descLabel.bottom).offset(kSpace * 1.7);
        make.right.equalTo(self.descLabel).offset(-kSpace);
    }];
    
    [self.readMoreButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailItemView);
        make.top.equalTo(self.detailItemView.bottom).offset(kSpace * 3.5);
//        make.width.mas_greaterThanOrEqualTo(120.f);
        make.height.mas_greaterThanOrEqualTo(35.f);
    }];
    
    [self.recommendButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.readMoreButton);
        make.right.equalTo(self.detailItemView);
        make.height.equalTo(self.readMoreButton);
        make.left.equalTo(self.readMoreButton.right).offset(kSpace * 3.5);
        make.width.equalTo(self.readMoreButton);
    }];
    
    [self.languageNotifyView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.readMoreButton.bottom).offset(kSpace * 2.5);
    }];
    
    [self.durationNotifyView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.readMoreButton).offset(kSpace * 4.05);
        make.top.equalTo(self.languageNotifyView);
    }];
    
    [self.recommendedNumberNotifyView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.recommendButton).offset(-kSpace * 4.05);
        make.top.equalTo(self.languageNotifyView);
    }];
    
    [self.confirmationNotifyView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.languageNotifyView);
        make.top.equalTo(self.languageNotifyView.bottom).offset(kSpace * 1.5);
    }];
    
    [self.transportationNotifyView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.durationNotifyView);
        make.centerY.equalTo(self.confirmationNotifyView);
    }];
    
    [self.cancellationNotifyView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.recommendedNumberNotifyView);
        make.centerY.equalTo(self.confirmationNotifyView);
    }];
    
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.transportationNotifyView.bottom).offset(kSpace * 4);
        make.right.equalTo(self);
        make.height.mas_equalTo(130.f);
    }];
    
    [self.reviewsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mapView.bottom).offset(kSpace * 4);
    }];
    
    [self.starImageView3 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.reviewsLabel.bottom).offset(kSpace * 2.f);
        make.width.mas_equalTo(25.f);
        make.height.mas_equalTo(25.f);
    }];
    
    [self.starImageView2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.starImageView3);
        make.width.equalTo(self.starImageView3);
        make.height.equalTo(self.starImageView3);
        make.right.equalTo(self.starImageView3.left).offset(-kSpace * 0.6);
    }];
    
    [self.starImageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.starImageView2);
        make.width.equalTo(self.starImageView2);
        make.height.equalTo(self.starImageView2);
        make.right.equalTo(self.starImageView2.left).offset(-kSpace * 0.6);
    }];
    
    [self.starImageView4 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.starImageView3);
        make.width.equalTo(self.starImageView3);
        make.height.equalTo(self.starImageView3);
        make.left.equalTo(self.starImageView3.right).offset(kSpace * 0.6);
    }];
    
    [self.starImageView5 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.starImageView4);
        make.width.equalTo(self.starImageView4);
        make.height.equalTo(self.starImageView4);
        make.left.equalTo(self.starImageView4.right).offset(kSpace * 0.6);
    }];
    
    [self.reviewsReadMoreButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starImageView1).offset(kSpace);
        make.top.equalTo(self.starImageView3.bottom).offset(kSpace * 1.5);
        make.right.equalTo(self.starImageView5).offset(-kSpace);
        make.height.mas_equalTo(35.f);
    }];
    
    [self.reviewsSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reviewsReadMoreButton.bottom).offset(kSpace * 3.3);
        make.left.equalTo(self).offset(kSpace);
        make.right.equalTo(self).offset(-kSpace);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.directionTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.reviewsSeparatorView.bottom).offset(kSpace * 4);
    }];
    
    [self.confirmTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSpace * 1.4);
        make.top.equalTo(self.directionTitleLabel.bottom).offset(kSpace * 3);
    }];
    
    [self.confirmSuccessLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmTitleLabel).offset(kSpace * 0.8);
        make.top.equalTo(self.confirmTitleLabel.bottom).offset(kSpace * 0.5);
        make.right.equalTo(self).offset(-kSpace * 2);
    }];
    
    [self.confirmEmailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmTitleLabel).offset(kSpace);
        make.top.equalTo(self.confirmSuccessLabel.bottom).offset(kSpace);
        make.right.equalTo(self).offset(-kSpace * 2);
    }];
    
    [self.packageTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmTitleLabel);
        make.top.equalTo(self.confirmEmailLabel.bottom).offset(kSpace * 1.2);
    }];
    
    [self.directionReadMoreButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reviewsReadMoreButton).offset(kSpace);
        make.top.equalTo(self.packageTitleLabel.bottom).offset(kSpace * 3);
        make.right.equalTo(self.reviewsReadMoreButton).offset(-kSpace);
        make.height.mas_equalTo(35.f);
    }];

    [self.directionSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.directionReadMoreButton.bottom).offset(kSpace * 3.3);
        make.left.equalTo(self).offset(kSpace);
        make.right.equalTo(self).offset(-kSpace);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.useTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.directionSeparatorView.bottom).offset(kSpace * 3.5);
    }];
    
    [self.useView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.useTitleLabel.bottom).offset(kSpace * 3.5);
        make.right.equalTo(self);
//        make.height.mas_greaterThanOrEqualTo(50);
    }];
    
    [self.noticeTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.useView.bottom).offset(kSpace * 3.5);
    }];
    
    [self.noticeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.noticeTitleLabel.bottom).offset(kSpace * 3.5);
        make.right.equalTo(self);
//        make.height.mas_greaterThanOrEqualTo(50);
    }];

    [self.tagLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.noticeView.bottom).offset(kSpace * 3);
        make.bottom.equalTo(self).offset(-kSpace * 2);
    }];
}

- (void)parserContent
{
    [XBParserUtils parserWithContent:self.activity.detail regex:@"- .*" complete:^(NSArray *datas) {
        
        if (datas.count > 0) {
            
            XBParserContent *content = [datas firstObject];
            
            if (content.items.count > 0) {
                
                XBParserContentItem *item = [content.items firstObject];
                
                self.detailItemView.parserContentItem = item;
            }
        }
        
    }];
    
    [XBParserUtils parserWithContent:self.activity.directionsAndLocation regex:@".+" complete:^(NSArray *datas) {
        
        if (datas.count > 0) {
            
            XBParserContent *content = [datas firstObject];
            
            self.confirmTitleLabel.text = content.title;
            
            if (content.items.count > 0) {
                
                XBParserContentItem *item = [content.items firstObject];
                
                self.confirmSuccessLabel.parserContentItem = item;
                
                XBParserContentItem *emailItem = content.items[1];
                
                self.confirmEmailLabel.parserContentItem = emailItem;
            }
            
            XBParserContent *package = datas[1];
            
            self.packageTitleLabel.text = package.title;
        }
        
    }];
    
    [XBParserUtils parserWithContent:self.activity.termsAndConditions regex:@"- .*" complete:^(NSArray *datas) {
        
        if (datas.count > 0) {
            
            XBParserContent *content = [datas firstObject];
            
            for (XBParserContentItem *item in content.items) {
                
                XBActivityItemView *itemView = [XBActivityItemView new];
                
                itemView.parserContentItem = item;
                
                [self.useView addSubview:itemView];
                
            }
            
            [self addUserConstraint];
        }
        
    }];
    
    [XBParserUtils parserWithContent:self.activity.frequentlyAskedQuestions regex:@"- .*" complete:^(NSArray *datas) {
        
        if (datas.count > 0) {
            
            XBParserContent *content = [datas firstObject];
            
            for (XBParserContentItem *item in content.items) {
                
                XBActivityItemView *itemView = [XBActivityItemView new];
                
                itemView.parserContentItem = item;
                
                [self.noticeView addSubview:itemView];
                
            }
            
            [self addNoticeConstraint];
        }
        
    }];
}

- (void)addUserConstraint
{
    NSArray *views = self.useView.subviews;
    
    UIView *firstView = [views firstObject];
    
    UIView *lastView  = [views lastObject];
    
    
    [firstView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.useView).offset(kSpace * 1.8);
        make.top.equalTo(self.useView);
        make.right.equalTo(self.useView).offset(-kSpace * 2.f);
    }];
    
    for (NSInteger i = 1; i < views.count; i ++ ) {
        
        UIView *previousView = views[i - 1];
        
        UIView *currentView  = views[i];
        
        [currentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(previousView);
            make.right.equalTo(previousView);
            make.top.equalTo(previousView.bottom).offset(kSpace);
        }];
        
    }
    
    [lastView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.useView);
    }];

}

- (void)addNoticeConstraint
{
    NSArray *views = self.noticeView.subviews;
    
    UIView *firstView = [views firstObject];
    
    UIView *lastView  = [views lastObject];
    
    [firstView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noticeView).offset(kSpace * 1.8);
        make.top.equalTo(self.noticeView);
        make.right.equalTo(self.noticeView).offset(-kSpace * 2.f);
    }];
    
    for (NSInteger i = 1; i < views.count; i ++ ) {
        
        UIView *previousView = views[i - 1];
        
        UIView *currentView  = views[i];
        
        [currentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(previousView);
            make.right.equalTo(previousView);
            make.top.equalTo(previousView.bottom).offset(kSpace);
        }];
        
    }
    
    [lastView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.noticeView);
    }];

}

- (void)addStar
{
    NSInteger min = floorf(self.activity.rating);
    
    NSInteger max = ceilf(self.activity.rating);
    
    UIImageView *imageView;
    
    UIColor *defaultColor = [UIColor colorWithHexString:kDefaultColorHex];
    
    for (NSInteger i = 0; i < self.starImageViews.count; i ++ ) {
        
        imageView = self.starImageViews[i];
        
        if (i < min) {
            
            imageView.image = [[UIImage imageNamed:@"star-highlighted-template"] imageContentWithColor:defaultColor];
            
        } else {
            
            imageView.image = [[UIImage imageNamed:@"star-template"] imageContentWithColor:defaultColor];
        }
        
    }
    
    CGFloat area = self.activity.rating - min;
    
    UIImageView *areaImageView = self.starImageViews[max - 1];
    
    
}

- (void)fillMap
{
    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake([self.activity.latitude doubleValue], [self.activity.longitude doubleValue]);
    
    self.mapView.region = MKCoordinateRegionMake(coordinate2D, MKCoordinateSpanMake(0.15, 0.15));
    
    //添加大头针
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    
    pointAnnotation.coordinate = coordinate2D;
    
    [self.mapView addAnnotation:pointAnnotation];
}

- (void)addNotify
{
    XBNotify *notify = self.activity.notify;
    
    self.durationNotifyView.subTitleLabel.text = notify.duration;
    
    self.languageNotifyView.subTitleLabel.text = notify.language;
    
    self.recommendedNumberNotifyView.subTitleLabel.text = notify.recommendedNumber;
    
    self.transportationNotifyView.subTitleLabel.text = notify.transportation;
    
    self.confirmationNotifyView.subTitleLabel.text = notify.confirmation;
    
    self.cancellationNotifyView.subTitleLabel.text = notify.cancellation;
}

- (void)addAttributedString
{
    NSMutableAttributedString *descAttributedString = [[NSMutableAttributedString alloc] initWithString:self.descLabel.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:kLineSpacing];//调整行间距
    
    [descAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.descLabel.text.length)];
    
    self.descLabel.attributedText = descAttributedString;
}

#pragma mark -- XBActivityItemViewDelegate
- (void)activityItemView:(XBActivityItemView *)activityItemView didSelectLinkWithURL:(NSURL *)url
{
    if ([self.delegate respondsToSelector:@selector(activityItemView:didSelectLinkWithURL:)]) {
        [self.delegate activityView:self didSelectLinkWithURL:url];
    }
}

@end
