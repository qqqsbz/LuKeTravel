//
//  XBDestinationCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDestinationHotCell.h"
#import "XBHotDestination.h"
@interface XBDestinationHotCell()
@end
@implementation XBDestinationHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shapeLayer = [CAShapeLayer layer];
    
    self.shapeLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.2f].CGColor;
}

- (void)setHotDestination:(XBHotDestination *)hotDestination
{
    _hotDestination = hotDestination;
    
    self.titleLabel.text = hotDestination.name;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:hotDestination.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.shapeLayer.path = [UIBezierPath bezierPathWithRect:self.coverImageView.bounds].CGPath;
    
    [self.coverImageView.layer addSublayer:self.shapeLayer];
}

@end
