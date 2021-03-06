//
//  XBHomeActivityContentCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeActivityContentCell.h"
#import "XBGroupItem.h"
@interface XBHomeActivityContentCell()

@property (strong, nonatomic) IBOutlet UIImageView   *instantCoverImageView;
@property (strong, nonatomic) IBOutlet UILabel       *instantTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel       *instantSubTitleLabel;

@property (strong, nonatomic) IBOutlet UIImageView   *coverImageView;
@property (strong, nonatomic) IBOutlet UIButton      *favoriteButton;
@property (strong, nonatomic) IBOutlet UIView        *pirceView;
@property (strong, nonatomic) IBOutlet UILabel       *marketPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel       *sellingPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel       *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView   *instantImageView;
@property (strong, nonatomic) IBOutlet UILabel       *subTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView   *addressImageView;
@property (strong, nonatomic) IBOutlet UILabel       *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView   *participantsImageView;
@property (strong, nonatomic) IBOutlet UILabel       *participantsLabel;

@property (strong, nonatomic) CAShapeLayer  *shapeLayer;

@end
@implementation XBHomeActivityContentCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.coverImageView.clipsToBounds = YES;
    
    self.pirceView.layer.masksToBounds = YES;
    
    self.pirceView.layer.cornerRadius  = 5.f;
    
    self.shapeLayer = [CAShapeLayer layer];
    
    self.shapeLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.25f].CGColor;
    
    self.instantImageView.clipsToBounds = YES;
}

- (void)setGroupItem:(XBGroupItem *)groupItem
{
    _groupItem = groupItem;
    
    [self checkIsInstant];
    
    if (groupItem.hotState.length > 0) {
        
        self.titleLabel.text    = groupItem.name;
        
        self.subTitleLabel.text = groupItem.subName;
        
        self.addressLabel.text  = groupItem.cityName;
        
        self.participantsLabel.text = groupItem.participants;
        
        self.marketPriceLabel.text  = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],groupItem.marketPrice];
        
        self.sellingPriceLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],groupItem.sellingPrice];
        
        [self.favoriteButton setImage:[UIImage imageNamed:groupItem.favorite ? @"activityWishSelected" : @"activityWishNormal"] forState:UIControlStateNormal];
        
        [self loadImageFromCacheWithImageView:self.coverImageView];
        
        NSMutableAttributedString *sellAttributedString = [[NSMutableAttributedString alloc] initWithString:self.sellingPriceLabel.text];
        
        [sellAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:12.f] range:NSMakeRange(0, 1)];
        
        self.sellingPriceLabel.attributedText = sellAttributedString;
        
        NSMutableAttributedString *markAttribtStr = [[NSMutableAttributedString alloc] initWithString:self.marketPriceLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        
        self.marketPriceLabel.attributedText = markAttribtStr;
        
        if (groupItem.cityName.length <= 0) {
            
            self.participantsImageView.hidden = YES;
            
            self.participantsLabel.hidden = YES;
            
            self.addressImageView.image = self.participantsImageView.image;
            
            self.addressLabel.text =groupItem.participants;
            
        } else {
            
            self.participantsImageView.hidden = NO;
            
            self.participantsLabel.hidden = NO;
            
            self.addressImageView.image = [UIImage imageNamed:@"activityMap"];
            
            self.addressLabel.text = groupItem.cityName;
            
            self.participantsLabel.text = groupItem.participants;
            
            self.participantsImageView.image = [UIImage imageNamed:@"activityBooked"];
            
        }
        
    } else {
        
        self.instantTitleLabel.text = groupItem.name;
        
        self.instantSubTitleLabel.text = groupItem.subName;
        
        [self loadImageFromCacheWithImageView:self.instantCoverImageView];
        
    }
    
    self.instantImageView.hidden = !groupItem.instant;
    
}

- (void)setFavorite:(BOOL)favorite
{
    _favorite = favorite;
    
    [self.favoriteButton setImage:[UIImage imageNamed:favorite ? @"activityWishSelected" : @"activityWishNormal"] forState:UIControlStateNormal];
}

- (void)loadImageFromCacheWithImageView:(UIImageView *)imageView
{
    //查看是否有缓存
    BOOL isCache  = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:self.groupItem.imageUrl] || [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.groupItem.imageUrl];
    
    //没有缓存则 下载图片并进行缓存
    if (!isCache) {
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.groupItem.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL.absoluteString];
            
        }];
        
    } else {
        
        //优先从内存中读取缓存 如果内存中没有缓存则读取磁盘
        UIImage *cacheImage;
        if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:self.groupItem.imageUrl]) {
            
            cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:self.groupItem.imageUrl];
            
        } else {
            
            cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.groupItem.imageUrl];
            
        }
        
        imageView.image = cacheImage;
        
    }
}

- (void)checkIsInstant
{
    BOOL isInstant = self.groupItem.hotState.length > 0;
    
    self.instantCoverImageView.hidden = isInstant;
    self.instantSubTitleLabel.hidden  = isInstant;
    self.instantTitleLabel.hidden     = isInstant;
    
    self.titleLabel.hidden = !isInstant;
    self.subTitleLabel.hidden = !isInstant;
    self.addressLabel.hidden = !isInstant;
    self.participantsLabel.hidden = !isInstant;
    self.marketPriceLabel.hidden = !isInstant;
    self.sellingPriceLabel.hidden = !isInstant;
    self.favoriteButton.hidden = !isInstant;
    self.coverImageView.hidden = !isInstant;
    self.pirceView.hidden = !isInstant;
    self.instantImageView.hidden = !isInstant;
    self.addressLabel.hidden = !isInstant;
    self.addressImageView.hidden = !isInstant;
    self.participantsLabel.hidden = !isInstant;
    self.participantsImageView.hidden = !isInstant;
}

- (IBAction)favoriteAction:(UIButton *)sender {
    
    [self startFavoriteAnimation];
    
    if ([self.delegate respondsToSelector:@selector(homeActivityContentCell:didSelectFavoriteWithGroupItem:)]) {
        
        [self.delegate homeActivityContentCell:self didSelectFavoriteWithGroupItem:self.groupItem];
    }

}

- (void)startFavoriteAnimation
{
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
    
    springAnimation.damping = 5.f;
    
    springAnimation.stiffness = 2000.f;
    
    springAnimation.mass = 5;
    
    springAnimation.initialVelocity = 10;
    
    springAnimation.fromValue = @(1);
    
    springAnimation.toValue = @(1.165);
    
    springAnimation.duration = 0.7;
    
    [self.favoriteButton.layer addAnimation:springAnimation forKey:@"SpringAnimation"];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.instantCoverImageView layoutIfNeeded];
    
    self.shapeLayer.path = [UIBezierPath bezierPathWithRect:self.instantCoverImageView.bounds].CGPath;
    
    [self.instantCoverImageView.layer addSublayer:self.shapeLayer];
}

@end
