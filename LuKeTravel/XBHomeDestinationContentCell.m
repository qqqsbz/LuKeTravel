//
//  XBHomeDestinationContentCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeDestinationContentCell.h"
#import "XBGroupItem.h"

@interface XBHomeDestinationContentCell()
@property (strong, nonatomic) CAShapeLayer  *shapeLayer;
@end
@implementation XBHomeDestinationContentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    
    self.layer.cornerRadius  = 7.f;
    
    self.shapeLayer = [CAShapeLayer layer];
    
    self.shapeLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.25f].CGColor;
}

- (void)setGroupItem:(XBGroupItem *)groupItem
{
    _groupItem = groupItem;
    
    self.titleLabel.text = groupItem.name;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:groupItem.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.coverImageView layoutIfNeeded];
    
    self.shapeLayer.path = [UIBezierPath bezierPathWithRect:self.coverImageView.bounds].CGPath;
    
    [self.coverImageView.layer addSublayer:self.shapeLayer];
}


@end
