//
//  XBPayWayCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPayWayCell.h"

@implementation XBPayWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorConstraint.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
