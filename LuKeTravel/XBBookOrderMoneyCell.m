//
//  XBBookOrderMoneyCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBBookOrderMoneyCell.h"

@implementation XBBookOrderMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.separatorConstraint.constant = 0.7f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
