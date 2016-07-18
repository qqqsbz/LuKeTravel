//
//  XBHomeSearchCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/13.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeSearchCell.h"

@implementation XBHomeSearchCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = 5.f;
    
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
}

@end
