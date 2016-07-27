//
//  XBShareCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/26.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBShareCell.h"
#import "XBShare.h"
@implementation XBShareCell


- (void)setShare:(XBShare *)share
{
    _share = share;
    
    self.nameLabel.text = share.name;
    
    self.iconImageView.image = share.icon;
    
}

@end
