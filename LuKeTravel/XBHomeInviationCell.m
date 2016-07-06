//
//  XBHomeInviationCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeInviationCell.h"
#import "XBInviation.h"
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
    
    self.shapeLayer.path = [UIBezierPath bezierPathWithRect:self.coverImageView.bounds].CGPath;
    
    [self.coverImageView.layer addSublayer:self.shapeLayer];
}

- (void)setInviation:(XBInviation *)inviation
{
    _inviation = inviation;
    
    self.titleLabel.text = inviation.name;
    self.subTitleLabel.text = inviation.subName;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:inviation.imageUrl]];
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
