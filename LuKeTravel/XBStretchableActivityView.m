//
//  XBStretchableScrollHeaderView.m
//  LuKeTravel
//
//  Created by coder on 16/7/7.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#define kLineSpacing 7.f

#import "XBStretchableActivityView.h"
#import "XBActivity.h"
#import "XBNotify.h"
#import "XBParserUtils.h"
#import "XBParserContent.h"
#import "XBParserContentItem.h"
#import "XBActivityItemView.h"
#import "XBNotifyView.h"
#import "UIImage+Util.h"
#import <MapKit/MapKit.h>
@interface XBStretchableActivityView() <XBActivityItemViewDelegate,MKMapViewDelegate>
@property (assign, nonatomic) CGRect   initialFrame;
@property (assign, nonatomic) CGFloat  defaultViewHeight;


@property (strong, nonatomic) UIView        *contentView;
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
@property (strong, nonatomic) UIButton      *favoriteButton;
@property (strong, nonatomic) UIButton      *mapLocationButton;
@property (strong, nonatomic) XBActivityItemView  *confirmSuccessLabel;
@property (strong, nonatomic) XBActivityItemView  *confirmEmailLabel;
@property (strong, nonatomic) XBActivityItemView  *detailItemView;

@property (strong, nonatomic) NSMutableArray *starImageViews;
@property (strong, nonatomic) NSArray        *directions;
@property (strong, nonatomic) NSArray        *details;

@end
@implementation XBStretchableActivityView

- (void)stretchHeaderForScrollView:(UIScrollView *)scrollView withView:(UIView *)view
{
    _scrollView = scrollView;
    
    _headerView = view;
    
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    
    _initialFrame       = _headerView.frame;
    
    _defaultViewHeight  = _initialFrame.size.height;
    
    [_scrollView addSubview:_headerView];
    
    [self initialization];
}


- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGRect f     = _headerView.frame;
    
    f.size.width = _scrollView.frame.size.width;
    
    _headerView.frame  = f;
    
    if(scrollView.contentOffset.y < 0)
    {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        
        _initialFrame.origin.y = - offsetY;
        
        _initialFrame.size.height = _defaultViewHeight + offsetY;
        
        _headerView.frame = _initialFrame;
        
    }
    
}


- (void)resizeView
{
    _initialFrame.size.width = _scrollView.frame.size.width;
    
    _headerView.frame = _initialFrame;
}

#pragma mark --

- (void)setActivity:(XBActivity *)activity
{
    _activity = activity;
    
    self.titleLabel.text = activity.name;
    
    self.subTitleLabel.text = activity.subName;
    
    self.addressLabel.text  = activity.cityName;
    
    self.instantLabel.text  = activity.participantsFormat;
    
    self.sellLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],[NSIntegerFormatter formatToNSString:activity.sellPrice]];
    
    self.markLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],[NSIntegerFormatter formatToNSString:activity.marketPrice]];
    
    self.descLabel.text = activity.desc;
    
    self.reviewsLabel.text = [NSString stringWithFormat:@"%@(%@)",[XBLanguageControl localizedStringForKey:@"activity-detail-reviewcount"],[NSIntegerFormatter formatToNSString:activity.reviewsCount]];
    
    self.fastLabel.hidden = !self.activity.isInstant;
    
    self.fastImageView.hidden = !self.activity.isInstant;
    
    self.fastTipLabel.hidden = !self.activity.isInstant;
    
    [self addStar];
    
    [self addNotify];
    
    [self fillMap];
    
    [self parserContent];
    
    [self addAttributedString];
    
    [self.noticeView layoutIfNeeded];
    
    if (!self.activity.isInstant) {
        
        [self.descLabel updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fastImageView.bottom).offset(0);
        }];
    }
    
}

- (void)initialization
{
    UIColor *defaultColor = [UIColor colorWithHexString:kDefaultColorHex];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#F6F5F2"];
    
    self.favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favoriteButton setImage:[UIImage imageNamed:@"heart-o"] forState:UIControlStateNormal];
    [self.favoriteButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.favoriteButton];
    
    self.tagLabel = [UILabel new];
    self.tagLabel.text = @"Activity #@";
    self.tagLabel.font = [UIFont systemFontOfSize:14.5f];
    self.tagLabel.textColor = [UIColor colorWithHexString:@"#AFAEAD"];
    [self.scrollView addSubview:self.tagLabel];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.contentView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    self.titleLabel.textColor = defaultColor;
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subTitleLabel.font = [UIFont systemFontOfSize:14.f];
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"#6C6C6B"];
    [self.contentView addSubview:self.subTitleLabel];
    
    
    self.sellLabel = [UILabel new];
    self.sellLabel.textAlignment = NSTextAlignmentRight;
    self.sellLabel.font = [UIFont systemFontOfSize:19.f];
    self.sellLabel.textColor = [UIColor colorWithHexString:@"#4C4C4C"];
    [self.contentView addSubview:self.sellLabel];
    
    self.markLabel = [UILabel new];
    self.markLabel.font = [UIFont systemFontOfSize:13.f];
    self.markLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:self.markLabel];
    
    self.addressImageView = [UIImageView new];
    self.addressImageView.image = [UIImage imageNamed:@"activityMap"];
    [self.contentView addSubview:self.addressImageView];
    
    self.addressLabel = [UILabel new];
    self.addressLabel.font = [UIFont systemFontOfSize:14.5f];
    self.addressLabel.textColor = [UIColor colorWithHexString:@"#AFAEAD"];
    [self.contentView addSubview:self.addressLabel];
    
    self.instantImageView = [UIImageView new];
    self.instantImageView.image = [UIImage imageNamed:@"activityBooked"];
    [self.contentView addSubview:self.instantImageView];
    
    self.instantLabel = [UILabel new];
    self.instantLabel.font = [UIFont systemFontOfSize:14.5f];
    self.instantLabel.textColor = [UIColor colorWithHexString:@"#AFAEAD"];
    [self.contentView addSubview:self.instantLabel];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#E0DFDD"];
    [self.contentView addSubview:self.separatorView];
    
    self.fastImageView = [UIImageView new];
    self.fastImageView.image = [UIImage imageNamed:@"activityFast"];
    [self.contentView addSubview:self.fastImageView];
    
    self.fastLabel = [UILabel new];
    self.fastLabel.text = [XBLanguageControl localizedStringForKey:@"activity-detail-instant"];
    self.fastLabel.font = [UIFont systemFontOfSize:14.f];
    self.fastLabel.textColor = defaultColor;
    [self.contentView addSubview:self.fastLabel];
    
    self.fastTipLabel = [UILabel new];
    self.fastTipLabel.text = [XBLanguageControl localizedStringForKey:@"activity-detail-fast"];
    self.fastTipLabel.font = [UIFont systemFontOfSize:11.5f];
    self.fastTipLabel.textColor = [UIColor colorWithHexString:@"#AFAEAD"];
    [self.contentView addSubview:self.fastTipLabel];
    
    self.descLabel = [UILabel new];
    self.descLabel.numberOfLines = 0;
    self.descLabel.font = [UIFont systemFontOfSize:15.f];
    self.descLabel.textColor = [UIColor colorWithHexString:@"#6C6C6B"];
    [self.contentView addSubview:self.descLabel];
    
    self.detailItemView = [XBActivityItemView new];
    self.detailItemView.delegate = self;
    [self.contentView addSubview:self.detailItemView];
    
    self.readMoreButton = [UIButton new];
    self.readMoreButton.layer.borderWidth = 1.f;
    self.readMoreButton.layer.borderColor = defaultColor.CGColor;
    self.readMoreButton.layer.masksToBounds = YES;
    self.readMoreButton.layer.cornerRadius  = 5.f;
    self.readMoreButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.readMoreButton setTitle:[XBLanguageControl localizedStringForKey:@"activity-detail-readmore"] forState:UIControlStateNormal];
    [self.readMoreButton setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.readMoreButton setBackgroundColor:[UIColor clearColor]];
    [self.readMoreButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.readMoreButton];
    
    self.recommendButton = [UIButton new];
    self.recommendButton.layer.borderWidth = 1.f;
    self.recommendButton.layer.borderColor = defaultColor.CGColor;
    self.recommendButton.layer.masksToBounds = YES;
    self.recommendButton.layer.cornerRadius  = 5.f;
    self.recommendButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.recommendButton setTitle:[XBLanguageControl localizedStringForKey:@"activity-detail-recommend"] forState:UIControlStateNormal];
    [self.recommendButton setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.recommendButton setBackgroundColor:[UIColor clearColor]];
    [self.recommendButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.recommendButton];
    
    self.durationNotifyView = [XBNotifyView new];
    self.durationNotifyView.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-notify-duration"];
    self.durationNotifyView.imageView.image = [UIImage imageNamed:@"activity_time"];
    [self.contentView addSubview:self.durationNotifyView];
    
    self.languageNotifyView = [XBNotifyView new];
    self.languageNotifyView.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-notify-language"];
    self.languageNotifyView.imageView.image = [UIImage imageNamed:@"activity_lang"];
    [self.contentView addSubview:self.languageNotifyView];
    
    self.recommendedNumberNotifyView = [XBNotifyView new];
    self.recommendedNumberNotifyView.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-notify-recommendedNumber"];
    self.recommendedNumberNotifyView.imageView.image = [UIImage imageNamed:@"activity_head_count"];
    [self.contentView addSubview:self.recommendedNumberNotifyView];
    
    self.transportationNotifyView = [XBNotifyView new];
    self.transportationNotifyView.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-notify-transportation"];
    self.transportationNotifyView.imageView.image = [UIImage imageNamed:@"activity_pickup"];
    [self.contentView addSubview:self.transportationNotifyView];
    
    self.confirmationNotifyView = [XBNotifyView new];
    self.confirmationNotifyView.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-notify-confirmation"];
    self.confirmationNotifyView.imageView.image = [UIImage imageNamed:@"activity_confirm"];
    [self.contentView addSubview:self.confirmationNotifyView];
    
    self.cancellationNotifyView = [XBNotifyView new];
    self.cancellationNotifyView.titleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-notify-cancellation"];
    self.cancellationNotifyView.imageView.image = [UIImage imageNamed:@"activity_refund"];
    [self.contentView addSubview:self.cancellationNotifyView];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = NO;
    self.mapView.showsCompass = YES;
    self.mapView.showsPointsOfInterest = YES;
    [self.contentView addSubview:self.mapView];
    
    self.reviewsLabel = [UILabel new];
    self.reviewsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.f];
    self.reviewsLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.reviewsLabel];
    
    UIImage *starImage = [[UIImage imageNamed:@"star-template"] imageContentWithColor:defaultColor];
    
    self.starImageView1 = [UIImageView new];
    self.starImageView1.image = starImage;
    [self.contentView addSubview:self.starImageView1];
    
    self.starImageView2 = [UIImageView new];
    self.starImageView2.image = starImage;
    [self.contentView addSubview:self.starImageView2];
    
    self.starImageView3 = [UIImageView new];
    self.starImageView3.image = starImage;
    [self.contentView addSubview:self.starImageView3];
    
    self.starImageView4 = [UIImageView new];
    self.starImageView4.image = starImage;
    [self.contentView addSubview:self.starImageView4];
    
    self.starImageView5 = [UIImageView new];
    self.starImageView5.image = starImage;
    [self.contentView addSubview:self.starImageView5];
    
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
    [self.reviewsReadMoreButton setTitle:[XBLanguageControl localizedStringForKey:@"activity-detail-readmore"] forState:UIControlStateNormal];
    [self.reviewsReadMoreButton setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.reviewsReadMoreButton setBackgroundColor:[UIColor clearColor]];
    [self.reviewsReadMoreButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.reviewsReadMoreButton];
    
    self.reviewsSeparatorView = [UIView new];
    self.reviewsSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#E0DFDD"];
    [self.contentView addSubview:self.reviewsSeparatorView];
    
    self.directionTitleLabel = [UILabel new];
    self.directionTitleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-detail-direction"];
    self.directionTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    self.directionTitleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.directionTitleLabel];
    
    self.confirmTitleLabel = [UILabel new];
    self.confirmTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    self.confirmTitleLabel.textColor = defaultColor;
    [self.contentView addSubview:self.confirmTitleLabel];
    
    self.confirmSuccessLabel = [XBActivityItemView new];
    self.confirmSuccessLabel.delegate = self;
    [self.contentView addSubview:self.confirmSuccessLabel];
    
    self.confirmEmailLabel = [XBActivityItemView new];
    self.confirmEmailLabel.delegate = self;
    [self.contentView addSubview:self.confirmEmailLabel];
    
    self.packageTitleLabel = [UILabel new];
    self.packageTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    self.packageTitleLabel.textColor = defaultColor;
    [self.contentView addSubview:self.packageTitleLabel];
    
    self.directionReadMoreButton = [UIButton new];
    self.directionReadMoreButton.layer.borderWidth = 1.f;
    self.directionReadMoreButton.layer.borderColor = defaultColor.CGColor;
    self.directionReadMoreButton.layer.masksToBounds = YES;
    self.directionReadMoreButton.layer.cornerRadius  = 5.f;
    self.directionReadMoreButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.directionReadMoreButton setTitle:[XBLanguageControl localizedStringForKey:@"activity-detail-readmore"] forState:UIControlStateNormal];
    [self.directionReadMoreButton setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.directionReadMoreButton setBackgroundColor:[UIColor clearColor]];
    [self.directionReadMoreButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.directionReadMoreButton];
    
    self.directionSeparatorView = [UIView new];
    self.directionSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#E0DFDD"];
    [self.contentView addSubview:self.directionSeparatorView];
    
    self.useTitleLabel = [UILabel new];
    self.useTitleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-detail-use"];
    self.useTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    self.useTitleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.useTitleLabel];
    
    self.useView = [UIView new];
    self.useView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.useView];
    
    self.noticeTitleLabel = [UILabel new];
    self.noticeTitleLabel.text = [XBLanguageControl localizedStringForKey:@"activity-detail-notice"];
    self.noticeTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    self.noticeTitleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.noticeTitleLabel];
    
    self.noticeView = [UIView new];
    self.noticeView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.noticeView];
    
    [self addConstraint];
}

- (void)addConstraint
{
    [self.favoriteButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView).offset(-kSpace * 1.);
        make.right.equalTo(self.headerView).offset(-kSpace * 1.5);
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(CGRectGetHeight(self.headerView.frame));
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kSpace * 2.3);
        make.left.equalTo(self.contentView).offset(kSpace);
    }];
    
    [self.sellLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kSpace);
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.right).offset(kSpace);
//        make.width.mas_greaterThanOrEqualTo(50.f);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(kSpace * 0.4);
        make.right.equalTo(self.titleLabel);
//        make.height.mas_greaterThanOrEqualTo(30.f);
    }];
    
    [self.markLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sellLabel.bottom).offset(kSpace * 0.5);
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
        make.right.equalTo(self.contentView).offset(-kSpace * 1.5);
    }];
    
    [self.detailItemView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLabel).offset(kSpace);
        make.top.equalTo(self.descLabel.bottom).offset(kSpace * 1.7);
        make.right.equalTo(self.descLabel).offset(-kSpace);
    }];
    
    [self.readMoreButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailItemView);
        make.top.equalTo(self.detailItemView.bottom).offset(kSpace * 3.5);
        make.height.mas_equalTo(38.f);
    }];
    
    [self.recommendButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.readMoreButton);
        make.right.equalTo(self.detailItemView);
        make.height.equalTo(self.readMoreButton);
        make.left.equalTo(self.readMoreButton.right).offset(kSpace * 3.5);
        make.width.equalTo(self.readMoreButton);
    }];
    
    [self.languageNotifyView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
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
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.transportationNotifyView.bottom).offset(kSpace * 4);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(130.f);
    }];
    
    [self.reviewsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.mapView.bottom).offset(kSpace * 4);
    }];
    
    [self.starImageView3 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
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
        make.left.equalTo(self.contentView).offset(kSpace);
        make.right.equalTo(self.contentView).offset(-kSpace);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.directionTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.reviewsSeparatorView.bottom).offset(kSpace * 4);
    }];
    
    [self.confirmTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kSpace * 1.4);
        make.top.equalTo(self.directionTitleLabel.bottom).offset(kSpace * 3);
    }];
    
    [self.confirmSuccessLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmTitleLabel).offset(kSpace * 0.8);
        make.top.equalTo(self.confirmTitleLabel.bottom).offset(kSpace * 0.5);
        make.right.equalTo(self.contentView).offset(-kSpace * 2);
    }];
    
    [self.confirmEmailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmTitleLabel).offset(kSpace);
        make.top.equalTo(self.confirmSuccessLabel.bottom).offset(kSpace);
        make.right.equalTo(self.contentView).offset(-kSpace * 2);
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
        make.left.equalTo(self.contentView).offset(kSpace);
        make.right.equalTo(self.contentView).offset(-kSpace);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.useTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.directionSeparatorView.bottom).offset(kSpace * 3.5);
    }];
    
    [self.useView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.useTitleLabel.bottom).offset(kSpace * 3.5);
        make.right.equalTo(self.contentView);
    }];
    
    [self.noticeTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.useView.bottom).offset(kSpace * 3.5);
    }];
    
    [self.noticeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.noticeTitleLabel.bottom).offset(kSpace * 3.5);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-kSpace * 4);
    }];
    
    [self.tagLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView.bottom).offset(kSpace * 4);
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
            
            self.details = datas;
        }
        
    }];
    
    [XBParserUtils parserWithContent:self.activity.directionsAndLocation regex:@".+" complete:^(NSArray *datas) {
        
        if (datas.count > 0) {
            
            XBParserContent *content = [datas firstObject];
            
            self.confirmTitleLabel.text = content.title;
            
            if (content.items.count > 0) {
                
                XBParserContentItem *item = [content.items firstObject];
                
                self.confirmSuccessLabel.parserContentItem = item;
                
                if (content.items.count >= 2) {
                    
                    XBParserContentItem *emailItem = content.items[1];
                    
                    self.confirmEmailLabel.parserContentItem = emailItem;
                    
                } else {
                    
                    [self.confirmEmailLabel updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.equalTo(self.confirmSuccessLabel.bottom).offset(kSpace);
                        
                    }];
                    
                    self.confirmEmailLabel.hidden = YES;
                    
                }
            }
            
            if (datas.count >= 2) {
                
                XBParserContent *package = datas[1];
                
                self.packageTitleLabel.text = package.title;
                
                self.directions = datas;
                
            }
        }
        
    }];
    
    [XBParserUtils parserWithContent:self.activity.termsAndConditions regex:@"- .*" complete:^(NSArray *datas) {
        
        if (datas.count > 0) {
            
            XBParserContent *content = [datas firstObject];
            
            for (XBParserContentItem *item in content.items) {
                
                XBActivityItemView *itemView = [XBActivityItemView new];
                
                itemView.delegate = self;
                
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
                
                itemView.delegate = self;
                
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
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.markLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    
    self.markLabel.attributedText = attribtStr;
    
}

#pragma mark -- XBActivityItemViewDelegate
- (void)activityItemView:(XBActivityItemView *)activityItemView didSelectLinkWithURL:(NSURL *)url
{
    if ([self.delegate respondsToSelector:@selector(stretchableActivityView:didSelectLinkWithURL:)]) {
        [self.delegate stretchableActivityView:self didSelectLinkWithURL:url];
    }
}

#pragma mark -- MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    DDLogDebug(@"点击大头针.....");
}

- (UIButton *)mapLocationButton
{
    if (!_mapLocationButton) {
        
        _mapLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_mapLocationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_mapLocationButton setTitle:self.activity.name forState:UIControlStateNormal];
        
        [_mapLocationButton setBackgroundColor:[UIColor whiteColor]];
    
        [self.mapView addSubview:_mapLocationButton];
    }
    return _mapLocationButton;
}

- (void)clickAction:(UIButton *)sender
{
    if (sender == self.directionReadMoreButton) {
        
        if ([self.delegate respondsToSelector:@selector(stretchableActivityView:didSelectDirectionWithParserContent:)]) {
            
            [self.delegate stretchableActivityView:self didSelectDirectionWithParserContent:self.directions];
            
        }
        
    } else if (sender == self.reviewsReadMoreButton) {
        
        if ([self.delegate respondsToSelector:@selector(stretchableActivityView:didSelectReviewWithReviewCount:)]) {
            
            [self.delegate stretchableActivityView:self didSelectReviewWithReviewCount:self.activity.reviewsCount];
            
        }
        
    } else if (sender == self.recommendButton) {
        
        if ([self.delegate respondsToSelector:@selector(stretchableActivityView:didSelectRecommendWithText:)]) {
            
            [self.delegate stretchableActivityView:self didSelectRecommendWithText:self.activity.recommend];
            
        }
        
    } else if (sender == self.readMoreButton) {
        
        if ([self.delegate respondsToSelector:@selector(stretchableActivityView:didSelectDetailWithParserContent:)]) {
            
            [self.delegate stretchableActivityView:self didSelectDetailWithParserContent:self.details];
            
        }

    } else if (sender == self.favoriteButton) {
        
        if ([self.delegate respondsToSelector:@selector(stretchableActivityView:didSelectFavoriteWithActivity:)]) {
            
            [self.delegate stretchableActivityView:self didSelectFavoriteWithActivity:self.activity];
            
        }
        
    }
}


@end
