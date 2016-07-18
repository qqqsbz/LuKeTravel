//
//  XBHomeSearchActivityClickCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeSearchActivityClickCell.h"
#import "XBSearchItem.h"
@implementation XBHomeSearchActivityClickCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pirceView.clipsToBounds = YES;
    
    self.pirceView.layer.masksToBounds = YES;
    
    self.pirceView.layer.cornerRadius  = 5.f;
    
    self.substanceView.layer.masksToBounds = YES;
    
    self.substanceView.layer.cornerRadius  = 5.f;

}

- (void)setGroupItem:(XBSearchItem *)groupItem
{
    _groupItem = groupItem;
    
    self.instantImageView.hidden = !groupItem.instant;
    self.titleLabel.text    = groupItem.name;
    self.subTitleLabel.text = groupItem.subName;
    self.addressLabel.text  = groupItem.cityName;
    self.participantsLabel.text = [NSIntegerFormatter formatToNSString:groupItem.participants];
    self.sellingPriceLabel.text  = [NSString stringWithFormat:@"￥%@",[NSIntegerFormatter formatToNSString:groupItem.marketPrice]];
    self.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@",[NSIntegerFormatter formatToNSString:groupItem.sellingPrice]];
    self.favoriteImageView.image = [UIImage imageNamed:groupItem.favorite ? @"activityWishSelected" : @"activityWishNormal"];
    [self loadImageFromCacheWithImageView:self.coverImageView];
    
    NSMutableAttributedString *markAttributedString = [[NSMutableAttributedString alloc] initWithString:self.marketPriceLabel.text];
    [markAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:22.f] range:NSMakeRange(1, self.marketPriceLabel.text.length - 1)];
    self.marketPriceLabel.attributedText = markAttributedString;
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.sellingPriceLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    self.sellingPriceLabel.attributedText = attribtStr;

}

- (void)loadImageFromCacheWithImageView:(UIImageView *)imageView
{
    //查看是否有缓存
    BOOL isCache  = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:self.groupItem.imageUrl] ||[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.groupItem.imageUrl];
    
    //没有缓存则 下载图片并进行缓存
    if (!isCache) {
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.groupItem.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
