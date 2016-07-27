


//
//  XBActivityPackageCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBActivityPackageCell.h"
#import "XBPackage.h"
@implementation XBActivityPackageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setPackage:(XBPackage *)package
{
    _package = package;
    
    self.titleLabel.text = package.name;
    self.subTitleLabel.text = package.subName;
    self.sellLabel.text = [NSString stringWithFormat:@"￥ %@",[NSIntegerFormatter formatToNSString:package.sellPrice]];
    self.markerLabel.text =  [NSString stringWithFormat:@"￥ %@",[NSIntegerFormatter formatToNSString:package.marketPrice]];
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.markerLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    self.markerLabel.attributedText = attribtStr;
}

- (void)setPickSelected:(BOOL)pickSelected
{
    _pickSelected = pickSelected;
    
    self.pickImageView.image = [UIImage imageNamed:pickSelected ? @"pick_package_selected" : @"pick_package"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
