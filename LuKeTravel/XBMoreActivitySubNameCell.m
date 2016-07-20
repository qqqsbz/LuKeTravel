//
//  XBMoreActivitySubNameCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBMoreActivitySubNameCell.h"
#import "XBMoreActivitySort.h"
@implementation XBMoreActivitySubNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bottomSeparatorConstraint.constant = 0.5f;
}

- (void)setSort:(XBMoreActivitySort *)sort
{
    _sort = sort;
    
    self.titleLabel.text = sort.name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
