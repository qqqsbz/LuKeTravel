//
//  XBOrderConfirmBasicCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderConfirmBasicCell.h"

@implementation XBOrderConfirmBasicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        
        constraint.constant = 0.5f;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (IBAction)pullAction:(UIButton *)sender {
}

@end
