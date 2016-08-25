//
//  XBHomeDestinationContentCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeDestinationContentCell.h"
#import "XBGroupItem.h"
@implementation XBHomeDestinationContentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    
    self.layer.cornerRadius  = 7.f;
}

- (void)setGroupItem:(XBGroupItem *)groupItem
{
    _groupItem = groupItem;
    
    self.titleLabel.text = groupItem.name;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:groupItem.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
}

@end
