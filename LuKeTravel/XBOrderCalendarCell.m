//
//  XBOrderCalendarCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/11.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderCalendarCell.h"

@implementation XBOrderCalendarCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.highLightView.layer.masksToBounds = YES;
    
    self.highLightView.layer.cornerRadius  = self.highLightView.xb_width / 2.f;
    
}

@end
