//
//  XBHomeHeaderCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeHeaderCell.h"
#import "XBGroup.h"
@implementation XBHomeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setGroup:(XBGroup *)group
{
    _group = group;
    
    self.titleLabel.text = group.className;
    
    [self.subTitleButton setTitle:group.displayText forState:UIControlStateNormal];
}

- (IBAction)cityAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(homeHeaderCell:didSelectCityWithCityId:)]) {
        
        [self.delegate homeHeaderCell:self didSelectCityWithCityId:[self.group.modelId integerValue]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
