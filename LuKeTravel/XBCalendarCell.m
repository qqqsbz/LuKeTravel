//
//  XBCalendarCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCalendarCell.h"
@interface XBCalendarCell()
@property (strong, nonatomic) UIColor  *weekColor;
@property (strong, nonatomic) UIColor  *dayColor;
@end
@implementation XBCalendarCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pitchView.layer.masksToBounds = YES;
    
    self.pitchView.layer.cornerRadius  = CGRectGetWidth(self.pitchView.frame) / 2.f;
    
    self.weekColor = self.weekLabel.textColor;
    
    self.dayColor  = self.dayLabel.textColor;

}

- (void)setItemSelected:(BOOL)itemSelected
{
    _itemSelected = itemSelected;
    
    self.pitchView.hidden = !itemSelected;
    
    if (itemSelected) {
        
        self.weekLabel.textColor = [UIColor whiteColor];
        
        self.dayLabel.textColor  = [UIColor whiteColor];
        
    } else {
        
        self.dayLabel.textColor = self.dayColor;
        
        self.weekLabel.textColor = self.weekColor;
        
    }
}

@end
