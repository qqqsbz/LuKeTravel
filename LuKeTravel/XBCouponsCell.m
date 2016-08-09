//
//  XBCouponsCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/5.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCouponsCell.h"
#import "XBCoupons.h"
@implementation XBCouponsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.substanceView.layer.masksToBounds = YES;
    
    self.substanceView.layer.cornerRadius  = 6.f;
}

- (void)setCoupos:(XBCoupons *)coupos
{
    self.priceLabel.text = coupos.discountDesc;
    
    self.codeLabel.text = coupos.code;
    
    self.fromLabel.text = coupos.specialDesc;
    
    self.conditionLabel.text = coupos.desc;
    
    self.expireLabel.text = coupos.endDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
