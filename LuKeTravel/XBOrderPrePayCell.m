//
//  XBOrderPrePayCell.m
//  LuKeTravel
//
//  Created by coder on 16/8/18.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBOrderPrePayCell.h"

@implementation XBOrderPrePayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSLayoutConstraint *constraint in self.separatorConstraints) {
        
        constraint.constant = 0.5f;
    }
    
    self.textColor = [UIColor colorWithHexString:@"#848484"];
    
    self.textFont = [UIFont systemFontOfSize:15.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
