//
//  XBPayUseCouponCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPayUseCouponCell.h"
#import "XBCoupons.h"
@implementation XBPayUseCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSLayoutConstraint *constraint in self.separatorConstraints) {
        
        constraint.constant = 0.5f;
    }
}

- (void)setCoupons:(XBCoupons *)coupons
{
    _coupons = coupons;
    
    self.priceLabel.text = coupons.discountDesc;
    
    self.fromLabel.text = coupons.specialDesc;
    
    self.endLabel.text = coupons.endDate;
    
    self.nouseLabel.text = coupons.discountDesc;
    
    self.priceLabel.hidden = !coupons.usable;
    
    self.fromLabel.hidden = !coupons.usable;
    
    self.endLabel.hidden = !coupons.usable;
    
    self.nouseLabel.hidden = coupons.usable;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
