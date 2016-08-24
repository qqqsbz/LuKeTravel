//
//  XBOrderBookCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderBookCell.h"
#import "NSString+Util.h"
#import "XBOrderBookPrice.h"
@implementation XBOrderBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSLayoutConstraint *constraint in self.separatorConstraints) {
        constraint.constant = 0.5f;
    }
    
    self.nameLabel.text = [XBLanguageControl localizedStringForKey:@"activity-order-name"];
    
    self.unitNameLabel.text = [XBLanguageControl localizedStringForKey:@"activity-order-unitname"];
}

- (void)setOrderBookPrice:(XBOrderBookPrice *)orderBookPrice
{
    _orderBookPrice = orderBookPrice;
    
    self.nameLabel.text = orderBookPrice.name;
    
    self.unitNameLabel.text = [orderBookPrice.unitName clearBlack].length > 0 ? orderBookPrice.unitName : self.unitNameLabel.text;
    
    self.sellLabel.text  = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],[NSIntegerFormatter formatToNSString:orderBookPrice.price]];
    
    self.markLabel.text = [NSString stringWithFormat:@"%@ %@",[XBUserDefaultsUtil currentCurrencySymbol],[NSIntegerFormatter formatToNSString:orderBookPrice.marketPrice]];
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:self.markLabel.text attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    self.markLabel.attributedText = attribtStr;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)addAction:(UIButton *)sender {
    
    
    NSInteger count = [self.countLabel.text integerValue];
    
    if (count > self.orderBookPrice.maxNum) {
        
        if ([self.delegate respondsToSelector:@selector(orderBookCell:exceedMax:)]) {
            
            [self.delegate orderBookCell:self exceedMax:self.orderBookPrice.maxNum];
        }
        
        return;
    }
    
    count += 1;
    
    self.countLabel.text = [NSIntegerFormatter formatToNSString:count];

    [self calculateCount:YES];
}


- (IBAction)reduceAction:(UIButton *)sender {

    NSInteger count = [self.countLabel.text integerValue];
    
    if (count <= 0) return;
    
    count -= 1;
    
    self.countLabel.text = [NSIntegerFormatter formatToNSString:count];
    
    [self calculateCount:NO];
}

- (void)calculateCount:(BOOL)isPlus
{
    if ([self.delegate respondsToSelector:@selector(orderBookCell:didSelectCountWithOrderBookPrice:isPlus:)]) {
        
        [self.delegate orderBookCell:self didSelectCountWithOrderBookPrice:self.orderBookPrice isPlus:isPlus];
        
    }
}

@end
