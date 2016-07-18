//
//  XBHomeInviationCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeInviationCell.h"
#import "XBInviation.h"
#import <SDImageCache.h>
@interface XBHomeInviationCell()
@property (strong, nonatomic) CAShapeLayer  *shapeLayer;
@end
@implementation XBHomeInviationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.inviationButton.layer.masksToBounds = YES;
    self.inviationButton.layer.cornerRadius  = 7.f;
    
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.layer.cornerRadius  = 7.f;
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.25f].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.coverImageView layoutIfNeeded];
    
    self.shapeLayer.path = [UIBezierPath bezierPathWithRect:self.coverImageView.bounds].CGPath;
    
    [self.coverImageView.layer addSublayer:self.shapeLayer];
}

- (void)setInviation:(XBInviation *)inviation
{
    _inviation = inviation;
    
    self.titleLabel.text = inviation.name;
    
    self.subTitleLabel.text = inviation.subName;
    
    //查看是否有缓存
    BOOL isCache = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:inviation.imageUrl] || [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:inviation.imageUrl];
    
    if (!isCache) {
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:inviation.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
            [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL.absoluteString];
            
        }];
        
    } else {
        //优先从内存中读取缓存 如果内存中没有缓存则读取磁盘
        UIImage *cacheImage;
        if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:inviation.imageUrl]) {
            
            cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:inviation.imageUrl];
            
        } else {
            
            cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:inviation.imageUrl];
            
        }
        
        self.coverImageView.image = cacheImage;
    }

}

- (IBAction)closeAction:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(inviationCellDidSelectedClose)]) {
        [self.delegate inviationCellDidSelectedClose];
    }
}

- (IBAction)inviationAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(inviationCellDidSelectedGo)]) {
        [self.delegate inviationCellDidSelectedGo];
    }
}

@end
