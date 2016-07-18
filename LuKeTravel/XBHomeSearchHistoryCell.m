//
//  XBHomeSearchHistoryCell.m
//  LuKeTravel
//
//  Created by coder on 16/7/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeSearchHistoryCell.h"
#import "XBSearchHistory.h"
@implementation XBHomeSearchHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSearchHistory:(XBSearchHistory *)searchHistory
{
    _searchHistory = searchHistory;
    
    self.titleLabel.text = searchHistory.name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
