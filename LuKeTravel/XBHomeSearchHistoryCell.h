//
//  XBHomeSearchHistoryCell.h
//  LuKeTravel
//
//  Created by coder on 16/7/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBSearchHistory;
@interface XBHomeSearchHistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) XBSearchHistory  *searchHistory;
@end
