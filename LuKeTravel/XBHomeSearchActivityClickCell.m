//
//  XBHomeSearchActivityClickCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeSearchActivityClickCell.h"
#import "XBSearchItem.h"
#import "XBGroupItem.h"
@implementation XBHomeSearchActivityClickCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pirceView.clipsToBounds = YES;
    
    self.pirceView.layer.masksToBounds = YES;
    
    self.pirceView.layer.cornerRadius  = 5.f;
    
    self.substanceView.layer.masksToBounds = YES;
    
    self.substanceView.layer.cornerRadius  = 5.f;

}

- (void)setSearchItem:(XBSearchItem *)searchItem
{
    _searchItem = searchItem;
    
    self.instantImageView.hidden = !searchItem.instant;
    
    self.titleLabel.text    = searchItem.name;
    
    self.subTitleLabel.text = searchItem.subName;
    
    self.addressLabel.text  = searchItem.cityName;
    
    self.participantsLabel.text = searchItem.participantsFormat;
    
    self.sellingPriceLabel.text  = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],[NSIntegerFormatter formatToNSString:searchItem.marketPrice]];
    
    self.marketPriceLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],[NSIntegerFormatter formatToNSString:searchItem.sellingPrice]];
    
    [self.favoriteButton setImage:[UIImage imageNamed:searchItem.favorite ? @"activityWishSelected" : @"activityWishNormal"] forState:UIControlStateNormal];
    
    [self loadImageFromCacheWithImageView:self.coverImageView imageUrl:searchItem.imageUrl];
    
    BOOL cityEmpty = searchItem.cityName.length <= 0;
    
    self.participantsLabel.hidden = cityEmpty;
    
    self.participantsImageView.hidden = cityEmpty;
    
    self.favorite = searchItem.favorite;
    
    if (cityEmpty) {
        
        self.addressLabel.text = searchItem.participantsFormat;
        
        self.addressImageView.image = [UIImage imageNamed:[searchItem.hotState isEqualToString:@"new"] ? @"activityNew" : @"activityBooked"];
        
    } else {
        
        self.addressLabel.text = searchItem.cityName;
        
        self.addressImageView.image = [UIImage imageNamed:@"activityMap"];
        
    }
    
    NSMutableAttributedString *markAttributedString = [[NSMutableAttributedString alloc] initWithString:self.marketPriceLabel.text];
    [markAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20.f] range:NSMakeRange(1, self.marketPriceLabel.text.length - 1)];
    self.marketPriceLabel.attributedText = markAttributedString;
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.sellingPriceLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    self.sellingPriceLabel.attributedText = attribtStr;

}

- (void)setFavorite:(BOOL)favorite
{
    _favorite = favorite;
    
    self.searchItem.favorite = favorite;
    
    [self.favoriteButton setImage:[UIImage imageNamed:favorite ? @"activityWishSelected" : @"activityWishNormal"] forState:UIControlStateNormal];
}

- (void)loadImageFromCacheWithImageView:(UIImageView *)imageView imageUrl:(NSString *)imageUrl
{
    //查看是否有缓存
    BOOL isCache  = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageUrl] ||[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    
    //没有缓存则 下载图片并进行缓存
    if (!isCache) {
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL.absoluteString];
            
        }];
        
    } else {
        
        //优先从内存中读取缓存 如果内存中没有缓存则读取磁盘
        UIImage *cacheImage;
        if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageUrl]) {
            
            cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageUrl];
            
        } else {
            
            cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
            
        }
        
        imageView.image = cacheImage;
        
    }
}

- (IBAction)favoriteAction:(UIButton *)sender {
    
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
    
    springAnimation.damping = 5.f;
    
    springAnimation.stiffness = 2000.f;
    
    springAnimation.mass = 5;
    
    springAnimation.initialVelocity = 10;
    
    springAnimation.fromValue = @(1);
    
    springAnimation.toValue = @(1.165);
    
    springAnimation.duration = 0.7;
    
    [self.favoriteButton.layer addAnimation:springAnimation forKey:@"SpringAnimation"];
    
    if ([self.delegate respondsToSelector:@selector(searchActivityClickCell:didSelectFavorite:)]) {
        [self.delegate searchActivityClickCell:self didSelectFavorite:self.searchItem];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
