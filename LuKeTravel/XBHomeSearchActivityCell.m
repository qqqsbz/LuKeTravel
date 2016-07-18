//
//  XBHomeSearchCityCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeSearchActivityCell.h"
#import "XBSearchItem.h"
@implementation XBHomeSearchActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSearchItem:(XBSearchItem *)searchItem
{
    _searchItem = searchItem;
    
    self.titleLabel.text = searchItem.name;
    
    self.subTitleLabel.text = searchItem.cityName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
